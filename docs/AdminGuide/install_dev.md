# Installation Local Data Hub
## Einführung
Diese Schritte beschreiben, wie Sie den LDH direkt auf dem Rechner (Bare-Metal) installieren.

Für die Installation und Ausführung mit Docker, die in vielen Fällen einfacher und schneller ist, lesen Sie bitte die Anleitung zu [Docker Compose](./dockercomp.md).

LDH basiert auf der Ruby on Rails Plattform. Obwohl die Informationen auf dieser Seite Sie mit allem versorgen sollten, was Sie brauchen, um eine Basisinstallation von LDH zum Laufen zu bringen, wäre etwas Hintergrundlektüre zu Ruby on Rails von Vorteil, wenn es für Sie neu ist. Dokumentation und Ressourcen, die Ruby on Rails beschreiben, finden Sie in der [Ruby Dokumentation][ruby-dok].

LDH baut auf Rails auf und benötigt Ruby 2.8.

Wir empfehlen Ihnen, LDH auf einem Linux-System auszuführen. Diese Anleitung basiert auf einem Ubuntu (20.04 LTS) System. Wenn Sie LDH jedoch auf anderen Linux-Distributionen ausführen, besteht der Hauptunterschied in den Namen der erforderlichen Pakete, die für die jeweilige Distribution installiert werden müssen, ansonsten sind die Schritte identisch. Wenn Sie auf einer anderen Distribution oder Version installieren möchten, besuchen Sie bitte die Seite Andere Distributionen und sehen Sie nach, ob sie dort aufgeführt ist.

Sie benötigen sudo-Rechte auf dem Rechner, auf dem Sie LDH installieren, oder Sie müssen sich als root anmelden können. Außerdem benötigen Sie während des gesamten Installationsvorgangs eine aktive Internetverbindung.

Obwohl es möglich ist, ist die Installation und Ausführung von Ruby on Rails auf einem Windows-System mühsam und wird hier nicht behandelt. Um den LDH trotzdem auf einem Windowssystem lauffähig zu bekommen, weisen wir auf die Verwendung von **Windows-Subsystem für Linux** (WSL) hin.

## Installieren von Paketen

Dies sind die Pakete, die benötigt werden, um den LDH mit Ubuntu 20.04 (Desktop oder Server) zu betreiben. Für andere Distributionen oder Versionen besuchen Sie bitte unsere Hinweise zu anderen Distributionen.

Fügen Sie zunächst ein Repository hinzu, das Python-Versionen enthält, die möglicherweise nicht in den Standard-Repositories verfügbar sind

```bash
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
```
Dann stellen Sie sicher, dass alles auf dem neuesten Stand ist.
```bash
sudo apt update
sudo apt upgrade
```
Installieren Sie nun die Pakete:
```bash
sudo apt install build-essential cmake git graphviz imagemagick libcurl4-gnutls-dev libgmp-dev \
    libmagick++-dev libmysqlclient-dev libpq-dev libreadline-dev libreoffice libssl-dev \
    libxml++2.6-dev libxslt1-dev mysql-server nodejs openjdk-11-jdk openssh-server poppler-utils zip \
    python3.7-dev python3.7-distutils python3-pip
```
Wenn Sie diese Pakete jetzt installieren, wird die Installation von Ruby später einfacher:
```bash
sudo apt install autoconf automake bison curl gawk libffi-dev libgdbm-dev \
    libncurses5-dev libsqlite3-dev libyaml-dev sqlite3
```
Die Solr-Implementierung von den LDH erfordert derzeit Java 11, daher müssen Sie möglicherweise die Standard-Java-Laufzeitumgebung des Systems ändern:
```bash
sudo update-alternatives --config java
```
...und wählen Sie die Version namens `/usr/lib/jvm/java-11-openjdk-amd64/bin/java` oder ähnlich.

## Entwicklung oder Produktion?

Die folgenden Schritte sind sowohl für die Einrichtung von den LDH für die Entwicklung als auch für eine Produktionsumgebung geeignet. Bei der Einrichtung einer Produktionsumgebung gibt es jedoch einige kleine Unterschiede - siehe [Installation von LDH in einer Produktionsumgebung](./install_prod.md)
## LDH installieren

Jetzt sind Sie bereit für die Installation von den LDH. Sie können entweder direkt von Github installieren oder die Dateien herunterladen. Sie können den LDH auch von Docker aus starten
### Direkt von Github installieren

Wenn Sie den LDH direkt von GitHub installieren möchten, ist die neueste Version von den LDH als (v1.13.4) gekennzeichnet. Um diese zu holen, führen Sie aus:

```bash
git clone https://github.com/nfdi4health/ldh.git
cd ldh/
```

## Einrichten von Ruby und RubyGems mit RVM

Wir empfehlen Ihnen dringend, RVM für die Verwaltung Ihrer Ruby- und RubyGems-Version zu verwenden. Sie können zwar die Version verwenden, die mit Ihrer Linux-Distribution geliefert wird, aber es ist schwieriger, die verwendete Version zu kontrollieren und auf dem neuesten Stand zu halten.

Um RVM unter Ubuntu zu installieren, gibt es ein Paket, das unter https://github.com/rvm/ubuntu_rvm beschrieben ist.
```bash
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm
sudo usermod -a -G rvm $USER
```
... die Anleitung empfiehlt hier einen Neustart, aber ein erneutes Ein- und Ausloggen funktioniert normalerweise.

Andere Möglichkeiten, RVM zu installieren, finden Sie unter https://rvm.io/rvm/install.

Installieren Sie nun die entsprechende Version von Ruby
```bash
rvm install $(cat .ruby-version)
```

## Installation von Gems

Installieren Sie zunächst Bundler, das zur Verwaltung von Gem-Versionen dient
```
gem install bundler
```
Als nächstes installieren Sie die Ruby-Gems, die den LDH benötigt (für die Produktion siehe Bundler-Konfiguration)
```
bundle installieren
```
## Python-Abhängigkeiten installieren

Zuerst muss eine bestimmte Version von setuptools installiert werden, um ein Problem bei der Installation von Abhängigkeiten zu vermeiden
```
python3.7 -m pip install setuptools==58
```
Dann können die anderen Abhängigkeiten installiert werden
```
python3.7 -m pip install -r requirements.txt
```
## Einrichten der Datenbank

Zuerst müssen Sie die Datenbankkonfigurationsdatei einrichten. Kopieren Sie eine Standardversion dieser Datei und bearbeiten Sie sie dann:
```bash
cp config/database.default.yml config/database.yml
nano config/database.yml
```
WICHTIG: Sie sollten zumindest den Standardbenutzernamen und das Standardpasswort ändern. Ändern Sie dies für jede Umgebung (Entwicklung, Produktion, Test).

Nun müssen Sie die Berechtigungen für den soeben verwendeten Benutzer und das Passwort vergeben (ändern Sie das Beispiel unten entsprechend).
```bash
> sudo mysql
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1522
Server version: 5.5.32-0ubuntu0.12.04.1 (Ubuntu)

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE USER 'mysqluser'@'localhost' IDENTIFIED BY 'mysqlpassword';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'mysqluser'@'localhost' WITH GRANT OPTION;
```
Um nun die Datenbank für den LDH zu erstellen und mit den Standarddaten zu versehen, führen Sie aus:
```
bundle exec rake db:setup
```
Sie können nun den LDH zum ersten Mal starten, um zu testen, ob alles funktioniert
```
bundle exec rails server
```
... und besuchen Sie http://localhost:3000 und eine den LDH-Seite sollte geladen werden.

Bevor Sie jedoch fortfahren, beenden Sie den LDH mit STRG+C und starten Sie einige Dienste.

## Starten der den LDH-Dienste

Hier wird beschrieben, wie Sie die Dienste, die den LDH benötigt, schnell in Betrieb nehmen können. Wenn Sie einen Produktionsserver einrichten, können Sie mit diesen Schritten überprüfen, ob die Dinge funktionieren. Sie sollten jedoch auch die Anleitung Installation für die Produktion lesen, um diese Dienste zu automatisieren.
### Einrichten und Starten des Suchdienstes

Der LDH verwendet die Apache Solr Suchmaschine, die seit der LDH v1.12 separat eingerichtet werden muss. Dies ist relativ einfach und es gibt eine Anleitung dazu in Solr einrichten.
### Starten und Stoppen des Hintergrunddienstes

den LDH verwendet Delayed Job, um verschiedene asynchrone Aufträge zu verarbeiten. Es ist wichtig, dass dieser Dienst läuft.

Um Delayed Job zu starten, führen Sie aus:
```
bundle exec rake den LDH:workers:start
```
und zum Beenden führen Sie aus:
```
bundle exec rake den LDH:workers:stop
```
Sie können auch neu starten mit
```
bundle exec rake den LDH:workers:restart
```

## den LDH starten
Sie können nun den LDH erneut starten:
```
bundle exec rails server
```

### Einen Administrator anlegen

Wenn Sie den LDH zum ersten Mal unter http://localhost:3000 besuchen und keine Benutzer vorhanden sind, werden Sie aufgefordert, einen neuen Benutzer anzulegen. Dieser Benutzer wird der Administrator von den LDH sein (Sie können in Zukunft andere Benutzer anlegen oder hinzufügen). Legen Sie einen Benutzernamen und ein Passwort an, füllen Sie Ihr Profil aus und schon können Sie den LDH nutzen.

Sie werden aufgefordert, unser sehr kurzes Registrierungsformular auszufüllen. **Bitte tun Sie dies, falls Sie es noch nicht getan haben**, da dies für die zukünftige Unterstützung und Finanzierung von den LDH sehr hilfreich ist.

### Letzte Schritte

Wenn Sie den LDH für den produktiven Einsatz einrichten, gehen Sie bitte zurück zu unserem Leitfaden den LDH für die Produktion installieren.

Sie sollten jetzt auch unseren Administrationsleitfaden lesen, in dem einige grundlegende Aufgaben und Einstellungen beschrieben sind.



[ruby-dok]:[https://guides.rubyonrails.org/]
[dockercomp]:[dockercomp.md]
