#!/bin/bash
set -e

# 1. Neue Images holen
docker compose pull

# 2. Nur die benötigten Services starten
docker compose up -d db solr seek

# 3. Upgrade durchführen
docker compose exec seek docker/upgrade.sh

# 4. Komplett neu starten, damit alle Services mit neuen Images laufen
docker compose up -d --force-recreate

