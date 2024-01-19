#!/bin/bash

source .env

docker volume create ${COMPOSE_PROJECT_NAME}_db
docker volume create ${COMPOSE_PROJECT_NAME}_filestore
docker-compose up -d
docker-compose logs -f --tail 1
 
