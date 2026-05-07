---
title: |
    | "Normalformen in Datenbanken in Theorie und Praxis"
author: Prof. Dr. Asis Hallab
geometry: margin=2.5cm
numbersections: false
---

# Übungsaufgaben zur Vorlesung 

## Vorbereitung und Annahmen

Sehen Sie sich das mitgelieferte SQL-Script `RDB_Normalformen.sql` an und
studieren Sie das dort angelegte Schema genau. Nehmen Sie folgende
Voraussetzungen an:

* Wir gehen davon aus, dass ein Fluss nur eine Mündung hat.
* Wir nehmen an, dass eine Stadt bzw. ihr Zentrum an einer bestimmten
  Kilometermarke eines Flusses liegt.

## Technische Voraussetzungen

Installieren Sie sich SQLite für Ihr Betriebssystem, falls Sie es noch nicht
installiert haben. Dieses Übungsblatt ist optimiert für SQLite und ein Linux /
Unix Betriebssystem. Sie können unter Windows auch das Windows-Subsystem
nutzen.

# 1. Aufgabe: Generieren Sie Daten

Bitten Sie eine generative KI darum für das beigefügte "Stadt-Land-Fluss-Schema" (`RDB_Normalformen.sql`) `INSERT` Statements zu generieren. Hierbei sollten in jeder Tabelle mehr als eine Zeile eingetragen werden. Achten Sie darauf, dass die Städte immer mindestens zwei `governors` haben.

Welches Problem taucht beim Einfügen auf? Wie können Sie es beheben? _Hinweis_: Schauen Sie sich die Dokumentation zu `DEFERRABLE INITIALLY DEFERRED` im Kontext von Foreign Keys an.

# 2. Aufgabe: Probleme aus Verletzungen der ersten Normalform

Selektieren Sie `governors` (Bürgermeister) einer Stadt. Wie erhalten Sie eine echte Liste von Bürgermeistern? Können Sie dies mit reinem SQL lösen? Wenn nicht, wie könnten Sie dies mit ShellScript Kommandos oder einer Scriptsprache Ihrer Wahl lösen?

# 3. Aufgabe: Probleme aus Verletzungen der zweiten Normalform

Nehmen Sie für Ländernamen die durchschnittliche Länge von 10 Unicode Zeichen und 4 Bytes pro Zeichen an. Schätzen Sie den Speicherbedarf für alle im Schema vorkommenden Attribute "Name of Country" ab, angenommen wir hätten eine Million Städte und hunderttausend Länder eingetragen.

Schreiben Sie ein `UPDATE` Statement, wo Sie den Namen eines existierenden Landes ändern. Was ist das Problem, das Sie beobachten?

# 4. Aufgabe: Probleme aus Verletzungen der dritten Normalform

Schreiben Sie ein `UPDATE` Statement, wo Sie den aktuellen Bürgermeister einer existierenden Hauptstadt ändern.

Welche Tabellen und Attribute müssen angepasst werden?

Was passiert, wenn Sie die Änderung nur an einer Stelle durchführen?

## Hinweis

Betrachten Sie insbesondere die funktionalen Abhängigkeiten:

$$
\text{id} \to \text{capital\_name}
$$

$$
\text{capital\_name} \to \text{capital\_current\_governor}
$$

Warum ist dies eine transitive Abhängigkeit?

Welche Probleme entstehen dadurch in der Praxis?

# 5. Aufgabe: Probleme aus Verletzungen der Boyce-Codd-Normalform

## Betrachten Sie die Tabelle `city_postcodes`.

Nehmen Sie an:

* Eine Postleitzahl gehört in diesem vereinfachten Modell genau zu einem Bezirk.
* Eine Stadt kann mehrere Postleitzahlen haben.

Welche funktionalen Abhängigkeiten gelten dann?

Prüfen Sie insbesondere:

$$
\text{postcode} \to \text{district}
$$

Warum ist `postcode` kein Superschlüssel?

Erklären Sie, warum dies eine Verletzung der BCNF darstellt.

## Betrachten Sie zusätzlich die Tabelle `ports`.

Warum ist die Speicherung von `river_mouth_coordinates` in `ports` problematisch?

Welche funktionale Abhängigkeit liegt vor?

$$
\text{river\_id} \to \text{river\_mouth\_coordinates}
$$

Warum ist `river_id` in `ports` kein Superschlüssel?

# 6. Aufgabe: 1 NF

Finden Sie im Schema _alle_ Verletzungen der ersten Normalform und korrigieren Sie diese.
Welche Verletzungen haben Sie gefunden?
Schreiben Sie die entsprechenden `CREATE` Statements in ein neues SQL-Script. Schreiben Sie weiterhin ein kurzes Shell-Script, mit dem Sie die existierenden Daten zuvor in Tabellen exportieren, diese dann umformen (`sed`, `cut`, `awk` oder z.B. Python), und Tabellen erzeugen, die ins neue Schema passen.

Warum ist es also wichtig, gleich von Anfang an, ein korrektes Schema zu haben?

# 7. Aufgabe: 2 NF

Finden Sie, nach Erledigung aller vorhergehenden Aufgaben, _alle_ Verletzungen der zweiten Normalform. Welche Verletzungen haben Sie gefunden? Schreiben Sie angepasste `CREATE` Statements, um diese Verletzungen zu korrigieren. Wie könnten Sie weiterhin Datenkonsistenz über diese Korrektur hinaus sicherstellen, welche SQL Anweisungen brauchen Sie?

# 8. Aufgabe: 3 NF

Finden Sie, nach Erledigung aller vorhergehenden Aufgaben, alle Verletzungen der dritten Normalform.

Betrachten Sie insbesondere:

* `countries.capital_name`
* `countries.capital_current_governor`
* `countries_to_rivers.country_capital_name`
* `countries_to_rivers.country_capital_area`

Welche transitiven Abhängigkeiten liegen vor?

Schreiben Sie angepasste `CREATE` Statements, um diese Verletzungen zu korrigieren.

# 9. Aufgabe: BCNF

Finden Sie alle Verletzungen der Boyce-Codd-Normalform.

Betrachten Sie insbesondere:

* `city_postcodes`
* `ports`

Bestimmen Sie jeweils:

* funktionale Abhängigkeiten
* Kandidatenschlüssel
* Superschlüssel
* Determinanten, die keine Superschlüssel sind

Schreiben Sie anschließend ein korrigiertes Schema.

# 10. Aufgabe: Verbesserung des ursprünglichen Schemas

Was fällt Ihnen am Schema `cities` in `RDB_Normalformen.sql` auf? Könnten wir alle deutschen Städte hiermit einpflegen? Welche Probleme treten z.B. bei der Stadt "Hagen" auf?
