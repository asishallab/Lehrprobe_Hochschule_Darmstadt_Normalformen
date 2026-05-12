---
title: |
    | Normalformen in Datenbanken in Theorie und Praxis
author: Prof. Dr. Asis Hallab
date: 13.06.2026
numbersections: false
aspectratio: 169
theme: Pittsburgh
colortheme: default
---

# Vorwort

* Diese Vorlesung richtet sich an Studierende der Informatik und verwandter Fächer ab dem 2. Semester.
* Grundkenntnisse in relationalen Datenbanken werden vorausgesetzt:
  * grundlegende Kommandos in Structured Query Language (SQL)
  * Grundlagen der relationalen Algebra
* Schema für: Stadt, Land, Fluss
* Vorlesung in Deutsch
* SQL-Code and Comments in English

# Relationale Datenbanken

:::: columns

::: column
![Aus den Memoiren meine Tante, geb. 1936](./assets/Einblicke_Datenbanken_IBM.png){width=100%}
:::

::: column
![Bei der IBM 1959](./assets/IBM_1959.png){width=100%}
:::

::::

# Tabellen

:::: columns

::: column
* Sumerisches Beispiel einer Multiplikationstabelle für Längenmaße (rechts), deren Produkte als Flächenmaße angegeben werden.
* Eine Tabelle ist eine der ältesten Formen der Datendarstellung.
:::

::: column
![Sumerische Rechentafel, 2700 v. Chr.; vermutlich der älteste bekannte mathematische Text.](./assets/Sumerische_Rechentafel.png){height=60%}
:::

::::


# Relationen (Tabellen)

Eine Relation $R$ ist eine **endliche Menge von Tupeln** über einem Schema:

$$
R \subseteq D_1 \times D_2 \times \dots \times D_n
$$

Schema / Signatur:

$$
R(A_1, A_2, \dots, A_n)
$$

- $A_i$: Attributnamen  
- $D_i$: Wertebereiche (Domänen)

# Tupel (Einträge)

Ein Tupel $t \in R$ ist eine **Funktion**:

$$
t : \{A_1, \dots, A_n\} \to D_1 \cup \dots \cup D_n
$$

mit:

$$
t(A_i) \in D_i
$$

Kurzschreibweise:

$$
t = (a_1, a_2, \dots, a_n)
\quad \text{mit } a_i \in D_i
$$

# Erste Relation `cities` aus Stadt, Land, Fluss

Beispiel-Schema:
$$
\text{cities}(\text{name}, \text{country\_name}, \text{area}, \text{governors}, \text{country\_id})
$$

Schlüssel:
$$
(\text{name}, \text{country\_id})
$$

Mit Domänen:
$$
\begin{gathered}
D_{\text{name}} = \text{String}, \quad
D_{\text{country\_name}} = \text{String}, \quad
D_{\text{area}} = \mathbb{R}_{> 0}, \quad \\
D_{\text{governors}} = \text{String}, \quad
D_{\text{country\_id}} = \mathbb{N}
\end{gathered}
$$

Die Relation selbst ist eine Teilmenge des kartesischen Produkts:
$$
\text{cities} \subseteq
D_{\text{name}} \times
D_{\text{country\_name}} \times
D_{\text{area}} \times
D_{\text{governors}} \times
D_{\text{country\_id}}
$$

# Relation vs. Tabelle (Kurzform)

Tabelle (praktisch) $\approx$ Relation (formal)

Zeile $\approx$ Tupel

Spalte $\approx$ Attribut

## Wichtige Eigenschaften

- Keine Duplikate von Tupeln
- Keine Reihenfolge von Tupeln
- Keine Reihenfolge von Attributen

# Erste Normalform (1NF)

Eine Relation ist in **1NF**, wenn alle Attributwerte **atomar** sind.

## Formal

Sei
$$
R(A_1, \dots, A_n), \quad A_i : D_i
$$

Dann gilt:
$$
\forall t \in R,\; \forall A_i:\; t(A_i) \in D_i
$$

mit **atomaren Domänen** $D_i$


# 1NF Intuition

- Keine Listen
- Keine Mengen
- Keine verschachtelten Strukturen

Jedes Feld enthält genau **einen Wert**


# Beispiel `cities` (nicht in 1NF)

| name | governors |
|---|---|
| Darmstadt | "Hanno Benz (ab Juni 2023), Jochen Partsch (ab Juni 2011)"|

## Probleme bei nicht erfüllter 1NF

* Es gibt kein SQL Kommando, um den Bürgermeister für seinen Amtsbeginn direkt
  auszulesen.
* Man müsste in seinem Programmcode den String
  ```text
  Hanno Benz (ab Juni 2023), Jochen Partsch (ab Juni 2011)
  ```
  parsen.

# Algorithmus zur Überführung in 1NF

* Ersetze nicht-atomare Werte durch **mehrere Tupel**:
  $$
  R' =
  \{
  (\text{"Darmstadt"},\; 1,\; g,\; d)
  \mid
  (g,d) \in t(\text{governors})
  \}
  $$

  mit:
  $$
  g \in D_{\text{governor,String}}
  \quad \text{und} \quad
  d \in D_{\text{Amtsbeginn,Date}}
  $$
  
* Lagere mehrwertige oder zusammengesetzte Attribute in eine eigene Relation aus
* Verknüpfe die neue Relation über Fremdschlüssel

# Ergebnis: `cities` in 1NF überführt

Neue Tabelle \texttt{city\_governors}:

| id | name | country_id | governor_name | from_date |
|---|---|---:|---|---|
| 1 | Darmstadt | 1 | "Jochen Partsch" | "2017-06-25" |
| 2 | Darmstadt | 1 | "Hanno Benz" | "2023-06-25" |

Mit dem Fremdschlüssel:
```sql
FOREIGN KEY (name, country_id) REFERENCES 
  cities (name, country_id)
```

# 1NF Zusammenfassung

- Keine Mengenwerte in Attributen  
- Relation bleibt Teilmenge eines kartesischen Produkts  
- Im Beispiel sind alle Tupel wohldefiniert in:
$$
\begin{gathered}
D_{\text{city\_name}} \times \\
D_{\text{country\_id}} \times \\
D_{\text{governor\_name}} \times \\
D_{\text{from\_date}}
\end{gathered}
$$

# Zweite Normalform (2NF)

Eine Relation ist in **2NF**, wenn sie in 1NF ist und alle Nicht-Schlüsselattribute **voll funktional** vom gesamten Schlüssel abhängen.

## Formal

Sei
$$ R(A_1, \dots, A_n) $$

Dann gilt für alle funktionalen Abhängigkeiten
$$
X \to A,\quad A \notin K
$$

darf nicht gelten:
$$
X \subsetneq K
$$

Keine **partiellen Abhängigkeiten** von Teilmengen des Schlüssel.

# 2NF Intuition

- Attribute sollen vom **gesamten Schlüssel** abhängen.
- Nicht nur von einem Teil eines zusammengesetzten Schlüssels.
- Jede Information soll genau dort gespeichert werden,
  wo sie logisch hingehört.

# Beispiel `cities` nicht in 2NF

Relation:
$$
\text{cities}(\text{name}, \text{country\_id}, \text{country\_name}, \dots)
$$

Schlüssel:
$$
K = (\text{name}, \text{country\_id})
$$

Funktionale Abhängigkeit:
$$
\text{country\_id} \to \text{country\_name}
$$

$\Rightarrow$ \texttt{country\_name} hängt nur von einem Teil des Schlüssels ab

# Probleme bei nicht erfüllter 2NF

Bei mehreren Städten desselben Landes wird der Ländername mehrfach gespeichert:

| name | country_id | country_name |
|---|---:|---|
| Berlin | 1 | Deutschland |
| Darmstadt | 1 | Deutschland |
| Köln | 1 | Deutschland |

## Konsequenz

- Redundanz: Der Name des Landes steht _auch_ in `countries.name`.
- Änderungsanomalien; Bsp.: Update "Deutschland" zu "Bundesrepublik
  Deutschland" in `countries` aber vergesse update `cities`.

# Algorithmus zur Überführung in 2NF

- Entferne partielle Abhängigkeiten.
- Lagere abhängige Attribute in eigene Relationen aus.
- Verbinde Relationen bei Bedarf über `JOIN`.

# Schema in 2NF überführt

Zerlegung in Relationen mit vollen funktionalen Abhängigkeiten:

$$
\text{cities}(\text{name}, \text{country\_id}, \dots)
$$

$$
\text{countries}(\text{id}, \text{name}, \dots)
$$

## Resultat (2NF)

$$
R_1 = \text{countries}(\text{id}, \text{name})
$$

$$
R_2 = \text{cities}(\text{name}, \text{country\_id}, \dots)
$$

## Eigenschaften

- \texttt{country\_name} steht nur noch in \texttt{countries.name}
- Änderungen am Ländernamen erfolgen lokal
- Keine partielle Abhängigkeit vom zusammengesetzten Schlüssel
- Mit
  ```sql
  SELECT * FROM cities AS c LEFT JOIN countries AS n
    ON c.country_id = n.id;
  ```
  erhalte ich immer noch die Ländernamen.

# Zusammenfassung 2NF

- Keine partiellen Abhängigkeiten.
- Nicht-Schlüsselattribute hängen vom gesamten Schlüssel ab.
- Redundante Attribute werden in eigene Relationen ausgelagert.
- Daten bleiben über `JOIN` rekonstruierbar.

# Dritte Normalform (3NF)

Eine Relation ist in **3NF**, wenn sie in 2NF ist und
keine **transitiven Abhängigkeiten** zwischen Nicht-Schlüsselattributen existieren

## Formal

Sei
$$
R(A_1, \dots, A_n)
$$

mit Schlüssel $K$

Ein **Superschlüssel** ist eine Attributmenge,
die jedes Tupel eindeutig identifiziert:

$$
X \to A_1, \dots, A_n
$$

Für jede funktionale Abhängigkeit:
$$
X \to A
$$

gilt:
$$
\text{entweder } X \text{ ist Superschlüssel}
\quad \text{oder} \quad
A \in K
$$

# Intuition

- Nicht-Schlüsselattribute dürfen **nicht voneinander abhängen**
- Alle Informationen hängen **direkt vom Schlüssel** ab

# Beispiel `countries` nicht in 3NF

Relation:
$$
\text{countries}(\text{id}, \text{name}, \text{area}, \text{languages}, \text{capital\_name}, \text{capital\_current\_governor})
$$

Schlüssel:
$$
K = \text{id}
$$

## Funktionale Abhängigkeiten

$$
\text{id} \to \text{capital\_name}
$$

$$
\text{capital\_name} \to \text{capital\_current\_governor}
$$

# Verletzung der 3NF

Damit gilt transitiv:
$$
\text{id} \to \text{capital\_current\_governor}
$$

aber \texttt{capital\_current\_governor} ist keine direkte Eigenschaft des
Landes, sondern der Hauptstadt bzw. `city_governors`.

Genauer: Das Nicht-Schlüsselattribut hängt transitiv von Schlüssel ab.
$\Rightarrow$ Verletzung der 3NF

# Probleme bei nicht erfüllter 3NF - Beispiel

Bei transitiven Abhängigkeiten werden Informationen **redundant** gespeichert:

| id | name | capital_name | capital_current_governor |
|---:|---|---|---|
| 1 | Deutschland | Berlin | Kai Wegner |
| 2 | Deutschland | Berlin | Franz Beispiel |

Änderungen des aktuellen `governor` müssten in `city_governors` *und*
`countries` durchgeführt werden.

# Algorithmus zur Überführung in 3NF

- Entferne transitive Abhängigkeiten
- Lagere indirekt abhängige Attribute in eigene Relationen aus
- Speichere Informationen nur bei der Entität,
  zu der sie semantisch gehören
- Verbinde Relationen bei Bedarf über Fremdschlüssel und `JOIN`

# Schema in 3NF überführt

Trenne Hauptstadtinformationen aus:

$$
\text{countries}(\text{id}, \text{name}, \text{area}, \text{languages}, \text{capital\_name})
$$

$$
\text{city\_governors}(\text{city\_name}, \text{country\_id}, \text{governor\_name}, \text{from\_date})
$$

## Lösung

Der aktuelle Bürgermeister wird nicht redundant in \texttt{countries} gespeichert,
sondern aus \texttt{city\_governors} bestimmt.

# Eigenschaften

- Keine transitiven Abhängigkeiten
- Keine Redundanz von Bürgermeisterdaten
- Änderungen an Stadtregierungen erfolgen lokal

# Zusammenfassung 3NF

- Keine transitiven Abhängigkeiten
- Nicht-Schlüsselattribute hängen nicht voneinander ab
- Informationen werden nur bei ihrer eigentlichen Entität gespeichert
- Daten bleiben über `JOIN` rekonstruierbar

# Boyce-Codd-Normalform (BCNF)

Eine Relation ist in **BCNF**, wenn für jede nicht-triviale funktionale Abhängigkeit gilt:

$$
X \to A \;\Rightarrow\; X \text{ ist ein Superschlüssel}
$$

## Determinant

Die linke Seite einer funktionalen Abhängigkeit
heißt **Determinant**.

In:
$$
X \to A
$$

ist also:
$$
X
$$

der Determinant.

# Intuition

- Jeder Determinant muss ein Schlüssel sein
- Nur Schlüssel dürfen andere Attribute bestimmen
- Strenger als 3NF

# Beispiel `city_postcodes` nicht in BCNF

Relation:
$$
\text{city\_postcodes}(\text{city\_name}, \text{postcode}, \text{district})
$$

## Schlüssel

$$
(\text{city\_name}, \text{postcode})
$$

## Funktionale Abhängigkeiten

$$
(\text{city\_name}, \text{postcode})
\to
\text{district}
$$

Zusätzliche Annahme:
$$
\text{postcode} \to \text{district}
$$

# Problem

$$
\text{postcode} \to \text{district}
$$

aber:
$$
\text{postcode}
$$

ist kein Superschlüssel.

$\Rightarrow$ Verletzung der BCNF

# Probleme bei nicht erfüllter BCNF

| city_name | postcode | district |
|---|---|---|
| Köln        | 50667 | Innenstadt |
| Musterstadt | 50667 | Altstadt |

## Probleme

- Widersprüchliche Fakten möglich
- Dieselbe Postleitzahl bestimmt mehrere Bezirke
- Semantische Regeln werden nicht erzwungen

# Algorithmus zur Überführung in BCNF

- Bestimme alle funktionalen Abhängigkeiten
- Suche Determinanten, die keine Superschlüssel sind
- Lagere die davon abhängigen Attribute in eigene Relationen aus
- Zerlege Relationen so, dass jeder Determinant ein Schlüssel wird
- Verbinde Relationen bei Bedarf über Fremdschlüssel und `JOIN`

# Schema in BCNF überführt

$$
\text{postcodes}(\text{postcode}, \text{district})
$$

$$
\text{city\_postcodes}(\text{city\_name}, \text{postcode})
$$

# Eigenschaften

- Jeder Determinant ist ein Schlüssel
- Keine widersprüchlichen Ableitungen
- Funktionale Abhängigkeiten eindeutig modelliert

# Zusammenfassung BCNF

- Jeder Determinant ist ein Superschlüssel
- Nur Schlüssel dürfen andere Attribute bestimmen
- Strenger als 3NF
- Funktionale Abhängigkeiten werden eindeutig modelliert
- Daten bleiben über `JOIN` rekonstruierbar

# Normalformen Zusammenfassung

* 1NF: Keine Listen
* 2NF: Keine Teilabhängigkeiten
* 3NF: Keine indirekten Abhängigkeiten
* BCNF: Nur Superschlüssel bestimmen Attribute

_Dankeschön!_
