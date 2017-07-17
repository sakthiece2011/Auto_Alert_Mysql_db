#!/usr/bin/bash

#Script to run automated sql queries

###################################################################################
#Step 1:- #Declaring mysql DB connection 
#################################################################################


MASTER_DB_USER='username'
MASTER_DB_PASSWD='pwd'
MASTER_DB_PORT=33006
MASTER_DB_HOST='hostname'
MASTER_DB_NAME='db_name'

###################################################################################
#Step 2:- #Prepare sql query 
#################################################################################

SQL_Query='select * from table_name* limit 10'

###################################################################################
#Step 3:- #mysql command to connect to database
#################################################################################

output=$(mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -P$MASTER_DB_PORT -h$MASTER_DB_HOST -D$MASTER_DB_NAME <<EOF 
$SQL_Query
EOF
)
echo "$output" >> result.txt

###################################################################################
#Step 4:- Sending mail Notification with attached result
#################################################################################

###############To EmailIds:#########

ToEmailId="userid@doamin.com";
FileDir=dirname

####################################


echo "Hi Team," > $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt

echo "Please find the attached query result file generated at [ `date +%c` ]".  >> $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt
echo "This is a System generated email. Please don't reply to the email." >> $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt
echo "Thanks & Regards" >> $FileDir/MailTextFile.txt
echo "AEUS Team" >> $FileDir/MailTextFile.txt
cat $FileDir/MailTextFile.txt | 
    mailx -v -a $FileDir/result.txt -s "SQL Query result [ `date | awk '{print $1,$2,$3}'` ]" \
    -S smtp-use-starttls \
    -S ssl-verify=ignore \
    -S smtp-auth=login \
    -S smtp=smtp://outlook.office365.com:587 \
    -S from=alert@domain.com \
    -S smtp-auth-user=alert@domain.com \
    -S smtp-auth-password=pwd \
    -S nss-config-dir="/etc/pki/nssdb/" \
    $ToEmailId

###################################################################################
#Step 5:- Removing Temp Files
##################################################################################

rm $FileDir/MailTextFile.txt
rm $FileDir/result.txt