# Verwaltung von SEEK

Hier werden einige grundlegende Administrationsaufgaben beschrieben, die Sie nach der Installation von SEEK durchführen können. Alle Verwaltungsaufgaben finden Sie im Administrationsbereich, indem Sie die Registerkarte Konto und dann die Serververwaltung auswählen. Viele der Einstellungen haben eine Beschreibung ihrer Funktion und werden hier nicht behandelt.
## Erstellen eines Projekts und einer Einrichtung

Bevor Sie Elemente, wie z. B. Datendateien oder Modelle, zu SEEK hinzufügen können, müssen Sie das erste Projekt und die erste Einrichtung erstellen und sich selbst zu diesen hinzufügen.

Sie können Ihr Projekt und Ihre Einrichtung zunächst über die allgemeinen Aufgaben im Verwaltungsbereich erstellen.

Sobald diese erstellt sind, müssen Sie das Projekt mit der Einrichtung verknüpfen, indem Sie zur Seite Projekt anzeigen navigieren und auf die Schaltfläche Projektverwaltung klicken. Auf dieser Seite können Sie eine oder mehrere Einrichtungen für dieses Projekt auswählen und dann durch Klicken auf die Schaltfläche Aktualisieren am unteren Rand des Formulars speichern.

Sie können sich selbst zu dem von Ihnen erstellten Projekt und der Einrichtung hinzufügen, indem Sie zu Ihrem Profil navigieren, die Personenverwaltung auswählen, dann das Projekt/Einrichtung-Paar aus der Liste auswählen und auf die Schaltfläche Aktualisieren am unteren Ende des Formulars klicken.

Beachten Sie, dass Projekte mit mehreren Institutionen verbunden sein können und Personen zu mehreren Projekt/Institution-Paaren gehören können. Wenn Sie mehrere Elemente aus den Listen auswählen, müssen Sie die STRG-Taste gedrückt halten, während Sie sie auswählen.

## E-Mail konfigurieren

Standardmäßig ist E-Mail deaktiviert, aber wenn Sie die Möglichkeit haben, können Sie es so konfigurieren, dass SEEK E-Mails versendet - z.B. E-Mails über Änderungen in Ihrem Projekt, Benachrichtigungs-E-Mails, Feedback-E-Mails und Benachrichtigungen über Fehler. Sie können E-Mails unter Admin->Konfiguration->Funktionen aktivieren/deaktivieren konfigurieren. Ganz unten auf dieser Seite gibt es ein Kontrollkästchen "E-Mail aktiviert", das Sie aktivieren sollten. Daraufhin werden einige SMTP-Einstellungen angezeigt, die Sie ausfüllen müssen. Alle, die nicht benötigt werden, können leer gelassen werden. Die Bedeutung der Einstellungen sind:

- Adresse - die Adresse (Name oder IP-Adresse) des SMTP-Servers, der für die Zustellung ausgehender E-Mails verwendet wird
- Port - der Port, über den Ihr Mailserver E-Mails empfängt
- Domäne - wenn Sie eine HELO-Domäne angeben müssen, können Sie dies hier tun.
- Authentifizierung - wenn Ihr Mailserver eine Authentifizierung erfordert, müssen Sie hier den Authentifizierungstyp angeben. Dies kann plain (sendet das Passwort im Klartext), login (sendet das Passwort Base64 kodiert) oder in seltenen Fällen cram_md5 sein.
- Auto STARTTLS enabled - aktivieren Sie dies, wenn Ihr Mailserver Tranport Layer Security erfordert und Sie beim Testen Ihrer Konfiguration STARTTLS-Fehler erhalten
- Benutzername - wenn Ihr Mailserver eine Authentifizierung erfordert, geben Sie den Benutzernamen in dieser Einstellung an.
- Passwort - wenn Ihr Mailserver eine Authentifizierung erfordert, geben Sie hier das Passwort ein.

Darunter befindet sich ein Feld, mit dem Sie Ihre Einstellungen testen können. Wenn Sie außerdem E-Mails über aufgetretene Fehler erhalten möchten, können Sie das Kästchen "Ausnahmebenachrichtigung aktiviert" ankreuzen und unten eine Liste von E-Mail-Adressen angeben (durch Komma oder Leerzeichen getrennt).