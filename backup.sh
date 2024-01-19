#!/bin/bash
set -e

source .env
source docker-compose.env

BACKUPDIR=backup
NOW=$(date +'%Y-%m-%d_%H:%M:%S')
DB_BACKUP=$BACKUPDIR/$MYSQL_DATABASE-$NOW.sql.gz
FILE_BACKUP=$BACKUPDIR/filestore.tar.gz
RETAIN=14


mkdir -p $BACKUPDIR

docker-compose exec -T db mysqldump \
	--user=root \
	--password=$MYSQL_ROOT_PASSWORD \
	--host=$MYSQL_HOST $MYSQL_DATABASE \
	| tee 2>$BACKUPDIR/error.log | gzip -c >$DB_BACKUP

docker-compose exec -T seek tar cfz - -C / seek/filestore  > $FILE_BACKUP
find $BACKUPDIR -type f -name '*.sql.gz' -mtime +${RETAIN} -exec rm {} \;
(cd $BACKUPDIR && ln -sf $MYSQL_DATABASE-$NOW.sql.gz  $MYSQL_DATABASE-current.sql.gz)


ls -l $FILE_BACKUP $DB_BACKUP
