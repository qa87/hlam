root@prod:/home# cat ./blocker.pl
#!/usr/bin/perl




($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$mon=$mon+1;
$year=$year+1900;

#printf("Time Format - HH:MM:SS\n");
$current_date = sprintf(" %02d-%02d-%02d %02d:%02d:%02d", $year, $mon, $mday, $hour, $min, $sec);




use DBI;

# Connect to the database.
$dbh = DBI->connect("DBI:mysql:database=intercom;host=172.16.22.5",
                       "root", "docker",
                       {'RaiseError' => 1});

#exit unless -e '/var/lock/subsys/iptables'; # не всегда есть этот файл при работающем файерволе

my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my $date = sprintf ("%s %d %02d:",sub {($abbr[$_[4]], $_[3], $_[2])}->(localtime));

#$date = "Nov 18 07:";
$date =~ s/([a-zA-Z]{3} )(\d )/$1 $2/;
#print "date $date\n";
my $buffer = `/usr/bin/tail -n 5000 /usr/src/dispatcher/logs/voip/voip-* | grep '$date'`;

#print $buffer;

my @buff = split /\n/,$buffer;
my %seen = ();

foreach (@buff) {
    if (/No matching peer found|Wrong password|fake auth rejection|Device does not match ACL|Registration from/i) {
        #/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(\D*)(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/g;
        / failed for \'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/;
        print "\n1 =$1\n";
        ++$seen{$1} if $1 !~ /^77.50.0.|^172.16.|0.0.0.0/;
    }
}

foreach my $key (keys (%seen)) {

    if ($seen{$key}>1) {
        print "key $key\n";


        #перебор сетей из базы
        my $sth = $dbh->prepare("SELECT ip FROM whitelist");
        $sth->execute() or die $DBI::errstr;
        while (my @row = $sth->fetchrow_array()) {
           my ($wip) = @row;
            $find_net = $wip;
            $some_ip  = $key;
            ($net_ip, $net_mask) = split(/\//, $find_net);
            ($ip1, $ip2, $ip3, $ip4) = split(/\./, $net_ip);
            $net_ip_raw = pack ('C4', $ip1, $ip2, $ip3, $ip4);
            $net_mask_raw = pack ('B32', (1 x $net_mask), (1 x (32 - $net_mask)));
            ($sip1, $sip2, $sip3, $sip4) = split(/\./, $some_ip);
            $some_ip_raw = pack ('C4', $sip1, $sip2, $sip3, $sip4);
            if (($some_ip_raw & $net_mask_raw) eq ($net_ip_raw & $net_mask_raw)){
                #print "$some_ip входит в подсеть $find_net \n";
            }
            else{
        #Добавить правило первым (Insert)
                if (`grep '$key' /root/ipset.rules` eq "") {
                    `/sbin/ipset add users-ip $key;/bin/echo 'add users-ip $key' >> /root/ipset.rules;`;
                    $dbh->do("INSERT INTO firewall (ip,notice,created_at) VALUES ('$key','hacker','$current_date')");
                };
            }
        }

    }
}

# Disconnect from the database.
$dbh->disconnect();
