# Spezielle Benutzerrollen

LDH verfügt über eine Reihe von speziellen Rollen, die den Benutzern zugewiesen werden können

Programmspezifische Rollen:

- [Programmadministratoren](#programmadministrator)

Projektspezifische Rollen:

- [Asset housekeeper](#asset-housekeeper)
- [Asset gatekeeper](#asset-gatekeeper)
- [Projektadministrator](#programmadministrator)

Im Folgenden finden Sie eine Zusammenfassung der Fähigkeiten der einzelnen Rollen.
|| **Project admin**| **Asset Housekeeper** | **Asset Gatekeeper** | **Normal User** |
|---|:---:|:---:|:---:|:---:|
| **Notified of new project member**|X||||
| **manage project meta data details (that they are a member of)**|X|X|X|X|
| **Authenticate, authorise, assign, remove and mark as left users to projects** |X|||||
| **Authorise request to make project specific asset(s) public access**|||X|
| **Manage project specific assets of users thatr have left the project**||X|||
| **Create new assets**|X|X|X|X|
| **Create new profiles**|X||||
| **Create and edit new institutions**|X||||
| **Create new organisms**|X||||
| **Edit profiles**|X||||
| **Change login details**||||X|

## Programmadministrator

Ein Programmadministrator ist für ein ganzes Programm zuständig. Er hat die Möglichkeit, seinem Programm andere Programmadministrator zuzuweisen, kann sich aber nicht selbst entfernen. Um sich selbst zu entfernen, muss er zunächst einen anderen Verwalter zuweisen und diesen bitten, dies für ihn zu tun, um zu verhindern, dass ein Programm versehentlich ohne einen Verwalter ist. Jeder andere LDH-Benutzer kann zum Programmadministrator ernannt werden.

Ein Programmadministrator hat auch die Möglichkeit, Projekte zu erstellen, die dann automatisch seinem Programm zugewiesen werden. Sie werden zwar nicht automatisch zum [Projektadministrator](#programmadministrator) oder Mitglied dieses Projekts, aber es besteht die Möglichkeit, dies zu tun, indem Sie die Institution auswählen.

Um ein Projekt zu erstellen, wählen Sie das Menü Erstellen oben auf der Seite. Ihr Programm muss zuvor angenommen und aktiviert worden sein. Wenn Sie ein Projekt erstellt haben, können Sie auch ein Logo oder ein Bild einfügen, indem Sie auf Bild ändern unter dem Bild auf der rechten Seite der Projektseite klicken. Ein Programmadministrator verfügt auch über einige der Fähigkeiten eines [Projektadministrators](#programmadministrator):

- Hinzufügen und Entfernen von Personen aus einem Projekt
- Profile erstellen
- Institutionen erstellen

## Asset-Housekeeper

Der Asset Housekeeper hat die besondere Fähigkeit, Assets zu verwalten, die anderen Personen im Projekt gehören - aber nur Personen, die als im Projekt inaktiv gekennzeichnet wurden. Dies ist nützlich, um zu verhindern, dass Objekte "gestrandet" werden, wenn jemand ein Projekt verlässt, ohne jedoch seine Assets aus dem Projekt zu übergeben, damit sie von anderen Benutzern verwaltet werden können.

Um ein Asset-Housekeeper zu werden, muss der Benutzer auch Mitglied dieses Projekts sein.

## Asset-Gatekeeper

Hierbei handelt es sich um eine optionale Rolle, die es einem oder mehreren bestimmten Benutzern ermöglicht, die Kontrolle darüber zu haben, ob Assets innerhalb des Projekts veröffentlicht werden. Wenn ein Projektelement veröffentlicht wird, ist es erst dann verfügbar, wenn der Asset Gatekeeper es genehmigt hat. Der Asset Gatekeeper wird benachrichtigt, wenn ein Asset zur Veröffentlichung ansteht. Er verhindert, dass bereits veröffentlichte Elemente zu schnell öffentlich zugänglich werden.

Um ein Asset-Gatekeeper zu werden, muss der Benutzer auch Mitglied dieses Projekts sein.

## Projektadministrator

Der Projektadministrator wird benachrichtigt, wenn sich eine neue Person in LDH für das Projekt anmeldet. Er hat auch die Möglichkeit,:

- Hinzufügen und Entfernen von Personen aus einem Projekt
- Profile erstellen
- Institutionen erstellen
- Personen zu Projektrollen zuzuweisen
- Markieren, wenn eine Person in einem Projekt inaktiv wird

Sie können auch die Projektdetails und die mit dem Projekt verbundenen Institutionen bearbeiten.

Um ein Projektadministrator zu werden, muss der Benutzer auch Mitglied des Projekts sein.