---
title: |
    | "Normalformen in Datenbanken in Theorie und Praxis"
author: Prof. Dr. Asis Hallab
geometry: margin=2.5cm
numbersections: false
---

# Musterlösungen für die Übungsaufgaben zur Vorlesung

## 1. Aufgabe: Generieren Sie Daten

### Problem

Zwischen `cities` und `countries` existiert eine zyklische Fremdschlüsselabhängigkeit:

```sql
cities.country_id -> countries.id
countries.(id, capital_name) -> cities.(country_id, name)
```

Dadurch können Datensätze nicht einfach in beliebiger Reihenfolge eingefügt werden.

## Lösungsmöglichkeiten

### Möglichkeit 1: Deferred Foreign Keys

```sql
FOREIGN KEY (id, capital_name)
REFERENCES cities(country_id, name)
DEFERRABLE INITIALLY DEFERRED
```

Die Fremdschlüsselprüfung erfolgt erst beim `COMMIT`.

### Möglichkeit 2: Foreign Keys temporär deaktivieren

Diese Lösung ist spezifisch für SQLite.

```sql
PRAGMA foreign_keys = OFF;
-- INSERT Statements
PRAGMA foreign_keys = ON;
```

### Beispiel INSERT

```sql
INSERT INTO countries (
    id,
    name,
    area,
    languages,
    capital_name,
    capital_current_governor
)
VALUES (
    1,
    'Deutschland',
    357588,
    'Deutsch',
    'Berlin',
    'Kai Wegner'
);
```

## 2. Aufgabe: Probleme aus Verletzungen der ersten Normalform

### Problem

Das Attribut:

```sql
governors TEXT
```

enthält mehrere Werte in einem Feld.

Beispiel:

```text
'Hanno Benz (2023-heute), Jochen Partsch (2017-2023)'
```

Dies verletzt die erste Normalform.

## Problem bei Abfragen

Eine echte Liste von Bürgermeistern liegt nicht vor.

SQL muss den String zunächst parsen.

### Beispiel

```sql
SELECT governors
FROM cities
WHERE name = 'Darmstadt';
```

liefert nur einen langen Textstring.

## Lösungsmöglichkeiten

### Shell

```bash
tr ',' '\n'
```

### awk

```bash
awk -F',' '{for(i=1;i<=NF;i++) print $i}'
```

### Python

```python
text.split(',')
```

## Korrekte Modellierung

```sql
CREATE TABLE city_governors (
    city_name TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    governor_name TEXT NOT NULL,
    from_date TEXT NOT NULL,
    PRIMARY KEY (city_name, country_id, from_date)
);
```

## 3. Aufgabe: Probleme aus Verletzungen der zweiten Normalform

## Speicherabschätzung

Annahmen:

* 10 Unicode Zeichen
* 4 Bytes pro Zeichen

Speicher pro Ländername:

```text
10 * 4 = 40 Bytes
```

Ländername wird benötigt in:

* `countries.name`

Redundant gespeichert wird er zusätzlich in:

* `cities.country_name`
* `ports.country_name`

Bei 100.000 Ländern und 1.000.000 Städten ergibt sich:

```text
countries.name:
100.000 * 40 = 4.000.000 Bytes ca. 4 MB

cities.country_name:
1.000.000 * 40 = 40.000.000 Bytes ca. 40 MB
```

Für `ports.country_name` hängt der Speicherbedarf von der Anzahl der Häfen ab:

```text
N_ports * 40 Bytes
```

Bei ebenfalls 1.000.000 Häfen:

```text
1.000.000 * 40 = 40.000.000 Bytes ≈ 40 MB
```

Gesamt:

```text
4 MB + 40 MB + 40 MB = 84 MB
```

Davon redundant:

```
40 MB + 40 MB = 80 MB
```

## Problem

Würde der Name eines Landes nur in einer Tabelle gespeicher, wäre der
Speicherbedarf deutlich kleiner. Inkonsistenzen könen leicht durch
unvollständige updates entstehen.

## Beispiel UPDATE

```sql
BEGIN;
    UPDATE cities SET country_name = 'Bundesrepublik Deutschland'
        WHERE country_name = 'Deutschland';
    UPDATE countries SET name = 'Bundesrepublik Deutschland'
        WHERE name = 'Deutschland';
    UPDATE ports SET country_name = 'Bundesrepublik Deutschland'
        WHERE country_name = 'Deutschland';
COMMIT;
```

## Korrektur

```sql
CREATE TABLE countries (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);
```

`cities` enthält dann nur noch:

```sql
country_id INTEGER NOT NULL
```

## 4. Aufgabe: Probleme aus Verletzungen der dritten Normalform

## Funktionale Abhängigkeiten

```text
id -> capital_name
capital_name -> capital_current_governor
```

Damit transitiv:

```text
id -> capital_current_governor
```

## Beispiel UPDATE

```sql
BEGIN;
    UPDATE countries SET capital_current_governor = 'Max Beispiel'
        WHERE capital_name = 'Berlin';
    UPDATE cities SET governors = 'Max Beispiel'
        WHERE name = 'Berlin';
COMMIT;
```

## Problem

Die Information über den Bürgermeister gehört semantisch zur Hauptstadt,
nicht direkt zum Land.

Mögliche Probleme:

* Inkonsistenzen
* Mehrfachpflege
* Redundanz
* Änderungsanomalien

## Korrektur

```sql
CREATE TABLE city_governors (
    city_name TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    governor_name TEXT NOT NULL,
    from_date TEXT NOT NULL,
    PRIMARY KEY (city_name, country_id, from_date)
);
```

## 5. Aufgabe: Probleme aus Verletzungen der BCNF

## Tabelle `city_postcodes`

Relation:

```text
city_postcodes(city_name, postcode, district)
```

### Funktionale Abhängigkeiten

```text
(city_name, postcode) -> district
postcode -> district
```

### Kandidatenschlüssel

```text
(city_name, postcode)
```

### Problem

`postcode` bestimmt `district`, ist aber kein Superschlüssel.

Damit liegt eine BCNF-Verletzung vor.

## Tabelle `ports`

Relation:

```text
ports(name, river_id, river_mouth_coordinates, country_id)
```

### Funktionale Abhängigkeit

```text
river_id -> river_mouth_coordinates
```

`river_id` ist kein Superschlüssel.

### Problem

Die Flussmündung ist Eigenschaft des Flusses,
nicht des Hafens.

## 6. Aufgabe: 1 NF

## Verletzungen

### Tabelle `cities`

```sql
governors TEXT
```

#### Korrektur

_Siehe `city_governors` oben._

### Tabelle `countries`

```sql
languages TEXT
```

#### Korrektur

```sql
CREATE TABLE country_languages (
    country_id INTEGER NOT NULL,
    language TEXT NOT NULL,
    PRIMARY KEY (country_id, language)
);
```

## Warum wichtig?

Nicht-atomare Attribute:

* erschweren Abfragen
* verhindern einfache Aggregationen
* erfordern Parsing
* erschweren Datenkonsistenz

## 7. Aufgabe: 2 NF

## Verletzungen

### Tabelle `cities`

```text
country_id -> country_name
```

bei Schlüssel:

```text
(name, country_id)
```

### Tabelle `ports`

```text
country_id -> country_name
```

bei Schlüssel:

```text
(name, country_id)
```

## Korrektur

`country_name` entfernen.

```sql
BEGIN;
    ALTER TABLE cities DROP COLUMN country_name;
    ALTER TABLE ports DROP COLUMN country_name;
COMMIT;
```

Ländernamen ausschließlich in `countries` speichern. Die Information kann über
`JOIN` Statements selektiert werden:

```sql
SELECT * FROM cities AS c
    LEFT JOIN countries AS n ON c.country_id = n.id
    WHERE c.name = 'Berlin';
```

## Konsistenz

Referenzielle Integrität über:

```sql
FOREIGN KEY
```

sicherstellen.

## 8. Aufgabe: 3 NF

## Verletzungen

### Tabelle `countries`

```text
id -> capital_name
capital_name -> capital_current_governor
```

### Tabelle `countries_to_rivers`

```text
country_id -> country_capital_name
country_capital_name -> country_capital_area
```

## Probleme

* Transitive Abhängigkeiten
* Inkonsistenzen
* Mehrfachspeicherung semantisch gleicher Informationen

## Korrektur

Hauptstadtinformationen auslagern z.B. in `countries` über einen Foreign Key,
der die Hauptstadt eindeutig referenziert.

## 9. Aufgabe: BCNF

### Tabelle `city_postcodes`

Relation:

```text
city_postcodes(city_name, postcode, district)
````

### Determinant

```text
postcode
```

### Funktionale Abhängigkeit

```text
postcode -> district
```

### Kandidatenschlüssel

```text
(city_name, postcode)
```

### Problem

`postcode` ist kein Superschlüssel.

Trotzdem bestimmt `postcode` das Attribut `district`.

Damit gilt:

```text
X -> A
```

aber `X` ist kein Superschlüssel.

Damit ist die BCNF verletzt.

### Zerlegung in BCNF

```sql
CREATE TABLE postcodes (
    postcode TEXT PRIMARY KEY,
    district TEXT NOT NULL
);

CREATE TABLE city_postcodes (
    city_name TEXT NOT NULL,
    postcode TEXT NOT NULL,
    PRIMARY KEY (city_name, postcode),
    FOREIGN KEY (postcode) REFERENCES postcodes(postcode)
);
```

### Begründung

In `postcodes` gilt:

```text
postcode -> district
```

und `postcode` ist Schlüssel.

In der neuen Tabelle `city_postcodes` bleibt nur die Beziehung zwischen Stadt und Postleitzahl erhalten.

Damit bestimmt kein Nicht-Schlüssel mehr ein anderes Attribut.


## Tabelle `ports`

Determinant:

```text
river_id
```

Funktionale Abhängigkeit:

```text
river_id -> river_mouth_coordinates
```

`river_id` ist kein Superschlüssel.

## Korrektur

Flussbezogene Informationen ausschließlich in `rivers` speichern.

## 10. Aufgabe: Verbesserung des ursprünglichen Schemas

## Problem

Der Primärschlüssel von `cities` lautet:

```sql
PRIMARY KEY(name, country_id)
```

## Schwierigkeit

Städtenamen sind nicht eindeutig.

Beispiel:

```text
Hagen
```

Es existieren mehrere Orte mit diesem Namen.

## Konsequenzen

* natürliche Schlüssel sind instabil
* Umbenennungen problematisch
* reale Daten schwer modellierbar

## Bessere Lösung

```sql
CREATE TABLE cities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    country_id INTEGER NOT NULL
);
```

Natürliche Schlüssel können zusätzlich über:

```sql
UNIQUE(name, country_id)
```

modelliert werden.
