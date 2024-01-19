#!/bin/bash
set -e

source .env
source docker-compose.env

BACKUPDIR=backup
NOW=$(date +'%Y-%m-%d_%H:%M:%S')
DB_BACKUP=$BACKUPDIR/${COMPOSE_PROJECT_NAME}-db-$NOW.sql.gz
DB_COPIES=14
FILE_BACKUP=$BACKUPDIR/${COMPOSE_PROJECT_NAME}-filestore-$NOW.tar.gz
FILE_COPIES=2


mkdir -p $BACKUPDIR

docker-compose exec -T db mysqldump \
	--user=root \
	--password=$MYSQL_ROOT_PASSWORD \
	--host=$MYSQL_HOST $MYSQL_DATABASE \
	| tee 2>$BACKUPDIR/error.log | gzip -c >$DB_BACKUP

docker-compose exec -T seek tar cfz - -C / seek/filestore  > $FILE_BACKUP
find $BACKUPDIR -type f -name '*.sql.gz' -mtime +${DB_COPIES} -exec rm {} \;
find $BACKUPDIR -type f -name '*.tar.gz' -mtime +${FILE_COPIES} -exec rm {} \;

(cd $BACKUPDIR && ln -sf database-$NOW.sql.gz  database-current.sql.gz)
(cd $BACKUPDIR && ln -sf filestore-$NOW.tar.gz  filestore-current.tar.gz)


ls -l $FILE_BACKUP $DB_BACKUP
