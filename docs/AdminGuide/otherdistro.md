# Anleitung für andere Distributionen
- [Linux](#installation-von-seek-für-andere-linux-distributionen)
   - [Linux Mint 18](#linux-mint-18)
   - [Fedora 20 / RHEL / CentOS](#fedora-20--rhel--centos)
      - [Pakete](#pakete)
      - [Installieren von RVM](#installieren-von-rvm)
      - [Einrichten der Datenbank](#einrichten-der-datenbank)
      - [Einrichten für die Produktion mit Passenger Phusion](#einrichten-für-die-produktion-mit-passenger-phusion)
      - 
   - [Ubuntu 20.04 (LTS)](#ubuntu-2004-lts)
   - [Debian](#debian)
- [Mac OS](#installation-von-seek-für-mac-os-x)
   - [Catalina](#catalina)
      - [Installieren der Pakete](#installieren-der-pakete)
      - [Einrichten von MySQL](#einrichten-von-mysql)
      - [PostGres Gem installieren](#postgres-gem-installieren)
      - [Puma Gem installieren](#puma-gem-installieren)
      - [Andere Hinweise](#andere-hinweise)
      - [Verbindung zu MySQL von einem Client aus](#verbindung-zu-mysql-von-einem-client-aus)
   



# Installation von SEEK für andere Linux-Distributionen

Unsere [Installationsanleitung](./install_dev.md) basiert auf der Ubuntu 20.04 (LTS) Distribution und Version. Abgesehen von den Distributionspaketen sollte der Installationsprozess für andere Distributionen jedoch sehr ähnlich sein.

Für einige andere gängige Distributionen beschreiben wir hier die erforderlichen Distributionspakete und alle anderen Unterschiede zu unserer allgemeinen Installationsanleitung, die uns bekannt sind.
## Linux Mint 18
---
Sobald SEEK installiert ist und läuft, sollte es keine Probleme mehr geben. Der einzige Unterschied, den wir festgestellt haben, ist, dass MySql bei der Installation der Pakete nicht nach einem Root-Passwort fragt. Um sich zunächst mit mysql zu verbinden, um die Berechtigungen einzurichten, müssen Sie möglicherweise Folgendes tun:
```bash
sudo mysql -u root
```
## Fedora 20 / RHEL / CentOS
---
Diese Installation wurde mit Fedora 20 durchgeführt, gilt aber höchstwahrscheinlich auch für Red Hat Enterprise Linux, CentOS und andere Red Hat-basierte Linux-Distributionen oder ist ein guter Ausgangspunkt dafür.

Vielen Dank an Jay Moore für sein Feedback zu seinen eigenen Erfahrungen bei der Installation von SEEK unter RHEL.
### Pakete

Die Paketnamen sind für Red Hat recht unterschiedlich und werden mit Yum installiert. Die Pakete, die Sie installieren müssen, sind
```bash
sudo yum install mysql-server
```
Damit wird zwar MariaDB installiert, aber das ist kompatibel und kein Problem. Der Rest der Pakete (einschließlich der Pakete für die Ausführung von SEEK mit Apache) wird wie folgt installiert
```bash
sudo yum groupinstall "Development Tools" "Development Libraries"
sudo yum install wget curl mercurial ruby openssl-devel  openssh-server git readline-devel
sudo yum install libxml2-devel libxml++-devel java-1.7.0-openjdk-devel sqlite-devel
sudo yum install poppler-utils libreoffice mysql-devel mysql-libs ImageMagick-c++-devel libxslt-devel
sudo yum install libtool gawk libyaml-devel autoconf gdbm-devel ncurses-devel automake bison libffi-devel
sudo yum install httpd-itk httpd-devel
```
### Installieren von RVM

Installieren Sie wie gewohnt nach der [Installationsanleitung](./install_dev.md), aber achten Sie besonders auf Meldungen über die Aktualisierung Ihres `.profile?` oder `.bash_profile`.
### Installation von Gems

Wie bei Linux Mint und Ubuntu 14.04 sollten Sie den folgenden Befehl ausführen, bevor Sie bundle install starten, um sicherzustellen, dass `Nokogiri` mit der installierten Version von `LibXML` kompiliert wird.
```bash
bundle config build.nokogiri --use-system-libraries
```
### Einrichten der Datenbank

Fedora installiert `MariaDB` anstelle von Mysql. Möglicherweise müssen Sie die Datenbank mit starten:
```bash
sudo service mariadb start
```
Um sie beim Booten zu starten (bei mir war dies nicht standardmäßig aktiviert), sollten Sie Folgendes ausführen:
```bash
sudo chkconfig mariadb on
```
Um sich mit der Datenbank zu verbinden und den Benutzer für SEEK einzurichten, führen Sie aus:
```bash
sudo mariadb
```
Ansonsten bleibt alles beim Alten.
### Einrichten für die Produktion mit Passenger Phusion

Um `Apache` zu starten und zu stoppen, müssen Sie
```bash
sudo apachectl start
sudo apachectl stop
```
Wie auch bei MariaDB ist es nicht so konfiguriert, dass es beim Booten startet, um dies zu beheben, führen Sie folgende Kommandos aus:
```bash
sudo apachectl stop
sudo usermod -d /home/apache apache
sudo usermod -s /bin/bash apache
sudo mkdir /home/apache
sudo chown apache /home/apache
sudo apachectl start
```
und verwenden Sie statt www-data den folgenden Befehl, um zu diesem Benutzer zu wechseln:
```bash
sudo su - apache
```
und fahren Sie dann mit der normalen Installation fort, zusammen mit den oben beschriebenen Unterschieden bei der Installation der Edelsteine und der Einrichtung der Datenbank, bis Sie zur Installation und Einrichtung von Passenger Phusion kommen.

Bevor ich das Passenger-Modul erstelle, muss ich zunächst die folgende Variable setzen, um sicherzustellen, dass es mit einer 64bit-Architektur erstellt wurde
```bash
export ARCHFLAGS="-arch x86_64"
```
und führen Sie dann Folgendes aus
```bash
bundle exec passenger-install-apache2-module
```
Ich erhielt einige Warnungen, dass FORTIFY_SOURCE eine Kompilierung mit Optimierung erfordert, die ich ignorierte und die keine Probleme zu verursachen schienen.

Am Ende des Kompilierens und Einrichtens von Passenger Phusion werden einige Details über die Konfiguration angezeigt, die auf Apache angewendet werden soll. Diese sollte auf eine Konfigurationsdatei in `/etc/httpd/conf.d/` angewendet werden. Ich habe z.B. eine Datei /etc/httpd/conf.d/seek.conf verwendet. Sie sollten auch die anderen conf-Dateien entfernen, die dort standardmäßig abgelegt sind. Der Inhalt dieser Datei sah am Ende wie folgt aus, wobei sich Ihre Version leicht unterscheiden kann.
```bash
LoadModule passenger_module "/home/apache/.rvm/gems/ruby-2.1.2@seek/gems/passenger-4.0.45/buildout/apache2/mod_passenger.so"
<IfModule mod_passenger.c>
   PassengerRoot /home/apache/.rvm/gems/ruby-2.1.2@seek/gems/passenger-4.0.45
   PassengerDefaultRuby /home/apache/.rvm/gems/ruby-2.1.2@seek/wrappers/ruby
</IfModule>

<VirtualHost *:80>
    # !!! Be sure to point DocumentRoot to 'public'!
    DocumentRoot /srv/rails/seek/public
    <Directory /srv/rails/seek/public>
       # This relaxes Apache security settings.
       AllowOverride all
       # MultiViews must be turned off.
       Options -MultiViews
       # Uncomment this if you're on Apache >= 2.4:
       Require all granted
    </Directory>
</VirtualHost>
```
Danach sollte der Apache neu gestartet werden mit
```bash
sudo apachectl restart
```
Nun stieß ich beim Laden des Moduls auf einen Berechtigungsfehler, der mit SELinux zusammenhing. Um dies zu umgehen, deaktivierte ich SELinux mit
```bash
sudo setenforce 0
```
Unter http://sergiy.kyrylkov.name/2012/02/26/phusion-passenger-with-apache-on-rhel-6-centos-6-sl-6-with-selinux wird beschrieben, wie man SELinux wieder aktivieren kann, aber wir haben es nicht geschafft, dies zu erreichen.

Wenn Sie eine Lösung haben, wie Sie SELinux wieder aktivieren können, kontaktieren Sie uns bitte. Einzelheiten zur Kontaktaufnahme mit uns finden Sie unter http://seek4science.org/contact.

## Ubuntu 20.04 (LTS)
---
Die allgemeinen Pakete:
```bash
sudo apt-get install wget curl mercurial ruby rdoc ri libopenssl-ruby ruby-dev mysql-server libssl-dev build-essential openssh-server git-core
sudo apt-get install libmysqlclient16-dev libmagick++-dev libxslt-dev libxml++2.6-dev openjdk-6-jdk libsqlite3-dev sqlite3
sudo apt-get install poppler-utils openoffice.org openoffice.org-java-common
```
Um zu vermeiden, dass Sie während der Installation von Ruby 1.9.3 mit RVM dazu aufgefordert werden:
```bash
sudo apt-get install libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev automake bison libffi-dev
```
So installieren Sie das Passenger Phusion-Modul, um SEEK mit Apache auszuführen:
```bash
sudo apt-get install apache2-mpm-prefork apache2-prefork-dev libapr1-dev libaprutil1-dev libcurl4-openssl-dev
```
Der Befehl zum Starten von soffice ist ebenfalls etwas anders, da er nur einfache statt doppelte Bindestriche für die Argumente verwendet:
```bash
soffice -headless -accept="socket,host=127.0.0.1,port=8100;urp;" -nofirststartwizard > /dev/null 2>&1 &
```
Wenn Sie feststellen, dass die Konvertierung von Dokumenten in das PDF-Format (für die Anzeige von Inhalten im Browser) langsam ist, können Sie ein aktuelleres LibreOffice 3.5 aus einem separaten Repository installieren - dies kann jedoch zukünftige Betriebssystem-Upgrades beeinträchtigen:
```bash
sudo apt-get purge openoffice* libreoffice*
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:libreoffice/libreoffice-3-5
sudo apt-get update
sudo apt-get install libreoffice
```
## Debian
---
Standardmäßig wird der Benutzer, den Sie während der Installation für Debian anlegen, nicht zur Liste der sudoers hinzugefügt. Sie können Ihren Benutzer zur sudo-Gruppe hinzufügen, z.B.
```bash
adduser <USERNAME> sudo
```
Weitere Details finden Sie unter https://wiki.debian.org/sudo.

Alternativ können Sie bei der Installation Befehle, die mit sudo beginnen, als root-Benutzer ausführen.

Die erforderlichen Paketnamen sind die gleichen wie bei Ubuntu 12.04 - folgen Sie also einfach der Installationsanleitung.

Wenn Sie Probleme mit der Verwendung von rvm haben, müssen Sie Ihr Terminal möglicherweise so konfigurieren, dass Befehle als Login-Shell ausgeführt werden. Es gibt ein Kontrollkästchen, das Sie unter dem Menü Bearbeiten, Profileinstellungen und dann unter der Registerkarte Titel und Befehl finden können.

# Installation von SEEK für Mac OS X

Obwohl Sie Seek unter Mac OS ausführen können, könnten Sie auf zufällige Probleme stoßen und müssen verschiedene Anpassungen vornehmen, von denen einige unten aufgeführt sind. Einige Versionen verschiedener Ruby Gems sind nicht voll funktionsfähig oder können unter Mac OS nicht installiert werden. Es wird daher dringend empfohlen, Seek in einer virtuellen Maschine zu installieren, vorzugsweise unter Ubuntu.
## Catalina
---
Dieser Abschnitt führt Sie durch die Installation der vorausgesetzten Pakete, für weitere Schritte lesen Sie bitte die Hauptinstallationsanleitung

Zunächst müssen Sie Fink und MacPorts installieren, zwei Paketverwaltungsprogramme für Mac OS X. Die meisten Pakete werden von Fink installiert, während einige von MacPorts installiert werden. Folgen Sie diesem Link, um Fink zu installieren: http://www.finkproject.org/download/index.php?phpLang=en und für MacPorts: https://www.macports.org/install.php
### Installieren der Pakete
```bash
sudo fink install wget curl openssl100-dev git readline6
sudo fink install libxml++2 sqlite3-dev sqlite3
sudo fink install poppler-bin mysql-unified-dev

sudo port install mysql8-server
sudo port install openssh ImageMagick libxslt
```
Für die folgenden Pakete müssen Sie das dmg-Image herunterladen und manuell installieren:
```bash
Libreoffice (alternatives Open Office): http://www.libreoffice.org/download
Java JDK: http://www.oracle.com/technetwork/java/javase/downloads/index.html oder https://jdk.java.net/ (openjdk)
PostGres: https://www.postgresql.org/download/macosx/
Node.js: https://nodejs.org/en/download/
```
### Einrichten von MySQL
---
https://trac.macports.org/wiki/howto/MySQL

Wichtige Schritte nach der Installation:

Wählen Sie mysql8 beim Standard-Mysql aus:
```bash
sudo port select mysql mysql8
```
Starten Sie den Server:
```bash
sudo port load mysql8-server     
```
Initialisieren Sie die Datenbank.

Dabei erhalten Sie ein temporäres Root-Passwort. Sie müssen es aufschreiben, da es später (sehr) schwierig sein wird, es zurückzusetzen. Bei der ersten tatsächlichen Verwendung von mysql (mit dem Befehl mysql) müssen Sie das Root-Passwort ändern (siehe unten).
```bash
sudo /opt/local/lib/mysql8/bin/mysqld --initialize --user=_mysql
```
Erster Start von mysql:
```bash
mysql -uroot -p <PASSWORD> # angegebenes Passwort verwenden
```
Sie können nichts tun, bevor Sie ein neues Passwort für root eingerichtet haben:
```bash
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
```
MySql hat standardmäßig eine neue Authentifizierungsmethode. Um sicherzustellen, dass Seek sich damit verbinden kann, müssen Sie angeben, dass der Seek-DB-Benutzer (festgelegt in Database.yml) die alte "native password"-Methode verwenden kann:
```bash
ALTER USER 'ldhmainuser'@'localhost' IDENTIFIED WITH mysql_native_password
```
Dann aktivieren Sie die neuen Privilegien:
```bash
flush privileges;
```
### PostGres Gem installieren
---
Um die PostGres-Unterstützung mit Gem zu installieren, wird der Pfad zu den Binärdateien benötigt:
```bash
sudo PATH=$PATH:/Library/PostgreSQL/x.y/bin gem install pg
```
für PostGres 10 wäre es zum Beispiel:
```bash
sudo PATH=$PATH:/Library/PostgreSQL/10/bin gem install pg
```
### Puma Gem installieren
---
Puma braucht eine Option, um mit dem neuen Xcode zu kompilieren:
```bash
gem install puma:4.3.5 -- --with-cflags="-Wno-error=implicit-function-declaration"
```
### Andere Hinweise
---
Standardmäßig verbindet sich der mysql-Client mit dem mysql-Server über einen Socket unter `/tmp/mysql.sock`. Möglicherweise installieren Sie jedoch standardmäßig die .sock-Datei unter `/opt/local/var/run/mysql8/mysqld.sock`. Daher muss die .sock-Datei in database.yml neu konfiguriert werden
```bash
socket: /opt/local/var/run/mysql8/mysqld.sock
```
Und auch wenn Sie den mysql-Client ausführen wollen, müssen Sie den Pfad der .sock-Datei unter der Option -S

Möglicherweise müssen Sie den Installationsort von Libreoffice angeben, bevor Sie den Befehl soffice ausführen. Sie können z.B. folgende Zeile in `~/.bashrc` einfügen
```bash
export PATH="$PATH:/Programme/LibreOffice.app/Inhalte/MacOS/"
```
### Verbindung zu MySQL von einem Client aus
---
MacPorts deaktiviert standardmäßig vollständig entfernte Verbindungen, die für die meisten SQL-Clients erforderlich sind. Um sie zu aktivieren, können Sie die my.cnf bearbeiten:
```bash
sudo vim /opt/local/etc/mysql8/my.cnf
```
```bash
# MacPorts-Standardeinstellungen verwenden
# !include /opt/local/etc/mysql8/macports-default.cnf

[client]
port                   =  3306
socket                 = /opt/local/var/run/mysql8/mysqld.sock
default-character-set  =  utf8

[mysqld_safe]
socket                 = /opt/local/var/run/mysql8/mysqld.sock
nice                   =  0 
default-character-set  = utf8

[mysqld]
basedir="/opt/local"
socket                 =  /opt/local/var/run/mysql8/mysqld.sock
port                   = 3306
bind-address           =  127.0.0.1
skip-external-locking
#skip-networking
character-set-server   =  utf8

[mysqldump]
default-character-set  =  utf8
```
Starten Sie dann MySQL neu (möglicherweise müssen Sie den Prozess beenden):
```bash
sudo port unload mysql8-server 

ps -ax | grep mysql -> wenn mysqld noch da ist, verwenden Sie die aufgelistete PID:

sudo kill PID
```
dann
```bash
sudo port load mysql8-server
```