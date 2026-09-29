#!/bin/bash
set -e

# 1. Neue Images holen
docker compose pull

# 2. Nur die benötigten Services starten
docker compose up -d db solr seek

# 3. Upgrade durchführen (Migrationen etc.)
docker compose exec seek docker/upgrade.sh

# 4. Optional: Rails-Cache und alte Artefakte im laufenden Container bereinigen
docker compose exec seek bundle exec rake tmp:clear

# 5. Optional: Solr-Index neu aufbauen (falls beim Update das Schema gewechselt hat)
docker compose exec seek bundle exec rake seek:reindex_all

# 6. Komplett neu starten, damit alle Services (inkl. Web-Worker/Puma etc.) mit neuen Images laufen
docker compose up -d --force-recreate
