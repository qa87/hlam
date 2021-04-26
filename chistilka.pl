#!/bin/perl

if (ddf()>75){
    for($y=365; $y>10; $y--){ #оставит столько дней
        #$a=`/usr/bin/find /var/spool/asterisk/ -type f -mtime +$y`;
        $a=`/usr/bin/find /var/spool/asterisk/monitor -type f -mtime +365 -name "*.mp3" -delete`;
        if (ddf()<75){
            break;
            }
    }
}


sub ddf{
my $d = `df -h`;
my $i=1;
my @x=split(/\s+/,$d);
    foreach $list(@x) {
    if($i==12){
        $list=~s/\D//g;
        $z=$list;
    }

        $i++;
    }

return $z;
}
