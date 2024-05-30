#!/bin/bash

# using docker-compose instead of docker compose for better compatibility

source .env
source docker-compose.env

usage() {
    echo -e "Usage: $0 database.sql.gz filestore.tar.gz"
	echo Stack should be up and running
}

if [ $# -ne 2 ]
then
  usage
  exit 1
fi

DB_BACKUP=$1
FILE_BACKUP=$2

echo restore database
gzip -cd ${DB_BACKUP}| docker-compose exec -T db mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE

echo restore filestore
docker-compose cp ${FILE_BACKUP} seek:/seek/filestore.tar.gz
docker-compose exec seek tar xfz filestore.tar.gz -C / 
docker-compose exec seek rm -f filestore.tar.gz

echo reindex solar
docker-compose exec seek bundle exec rake seek:reindex_all



