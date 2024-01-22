# Docker
## Verwenden von Docker Compose

Mit Docker Compose können Sie SEEK in Docker zusammen mit MySQL und SOLR ausführen, die in eigenen Containern als Mikrodienste ausgeführt werden.

Zunächst muss [Docker installiert](https://docs.docker.com/engine/install/) sein. 
Informationen zur Installation von Docker Compose finden Sie im Docker Compose-Installationshandbuch.

Nach der Installation sind lediglich die Dateien `docker-compose.yml` und `docker/db.env` erforderlich. Sie können sich aber auch einfach die SEEK-Quelle von GitHub ansehen – siehe [LHD installieren](./install_dev.md#ldh-installieren). Wir empfehlen Ihnen, die Passwörter in der Datei `db.env` zu ändern.

Zuerst müssen Sie 4 Volumes erstellen
```bash
Docker-Volume erstellen --name=seek-filestore
Docker-Volume erstellen --name=seek-mysql-db
Docker-Volume erstellen --name=seek-solr-data
Docker-Volume erstellen --name=seek-cache
```
und dann zum Starten die Datei docker-compose.yml in Ihrem aktuellen Verzeichnis ausführen
```
docker-compose up -d
```
und gehen Sie zu http://localhost:3000. Es kann zu einer kurzen Verzögerung kommen, bevor Sie eine Verbindung herstellen können, insbesondere wenn dies das erste Mal ist und verschiedene Dinge initialisiert werden.

den Lauf stoppen
```
docker-compose down
```
Sie ändern den Port und das Bild in der docker-compose.yml durch Bearbeiten
```bash
seek:
    ..
    ..
    image: fairdom/seek:1.13
    ..
    ..
    ports:
          - "3000:3000"
```
## Proxy über NGINX oder Apache

Als Alternative zum Ändern des Ports (insbesondere wenn mehrere Instanzen auf demselben Computer ausgeführt werden) können Sie einen Proxy über Apache oder Nginx durchführen. Z.B. Für Nginx würden Sie einen virtuellen Host wie folgt konfigurieren:
```bash
server {
    listen 80; 
    server_name www.my-seek.org;
    client_max_body_size 2G;
    
    location / {
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $host:$server_port;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_pass         http://127.0.0.1:3000;
    }
}
```
Für Apache würde der virtuelle Host Folgendes umfassen:
```bash
UseCanonicalName on
ProxyPreserveHost on
<Location />
     ProxyPass   http://127.0.0.1:3000/ Keepalive=On
     ProxyPassReverse http://127.0.0.1:3000/
</Location>
```
Sie möchten auch HTTPS (Port 443) konfigurieren und empfehlen dringend die Verwendung von Lets Encrypt für kostenlose SSL-Zertifikate.
## Sichern und Wiederherstellen

Um die MySQL-Datenbank zu sichern und den Dateispeicher zu suchen, müssen Sie die Volumes in einem temporären Container bereitstellen. Versuchen Sie nicht, ein Backup zu erstellen, indem Sie die Volumes direkt vom Hostsystem kopieren. Im Folgenden finden Sie ein Beispiel für ein grundlegendes Verfahren. Wir empfehlen Ihnen jedoch, Datenvolumes sichern, wiederherstellen oder migrieren zu lesen und sich mit der Bedeutung der Schritte vertraut zu machen.
```bash
docker-compose stop
docker run --rm --volumes-from seek -v $(pwd):/backup ubuntu tar cvf /backup/seek-filestore.tar /seek/filestore
docker run --rm --volumes-from seek-mysql -v $(pwd):/backup ubuntu tar cvf /backup/seek-mysql-db.tar /var/lib/mysql
docker-compose start
```
und zum Wiederherstellen in neue Volumes:
```bash
docker-compose down
docker volume rm seek-filestore 
docker volume rm seek-mysql-db     
docker volume create --name=seek-filestore
docker volume create --name=seek-mysql-db
docker-compose up --no-start
docker run --rm --volumes-from seek -v $(pwd):/backup ubuntu bash -c "tar xfv /backup/seek-filestore.tar"
docker run --rm --volumes-from seek-mysql -v $(pwd):/backup ubuntu bash -c "tar xfv /backup/seek-mysql-db.tar"
docker-compose up -d  
```
**Beachten Sie**, dass es beim Zurücksetzen einer Version, beispielsweise nach einem fehlgeschlagenen Upgrade, besonders wichtig ist, die Volumes „seek-filestore“ und „seek-mysql-db“ zu entfernen und neu zu erstellen – andernfalls könnten zusätzliche Dateien übrig bleiben, wenn das Backup übertrieben wiederhergestellt wird .

Der Cache und der Solr-Index müssen nicht gesichert werden. Sobald der Solr-Index betriebsbereit ist, kann er bei Bedarf neu generiert werden mit:
```bash
docker exec seek bundle exec rake seek:reindex_all
```
## Upgrade zwischen Versionen

Der Vorgang ist dem Upgrade eines Basiscontainers sehr ähnlich.

Aktualisieren Sie zunächst die `docker-compose.yml` auf die neue Version. Sie können die Version anhand des Image-Tags erkennen – z. B. für 1.13
```
image: fairdom/seek:1.13
```

Führen Sie mit der neuen Datei docker-compose.yml Folgendes aus:
```
docker-compose down
docker-compose pull
docker-compose up -d seek db solr            # avoiding the seek-workers, which will interfere    
docker exec -it seek docker/upgrade.sh
docker-compose down
docker-compose up -d
```
## Wechsel von einer eigenständigen Installation zu Docker Compose

Wenn Sie eine bestehende SEEK-Installation auf „Bare Metal“ haben und auf die Verwendung von Docker Compose umsteigen möchten, haben wir ein Skript, das Ihnen bei der Migration der Daten helfen kann. Das Skript wurde erstellt, um bei der Umstellung einiger unserer eigenen Dienste zu helfen, wurde darüber hinaus aber nicht umfassend getestet. Bitte verwenden Sie es daher mit Vorsicht.

Zunächst wird ein Dump der MySQL-Datenbank benötigt, der mit `mysqldump` erstellt werden kann
```
mysqldump -u<Benutzer> -p <Datenbankname> > seek.sql
```
Kopieren Sie sowohl `seek.sql` als auch das Verzeichnis `filestore/` in ein separates Verzeichnis, z. B.:
```bash
mkdir /tmp/seek-migration
cp -rf filestore/ /tmp/seek-migration/
cp seek.sql /tmp/seek-migration/
```
Das zu verwendende Skript finden Sie unter https://github.com/nfdi4health/ldh/blob/main/script/import-docker-data.sh

Beginnen Sie mit einer sauberen Docker Compose-Einrichtung wie oben beschrieben. Wenn Sie das Skript ausführen und den Speicherort des Verzeichnisses angeben, werden alle vorhandenen Volumes gelöscht, neue Volumes erstellt und mit den Sql- und Dateispeicherdaten gefüllt.
```bash
wget https://github.com/seek4science/seek/raw/seek-1.13/script/import-docker-data.sh
sh ./import-docker-data.sh /tmp/seek-migration/
```
## Verwendung einer Sub-URI

Wenn Sie SEEK unter einer Sub-URI (z. B. https://yourdomain.com/seek/) ausführen möchten, können Sie die alternative Datei `docker-compose-relative-root.yml` verwenden:
```bash
docker-compose -f docker-compose-relative-root.yml up -d
```
Um die Sub-URI (standardmäßig `/seek`) anzupassen, ändern Sie die Variable `RAILS_RELATIVE_URL_ROOT` in dieser Datei in den Abschnitten seek und seek_workers.

Bitte beachten Sie, dass Sie beim Hinzufügen/Ändern/Entfernen der `RAILS_RELATIVE_URL_ROOT` in einem bestehenden Container die Assets neu kompilieren und den Cache löschen müssen:
```bash
docker exec seek bundle exec rake assets:precompile
docker exec seek bundle exec rake tmp:clear
```
