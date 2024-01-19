#!/bin/bash

docker-compose down
docker-compose pull
# avoid the seek-workers, which will interfere
docker-compose up -d seek db solr   
docker-compose exec seek docker/upgrade.sh 
docker-compose down
docker-compose up -d
 
