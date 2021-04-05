#!/usr/bin/perl -w

$a = `ping -c 3 93.178.96.206`;
#$a = `ping -c 3 93.178.96.207`;

print "$a \n";
if ($a=~/100\%/g){
    print "bad \n";
    `/usr/bin/curl 'https://api.telegram.org/bot1691522779:AAFzhdmur27S1lddkZwzteiComqDkHtTFp0/sendMessage?chat_id=-577945040&text=TFOMS_loss'`;

    }
    else {
        print "good \n";
    };
#/usr/bin/curl 'https://api.telegram.org/bot1691522779:AAFzhdmur27S1lddkZwzteiComqDkHtTFp0/sendMessage?chat_id=-577945040&text=131313!'
