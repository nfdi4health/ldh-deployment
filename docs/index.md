---
layout: default
title: home
nav_order: 1
permalink: /
---


[![Build Status](https://github.com/nfdi4health/ldh/actions/workflows/tests.yml/badge.svg)](https://github.com/nfdi4health/ldh/actions/workflows/tests.yml)
# Local Data Hub

## Über den Local Data Hub
---
Die NFDI4Health Local Data Hub (LDH) Plattform ist eine webbasierte Ressource für den Austausch von heterogenen wissenschaftlichen Forschungsdaten, Modellen oder Simulationen, Prozessen und Forschungsergebnissen. Sie bewahrt Assoziationen zwischen ihnen sowie Informationen über die beteiligten Personen und Organisationen. Der LDH basiert dabei auf dem [SEEK4Science][seek] Framework. Grundlage von SEEK ist die ISA-Infrastruktur, ein Standardformat zur Beschreibung, wie einzelne Experimente zu umfassenderen Studien und Untersuchungen zusammengeführt werden. Innerhalb von SEEK wurde ISA erweitert und ist konfigurierbar, so dass die Struktur auch außerhalb der Biologie verwendet werden kann.

LDH enthält eine semantische Technologie, die anspruchsvolle Abfragen der Daten ermöglicht, ohne die Benutzer zu behindern.

Für ein Beispiel von LDH besuchen Sie bitte unsere [Demoinstanz][demo].

Um zu sehen, wie der LDH als Teil von Nfdi4health für echte Wissenschaft genutzt wird, besuchen Sie bitte den [Leipzig Health Atlas][LHA]

## NFDI4Health
---
Der LDH wird im Rahmen der NFDI4Health-Initiative entwickelt und finanziert. Die Nationale Forschungsdateninfrastruktur für personenbezogene Gesundheitsdaten – fokussiert sich auf Daten, die in klinischen, epidemiologischen und Public Health-Studien generiert werden. Die Erhebung und Analyse dieser Daten zu Gesundheits- sowie Krankheitsstatus und wichtiger Einflussfaktoren darauf sind eine wesentliche Komponente zur Entwicklung neuer Therapien, übergreifender Versorgungsansätze und präventiver Maßnahmen eines modernen Gesundheitswesens.

Obwohl diese Daten bereits hohen inhaltlichen Qualitätsstandards genügen, erfüllen sie häufig nicht die Anforderungen der FAIR-Prinzipien:

- Die Auffindbarkeit der Daten ist aufgrund fehlender internationaler Standards für Registrierung und Publikation häufig eingeschränkt.
- Möglichkeiten der Datennutzung durch Dritte sind in der Regel unklar.
- Weiterhin schränken Datenschutzbestimmungen und Einwilligungserklärungen der Studienteilnehmenden die Wiederverwendbarkeit der Daten ein.
- Datenbanken sind oft nicht interoperabel, z. B. aufgrund der großen methodischen Heterogenität bei der Erfassung von Expositionen und gesundheitlichen Endpunkten.

## Installation
---

Wir empfehlen die Installation vom LDH auf Debian oder Ubuntu.

Um die neueste Version zu installieren, besuchen Sie bitte: [LDH Installationsanleitung](./AdminGuide/index.md)

Für Details über andere Distributionen und die Installation unter Mac OS X besuchen Sie bitte: [Anleitung für andere Distributionen](./AdminGuide/otherdistro.md#)

Die Dokumentation ist auf dem ghpages-Zweig verfügbar.

## Documentation
---


- [User Guide](./UserGuide/index.md)
- [Admin Guide](./AdminGuide/index.md)

[seek]:[https://seek4science.org/]
[demo]:[https://lap.test.nfdi4health.de/]
[LHA]:[https://www.health-atlas.de/]
