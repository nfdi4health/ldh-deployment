# Einrichten der Apache Solr Suchmaschine

Seit Version 1.12 von FAIRDOM-SEEK muss [Apache Solr](https://solr.apache.org/) nun separat eingerichtet werden, anstatt die integrierte `Sunspot Solr` zu verwenden.

Diese Anleitung bezieht sich nur auf Bare-Metal-Installationen von FAIRDOM-SEEK. Er betrifft nicht die Verwendung einer [Docker](dockercomp.md)-basierten Installation, bei der die Änderungen bereits für Sie erledigt sind.

Es gibt zwei Alternativen zur Installation und Ausführung von Apache Solr. Wenn möglich, ist es am einfachsten, unser Docker-Image zu verwenden. Falls dies nicht möglich ist, finden Sie weiter unten auch einige Anweisungen zur direkten Installation von Apache Solr.

## Verwendung des Docker-Images

Die Verwendung von Docker ist die einfachste Lösung, um Solr, vorkonfiguriert für SEEK, mit demselben fairdom/seek-solr:8.11-Image auszuführen, das wir mit Docker compose verwenden.

Sie müssen zunächst [Docker installieren](https://docs.docker.com/engine/install/). Wir stellen Beispielskripte zum Einrichten und Starten sowie zum Beenden des Solr-Dienstes zur Verfügung:

- `script/start-docker-solr.sh`
    - Bei der ersten Ausführung wird das Image geholt, ein Volume erstellt, um die indizierten Daten zu speichern, und der Dienst gestartet. Er ist so eingestellt, dass er automatisch neu startet, wenn er nicht explizit gestoppt wird. Bei weiteren Ausführen wird der Dienst neu gestartet.
- `skript/stop-docker-solr.sh`
    - Wie bereits angedeutet, wird der Dienst damit gestoppt. Der Container und das Volume bleiben erhalten und können neu gestartet werden.

Diese Skripte sollten aus dem Stammverzeichnis Ihrer SEEK-Installation ausgeführt werden, z. B:
```bash
sh ./script/start-docker-solr.sh
```
Der Docker-Container erhält den Namen seek-solr und das Volume den Namen seek-solr-data-volume .

Sobald er läuft und die Suche aktiviert ist, können Sie Jobs auslösen, um alle durchsuchbaren Inhalte neu zu indizieren mit
```bash
bundle exec rake seek:reindex_all
```
Es gibt ein zusätzliches Skript, script/delete-docker-solr.sh, das verwendet werden kann, um sowohl den Container als auch das Volume zu löschen.

## Installation von Apache Solr

Im Folgenden werden die Schritte zur Installation und Einrichtung von Solr unter Ubuntu 20.04 beschrieben, aber der Prozess sollte für alle Debian-basierten Distributionen gleich und für andere sehr ähnlich sein. Er basiert auf der Anleitung auf https://tecadmin.net/install-apache-solr-on-ubuntu-20-04/, aber die folgenden Schritte wurden für Solr 8.11.1 aktualisiert.

Zuerst sollten Sie sicherstellen, dass Java 11 installiert ist. OpenJDK ist in Ordnung
```bash
sudo apt update
sudo apt install openjdk-11-jdk
```
Überprüfen Sie dies mit
```bash
java -version
```
Wenn eine andere Version angezeigt wird, verwenden Sie den folgenden Befehl und wählen Sie die Nummer für die richtige Version
```bash
sudo update-alternatives --config java
```
Der nächste Schritt ist das Herunterladen und Installieren von Solr in /opt/ und das Einrichten als Dienst
```bash
cd /opt
sudo wget https://downloads.apache.org/lucene/solr/8.11.1/solr-8.11.1.tgz
sudo tar xzf solr-8.11.1.tgz solr-8.11.1/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-8.11.1.tgz
```
Die Dienste können auf die übliche Weise gestoppt und gestartet werden mit
```bash
sudo dienst solr stop
sudo dienst solr start
```
Nun müssen Sie den für SEEK konfigurierten Kern einrichten. Wechseln Sie in das Stammverzeichnis der SEEK-Installation (in diesem Beispiel /srv/rails/seek)
```bash
cd /srv/rails/seek
sudo su - solr -c "/opt/solr/bin/solr create -c seek -d $(pwd)/solr/seek/conf"
```

Die Konfiguration und die Daten für den SEEK-Kern befinden sich in `/var/solr/data/seek`.

Sie sollten in der Lage sein, zu bestätigen, dass der Dienst läuft und der Kern eingerichtet ist, indem Sie http://localhost:8983/solr besuchen.

Solr ist nun eingerichtet, und Sie können Aufträge zur Neuindizierung des Inhalts mit
```bash
bundle exec rake seek:reindex_all
```

