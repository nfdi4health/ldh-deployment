# Installation von LDH in einer Produktionsumgebung

Diese Seite enthält einige zusätzliche Hinweise zur Einrichtung von SEEK für die Produktion (d.h. für den realen Einsatz und nicht für die Entwicklung).

Wenn Sie diese zusätzlichen Hinweise lesen und befolgen, werden Sie mehr Leistung aus SEEK herausholen und die laufende Wartung reduzieren.

Wenn Sie SEEK unter einer Sub-URI laufen lassen wollen, z.B. example.com/seek, dann lesen und befolgen Sie bitte Installieren unter einer Sub-URI am Ende der Installation.
## Bevor Sie SEEK installieren

Dadurch wird sichergestellt, dass einige der Rake-Aufgaben die entsprechende Datenbank betreffen.

Um später Zeit zu sparen, sind auch einige zusätzliche Pakete zu installieren:
```bash
sudo apt-get install libapr1-dev libaprutil1-dev
```
Legen Sie zunächst einen Benutzer an, dem die SEEK-Anwendung gehört:
```bash
sudo useradd -m seek
```
Wir empfehlen, SEEK in /srv/rails/seek zu installieren - zuerst müssen Sie dieses Verzeichnis erstellen und seek die entsprechenden Rechte erteilen
```bash
sudo mkdir -p /srv/rails
sudo chown seek:seek /srv/rails
```
Wechseln Sie nun zum Benutzer seek
```bash
sudo su - seek
cd /srv/rails
```
Bevor Sie der Standardinstallations-Anleitung folgen, müssen Sie eine Umgebungsvariable setzen, die anzeigt, dass Sie SEEK als Produktionssystem einrichten und ausführen wollen.
```bash
export RAILS_ENV=production
```
Sie müssen diese Variable zurücksetzen, wenn Sie Ihre Shell schließen und eine neue Sitzung starten.

Sie können nun der allgemeinen Installationsanleitung folgen und dann zu dieser Seite zurückkehren, um einige zusätzliche Schritte auszuführen, damit SEEK zusammen mit Apache läuft und auch die erforderlichen Dienste automatisiert werden.

Wenn Sie Probleme mit der Anforderung eines sudo-Passworts während der RVM-Schritte haben - richten Sie RVM und ruby-1.9.3 zunächst als Benutzer mit sudo-Zugang ein und wiederholen Sie die Schritte als seek-Benutzer. Das bedeutet, dass die benötigten Pakete dann installiert sein sollten. Zum Zeitpunkt der Erstellung dieser Anleitung sollte dies nicht notwendig sein.

## Bundler-Konfiguration

Wenn Sie Gems mit Bundler installieren, konfigurieren Sie zunächst mit
```bash
bundle config set deployment 'true'
bundle config set ohne 'development test'
```
Dies verhindert, dass Edelsteine versehentlich geändert werden und vermeidet auch, dass unnötige Edelsteine installiert werden.

# Nachdem Sie SEEK installiert haben
## Kompilieren von Assets

Assets - wie Bilder, Javascript und Stylesheets - müssen vorkompiliert werden, d. h. sie werden verkleinert, in einer einzigen Datei zusammengefasst und komprimiert. Diese werden dann in public/assets abgelegt. Um sie zu kompilieren, führen Sie den folgenden Befehl aus. Dies kann einige Zeit in Anspruch nehmen, haben Sie also Geduld
```bash
bundle exec rake assets:precompile
```
## Bedienung von SEEK durch Apache

Zuerst müssen Sie [Passenger Phusion](https://www.phusionpassenger.com/library/install/apache/install/oss/bionic/) einrichten.
### Passenger installieren

Die folgenden Schritte sind der obigen Anleitung entnommen:

Installieren Sie den PGP-Schlüssel:
```bash
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
```
apt-Repository hinzufügen:
```bash
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
```
Installieren Sie das Apache-Modul:
```bash
sudo apt-get install -y libapache2-mod-passenger
```
Aktivieren Sie das Modul:
```bash
sudo a2enmod passenger
sudo apache2ctl restart
```
Überprüfen Sie, ob alles funktioniert:
```bash
sudo /usr/bin/passenger-config validate-install
```
## Apache-Konfiguration

Erstellen Sie nun eine Definition des virtuellen Hosts für SEEK:
```bash
sudo nano /etc/apache2/sites-available/seek.conf
```
die wie folgt aussieht (wenn Sie einen DNS für Ihre Site registriert haben, setzen Sie ServerName entsprechend):
```bash
<VirtualHost *:80>
  ServerName www.yourhost.com

  PassengerRuby /usr/local/rvm/rubies/seek/bin/ruby

  DocumentRoot /srv/rails/seek/public
   <Directory /srv/rails/seek/public>
      # This relaxes Apache security settings.
      Allow from all
      # MultiViews must be turned off.
      Options -MultiViews
      Require all granted
   </Directory>
   <LocationMatch "^/assets/.*$">
      Header unset ETag
      FileETag None
      # RFC says only cache for 1 year
      ExpiresActive On
      ExpiresDefault "access plus 1 year"
   </LocationMatch>
</VirtualHost>
```
(Beachten Sie, dass wir in der PassengerRuby-Direktive auf unseren Alias "seek" verweisen).

Der LocationMatch-Block weist den Apache an, die Assets (Bilder, CSS, Javascript) mit einer langen Verfallszeit auszuliefern, was zu einer besseren Leistung führt, da diese Elemente im Cache gespeichert werden. Möglicherweise müssen Sie die Module headers und expires für Apache aktivieren:
```bash
sudo a2enmod headers
sudo a2enmod expires
```
Aktivieren Sie nun die SEEK-Site und deaktivieren Sie den Standard, der mit Apache installiert ist, und starten Sie neu:
```bash
sudo a2ensite seek
sudo a2dissite 000-default
sudo service apache2 restart
```
Wenn Sie nun http://localhost besuchen (beachten Sie, dass es keinen 3000er Port gibt), sollten Sie SEEK sehen.

Wenn Sie SEEK neu starten wollen, vielleicht nach einem Upgrade, ohne Apache neu zu starten, können Sie dies tun, indem Sie (als Benutzer seek)
```bash
touch /srv/rails/seek/tmp/restart.txt
```

## Konfigurieren für HTTPS

Wir empfehlen dringend die Verwendung von [Lets Encrypt](https://letsencrypt.org/) für kostenlose SSL-Zertifikate.
## Einrichten der Dienste

Die folgenden Schritte zeigen, wie Sie delayed_job und soffice so einrichten, dass sie als Dienst laufen und automatisch gestartet und heruntergefahren werden, wenn Sie den Server neu starten. Apache Solr sollte bereits eingerichtet sein, wenn Sie den Anweisungen zur [Einrichtung von Solr](./solr.md) folgen.
### Delayed Job Hintergrunddienst

Erstellen Sie die Datei /etc/init.d/delayed_job-seek und kopieren Sie den Inhalt von `scripts/delayed_job-seek` in diese Datei.

Ausführen:
```bash
sudo chmod +x /etc/init.d/delayed_job-seek
sudo update-rc.d delayed_job-seek Voreinstellungen
``` 
Starten Sie es mit:
```bash
sudo /etc/init.d/delayed_job-seek start
```