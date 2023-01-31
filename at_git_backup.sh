#!/bin/bash
# author nahid barooti
# daily gitlab's backup

LOCAL_BACKUP_ROOT="/var/opt/gitlab/backups"
DATE=$(date +'%Y_%m_%d')

#BACKUP_FILE=".*ee_gitlab_backup.tar"
REMOTE_HOST="172.17.100.6"
REMOTE_BACKUP_ROOT="/Backup"
REMOTE_DB_ROOT="Gitlab"
REMOTE_MD5_ROOT="md5"
REMOTE_USER="git"
SCP_RATE="100000"
MAIL_SUBJECT="gitlab's backup"
MAIL_TO="app@asiatech.ir"
SEND_MAIL="/usr/bin/at_sendemail"
#ACTIVE_NUMBERS=$(/usr/bin/sms_num.sh)

/usr/bin/gitlab-rake gitlab:backup:create

sleep 1s 
BACKUP_FILE=$(ls $LOCAL_BACKUP_ROOT | grep $DATE )
/usr/bin/scp -r -l $SCP_RATE $LOCAL_BACKUP_ROOT/$BACKUP_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_ROOT/$REMOTE_DB_ROOT/

ERROR_STATUS=$?
if [ $ERROR_STATUS -ne 0 ]
then
        #sendsms "$ACTIVE_NUMBERS" "An error accureed while copying Gitlab dump files. For more info please check /var/opt/gitlab/backups"
	$SEND_MAIL "$MAIL_SUBJECT" "$MAIL_TO" "An error accureed while copying Gitlab dump files. For more info please check /var/opt/gitlab/backups"
else 
        #sendsms "$ACTIVE_NUMBERS" "at_backup_gitlab successfully."
	$SEND_MAIL "$MAIL_SUBJECT" "$MAIL_TO" "at_backup_gitlab successfully."
        rm -rf $LOCAL_BACKUP_ROOT/*.tar
fi

