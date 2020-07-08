#!/bin/bash
# Author: kienlt

# Config
USERNAME="postgres"
PASSWORD="123456"
HOST="localhost"
EXCLUDE_DB="postgres" # single db support only right now :(
BACKUP_PATH="/root/pg_backup"
DATEFORMAT=$(date +"%Y_%m_%d_%I_%M_%p")
DAYS_TO_KEEP=3

# Check backup path
echo -e "\nChecking backup path"
if ! test -d $BACKUP_PATH
then
	echo "Creating $BACKUP_PATH"
	mkdir -p $BACKUP_PATH
	echo "DONE create backup path: $BACKUP_PATH"
else
	echo "Backup path: $BACKUP_PATH available"
fi

ALL_DB="select datname from pg_database where not datistemplate and datallowconn and datname !~ '$EXCLUDE_DB' order by datname;"

echo -e "\n\nPerforming backup database"
echo -e "----------------------------\n"
echo -e "Exclude DB: $EXCLUDE_DB"
echo -e "List DB to be backup: \n"
PGPASSWORD=$PASSWORD psql -h $HOST -U $USERNAME -At -c "$ALL_DB"

echo -e "----------------------------\n"
for DB in `PGPASSWORD=$PASSWORD psql -h $HOST -U $USERNAME -At -c "$ALL_DB"`
do
  echo "Doing Backup DB: $DB to $BACKUP_PATH/${DB}_${DATEFORMAT}"
  PGPASSWORD=$PASSWORD pg_dump -h $HOST -U $USERNAME -F t $DB > $BACKUP_PATH/${DB}_${DATEFORMAT}.tar
  echo "Backup DB: $DB DONE"
done	

echo -e "Removing backup files older than $DAYS_TO_KEEP"
find $BACKUP_PATH -maxdepth 1 -mtime $DAYS_TO_KEEP -exec rm '{}' ';'
echo -e "Removed backup files older than $DAYS_TO_KEEP"
