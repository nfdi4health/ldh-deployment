#!/bin/bash

# using docker-compose instead of docker compose for better compatibility

source .env
source docker-compose.env

BACKUPDIR=backup
FILE_BACKUP=$BACKUPDIR/filestore.tar.gz

usage() {
    echo -e "Usage: $0 [dump]"
	echo filestore would be restored from $FILE_BACKUP
	echo Stack should be up
}

if [ $# -ne 1 ]
then
  usage
  exit 1
fi

DB_BACKUP=$1

mkdir -p $BACKUPDIR

DB_BACKUP=$1
FILE_BACKUP=$BACKUPDIR/filestore.tar.gz

echo restore database
gzip -cd ${DB_BACKUP}| docker-compose exec -T db mysql -u seek --password=$MYSQL_PASSWORD seek

echo restore filestore
docker-compose cp backup/filestore.tar.gz seek:/seek
docker-compose exec seek tar xfz filestore.tar.gz -C / 
docker-compose exec seek rm -f filestore.tar.gz

echo reindex solar
docker-compose exec seek bundle exec rake seek:reindex_all



