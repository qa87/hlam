#!/usr/bin/perl -w

$a = `ping -c 3 93.178.96.206`; #TFOMS
#$a = `ping -c 3 93.178.96.207`;

print "$a \n";
if ($a=~/100\%/g){
    print "bad_TFOMS \n";
    `/usr/bin/curl 'https://api.telegram.org/bot1691522779:AAFzhdmur27S1lddkZwzteiComqDkHtTFp0/sendMessage?chat_id=-577945040&text=TFOMS_loss'`;
    
    }
    else {
	print "good_TFOMS \n";
    };

$b = `ping -c 3 85.172.109.58`;#Maslov
#$b = `ping -c 3 93.178.96.207`;

print "$b \n";
if ($b=~/100\%/g){
    print "bad Maslov \n";
    `/usr/bin/curl 'https://api.telegram.org/bot1691522779:AAFzhdmur27S1lddkZwzteiComqDkHtTFp0/sendMessage?chat_id=-577945040&text=Maslov_loss'`;

    }
    else {
    print "good Maslov \n";
    };

$c = `ping -c 3 as.ddns.net`;#AS
#$b = `ping -c 3 93.178.96.207`;

print "$c \n";
if ($c=~/100\%/g){
    print "bad AS \n";
    `/usr/bin/curl 'https://api.telegram.org/bot1691522779:AAFzhdmur27S1lddkZwzteiComqDkHtTFp0/sendMessage?chat_id=-577945040&text=AS_loss'`;

    }
    else {
    print "good AS \n";
    };


#/usr/bin/curl 'https://api.telegram.org/bot1691522779:AAFzhdmur27S1lddkZwzteiComqDkHtTFp0/sendMessage?chat_id=-577945040&text=131313!'
