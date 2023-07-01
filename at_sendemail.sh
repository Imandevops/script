#!/bin/bash

HOST=$(eval "/bin/hostname")
DATE=$(date +'%Y-%m-%d %H:%M:%S')
smtp="smtp.asiatech.ir:25"
auth="login"
user="devops.notification@asiatech.ir"
pass=test
nss_dir="/etc/pki/nssdb/"
subject=$1
to=$2
CC=$4
echo -e "Dear Admins,<br /><br /> $3 <br /> <br />Mail from: $HOST<br />DATE: $DATE" > /tmp/.tmp_mail

/usr/bin/sendemail -f $user -t $to -cc $CC -u $subject -m "$(cat /tmp/.tmp_mail)"  -s $smtp  -xu $user  -xp $pass  -o tls=yes -o message-content-type=html

