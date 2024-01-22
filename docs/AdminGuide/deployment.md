# NFDI4Health LDH Deployment
Anweisungen und Ressourcen für die Einrichtung eines NFDI4Health Local Data Hup.

## Haftungsausschluss
Dieses Projekt und seine Komponenten sind Gegenstand intensiver Entwicklung und werden daher als *[Alpha][wiki-alpha]*-Version betrachtet. Verwenden Sie diese Bereitstellungsmethode **noch** nicht für Produktionszwecke, da Sie in Zukunft gezwungen sein könnten, eine Neuinstallation durchzuführen, was zum Verlust der hochgeladenen Daten führen könnte. Wenn Sie jedoch versuchen möchten, an der Entwicklung der Software teilzunehmen, sind Sie hiermit herzlich eingeladen, dies zu tun. Fühlen Sie sich frei, Fehlerberichte und Vorschläge im Issue Tracker zu erstellen.

## Voraussetzungen
### Docker
* Docker muss auf dem System installiert sein. Bitte folgen Sie den [offiziellen Installationsanweisungen][docker-install]
* Denken Sie auch daran, einem Nicht-Root-Linux-Benutzer die Verwendung von Docker zu erlauben, indem Sie ihn zur Docker-Gruppe hinzufügen (siehe [Docker][docker-ugroup]-Dokumentation), da sonst nur ein Root-Benutzer in der Lage ist, Docker auszuführen.
## Verwendung
Um einen ersten und einfachen Einblick zu bekommen, wie eine ldh aussehen wird, folgen Sie den folgenden Schritten.

* Klonen Sie dieses Repository
```bash
git clone https://github.com/nfdi4health/ldh-deployment.git
cd ldh-deployment
```
* Kopieren Sie docker-compose.env.tpl nach docker-compose.env und ersetzen Sie <some-password> durch ein Passwort
```bash
cat docker-compose.env.tpl \
  | sed "s|<db-password>|$(openssl rand -base64 21)|" \
  | sed "s|<root-password>|$(openssl rand -base64 21)|" \
  > docker-compose.env
```  
* Verwenden Sie compose zum Starten des LDH
```
docker compose up -d
```



[wiki-alpha]: https://en.wikipedia.org/wiki/Software_release_life_cycle#Alpha
[project-issues]: https://github.com/nfdi4health/ldh-deployment/issues
[docker-install]: https://docs.docker.com/get-docker/
[docker-ugroup]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
