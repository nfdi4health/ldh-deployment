#!/bin/bash
set -e

source .env
source docker-compose.env

BACKUPDIR=backup
# dont use : in time
NOW=$(date +'%Y-%m-%dT%H-%M-%S')
DB_BACKUP=${COMPOSE_PROJECT_NAME}-db-$NOW.sql.gz
DB_COPIES=14
FILE_BACKUP=${COMPOSE_PROJECT_NAME}-filestore-$NOW.tar.gz
FILE_COPIES=2


mkdir -p $BACKUPDIR

docker-compose exec -T db mysqldump \
	--user=root \
	--password=$MYSQL_ROOT_PASSWORD \
	--host=$MYSQL_HOST $MYSQL_DATABASE \
	| tee 2>$BACKUPDIR/error.log | gzip -c >$BACKUPDIR/$DB_BACKUP

docker-compose exec -T seek tar cfz - -C / seek/filestore  > $BACKUPDIR/$FILE_BACKUP
find $BACKUPDIR -type f -name '*.sql.gz' -mtime +${DB_COPIES} -exec rm {} \;
find $BACKUPDIR -type f -name '*.tar.gz' -mtime +${FILE_COPIES} -exec rm {} \;

(cd $BACKUPDIR && ln -sf $DB_BACKUP  database.sql.gz)
(cd $BACKUPDIR && ln -sf $FILE_BACKUP  filestore.tar.gz)


ls -l $BACKUPDIR/$FILE_BACKUP $BACKUPDIR/$DB_BACKUP
