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
* Code in English, Inhalt in Deutsch

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

Schema:

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
$$

# Schema Stadt `cities`

Schema:
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
\text{name} : D_{\text{name}}, \quad
\text{country\_name} : D_{\text{country\_name}}, \quad
\text{area} : D_{\text{area}}, \quad \\
\text{governors} : D_{\text{governors}}, \quad
\text{country\_id} : D_{\text{country\_id}}
\end{gathered}
$$

Zum Beispiel:
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

| id | name | governors |
|---|---|---|
| 1  | Darmstadt | "Hanno Benz, Jochen Partsch"|

# Beispiel `cities` in 1NF überführt

Neue Tabelle \texttt{city\_governors}:

| city_name | country_id | governor_name | from_date |
|---|---:|---|---|
| Darmstadt | 1 | "Jochen Partsch" | "2017-06-25" |
| Darmstadt | 1 | "Hanno Benz" | "2023-06-25" |

# 1NF Formal (algebraische Sicht)

Keine **nicht-atomaren Werte** in Tupeln

## Idee

Verletzung von 1NF:
Ein Attribut enthält mehrere Werte pro Tupel

## Beispiel (nicht in 1NF)

Relation:
$$
R(\text{city\_name}, \text{country\_id}, \text{governors})
$$

mit Tupel:
$$
t = (\text{"Darmstadt"},\; 1,\; \{(\text{"Jochen Partsch"}, \text{"2017-06-25"}),\;(\text{"Hanno Benz"}, \text{"2023-06-25"})\})
$$

$\Rightarrow$ $\text{governors} \notin D_{\text{governors}}$ (nicht atomar)

# Algebraische Transformation

Ersetze nicht-atomare Werte durch **mehrere Tupel**:

$$
R' = \bigcup_{(g,d) \in t(\text{governors})}
(\text{"Darmstadt"},\; 1,\; g,\; d)
$$

## Resultat (1NF)

$$
R'(\text{city\_name}, \text{country\_id}, \text{governor\_name}, \text{from\_date})
$$

mit:
$$
(\text{"Darmstadt"},\; 1,\; \text{"Jochen Partsch"},\; \text{"2017-06-25"})
$$
$$
(\text{"Darmstadt"},\; 1,\; \text{"Hanno Benz"},\; \text{"2023-06-25"})
$$

# 1NF Formale Interpretation

- Keine Mengenwerte in Attributen  
- Relation bleibt Teilmenge eines kartesischen Produkts  
- Alle Tupel sind wohldefiniert in:
$$
D_{\text{id}} \times D_{\text{name}} \times D_{\text{governor}}
$$

# Zweite Normalform (2NF)

Eine Relation ist in **2NF**, wenn sie in 1NF ist und
alle Nicht-Schlüsselattribute **voll funktional** vom gesamten Schlüssel abhängen

## Formal

Sei
$$
R(A_1, \dots, A_n)
$$

mit Schlüssel $K \subseteq \{A_1, \dots, A_n\}$

Dann gilt für alle funktionalen Abhängigkeiten:
$$
X \to A,\quad A \notin K
$$

$$
X \subseteq K \;\Rightarrow\; X = K
$$

Keine **partiellen Abhängigkeiten** von Teilmengen des Schlüssels

# Beispiel `cities` nicht in 2NF

Relation:
$$
\text{cities}(\text{name}, \text{country\_name}, \text{country\_id}, \dots)
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

# Problem

Bei mehreren Städten desselben Landes wird der Ländername mehrfach gespeichert:

| name | country_id | country_name |
|---|---:|---|
| Berlin | 1 | Deutschland |
| Darmstadt | 1 | Deutschland |
| Köln | 1 | Deutschland |

## Konsequenz

- Redundanz
- Änderungsanomalien
- Verletzung der 2NF

# In 2NF überführt

Zerlegung in Relationen mit vollen Abhängigkeiten:

$$
\text{cities}(\text{name}, \text{country\_id}, \dots)
$$

$$
\text{countries}(\text{id}, \text{name}, \dots)
$$

## Eigenschaften

- \texttt{country\_name} steht nur noch in \texttt{countries.name}
- Änderungen am Ländernamen erfolgen lokal
- Keine partielle Abhängigkeit vom zusammengesetzten Schlüssel

# Dritte Normalform (3NF)

Eine Relation ist in **3NF**, wenn sie in 2NF ist und
keine **transitiven Abhängigkeiten** zwischen Nicht-Schlüsselattributen existieren

## Formal

Sei
$$
R(A_1, \dots, A_n)
$$

mit Schlüssel $K$

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

# 3NF – Beispiel mit is_capital

Relation:
$$
\text{cities}(\text{id}, \text{name}, \text{area}, \text{is\_capital}, \text{country\_id})
$$

Schlüssel:
$$
\text{id}
$$

## Funktionale Abhängigkeiten

$$
\text{id} \to \text{country\_id}
$$

$$
(\text{country\_id}, \text{name}) \to \text{is\_capital}
$$

## Problem

$$
\text{country\_id} \to \text{is\_capital}
$$

(da jedes Land genau eine Hauptstadt hat)

$Rightarrow$ transitiv:
$$
\text{id} \to \text{is\_capital}
$$

## Interpretation

- \(\text{is\_capital}\) hängt **nicht direkt** vom Schlüssel ab  
- sondern über \(\text{country\_id}\)

$Rightarrow$ **Verletzung der 3NF**

## Lösung (3NF)

Trenne Hauptstadtinformation aus:

$$
\text{countries}(\text{id}, \text{name}, \text{area}, \text{capital\_city\_id})
$$

$$
\text{cities}(\text{id}, \text{name}, \text{area}, \text{country\_id})
$$

## Effekt

- Keine transitiven Abhängigkeiten  
- Eindeutige Modellierung der Hauptstadt

## Eigenschaften

- Keine transitiven Abhängigkeiten
- Keine Redundanz über Fremdschlüssel hinweg
- Änderungen konsistent möglich

# Boyce-Codd-Normalform (BCNF)

Eine Relation ist in **BCNF**, wenn für jede nicht-triviale funktionale Abhängigkeit gilt:

$$
X \to A \;\Rightarrow\; X \text{ ist ein Superschlüssel}
$$

# Intuition

- **Nur Schlüssel bestimmen Attribute**
- Strenger als 3NF

# Beispiel (nicht in BCNF)

Relation:
$$
\text{cities}(\text{id}, \text{name}, \text{country\_id}, \text{is\_capital})
$$

Funktionale Abhängigkeiten:

$$
\text{id} \to \text{name}, \text{country\_id}, \text{is\_capital}
$$

$$
\text{country\_id} \to \text{is\_capital}
$$

Schlüssel:
$$
\text{id}
$$

## Problem

$$
\text{country\_id} \to \text{is\_capital}
$$

aber:
$$
\text{country\_id} \text{ ist kein Superschlüssel}
$$

$Rightarrow$ Verletzung von BCNF

# In BCNF überführt

Zerlegung:

$$
\text{cities}(\text{id}, \text{name}, \text{country\_id})
$$

$$
\text{countries}(\text{id}, \text{capital\_city\_id})
$$

# Eigenschaften

- Keine funktionalen Abhängigkeiten von Nicht-Schlüsseln  
- Keine Redundanz durch implizite Regeln  
- Eindeutige Verantwortlichkeit pro Relation

# Normalformen Zusammenfassung

* 1NF: keine Listen
* 2NF: keine Teilabhängigkeiten
* 3NF: keine indirekten Abhängigkeiten
* BCNF: nur Schlüssel bestimmen etwas
