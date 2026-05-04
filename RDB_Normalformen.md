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
\text{cities}(\text{id}, \text{name}, \text{area}, \text{is\_capital}, \text{country\_id})
$$

Mit Domänen:
$$
\text{id} : D_{\text{id}}, \quad
\text{name} : D_{\text{name}}, \quad
\text{area} : D_{\text{area}}, \quad
\text{is\_capital} : D_{\text{is\_capital}}, \quad
\text{country\_id} : D_{\text{country\_id}}
$$

Zum Beispiel:
$$
D_{\text{id}} = \mathbb{N}, \quad
D_{\text{name}} = \text{String}, \quad
D_{\text{area}} = \mathbb{R}_{\ge 0}, \quad
D_{\text{is\_capital}} = \{\text{true}, \text{false}\}, \quad
D_{\text{country\_id}} = \mathbb{N}
$$

Die Relation selbst ist eine Teilmenge des kartesischen Produkts:
$$
\text{cities} \subseteq
D_{\text{id}} \times
D_{\text{name}} \times
D_{\text{area}} \times
D_{\text{is\_capital}} \times
D_{\text{country\_id}}
$$

# Beispiel Eintrag in Tabelle Stadt

Ein Tupel $t \in \text{cities}$ ist ein einzelner Eintrag der Tabelle, zum Beispiel:

$$
t = (1,\; \text{"Berlin"},\; 891.7,\; \text{true},\; 49)
$$

Formal als Funktion:
$$
t : \{\text{id}, \text{name}, \text{area}, \text{is\_capital}, \text{country\_id}\}
\to
D_{\text{id}} \cup D_{\text{name}} \cup D_{\text{area}} \cup D_{\text{is\_capital}} \cup D_{\text{country\_id}}
$$

mit:
$$
\begin{gathered}
t(\text{id}) = 1,\quad
t(\text{name}) = \text{"Berlin"},\quad
t(\text{area}) = 891.7,\quad \\
t(\text{is\_capital}) = \text{true},\quad
t(\text{country\_id}) = 49
\end{gathered}
$$

# Zugriff auf Attribute einer Stadt

Attributzugriff auf ein Tupel der Tabelle \texttt{cities}:
$$
t[\text{name}] = \text{"Berlin"}
$$
$$
t[\text{area}] = 891.7
$$

Projektion auf Attribute einer Relation:
$$
\pi_{\text{name}}(\text{Stadt})
$$
liefert die Menge aller Städtenamen.

$$
\pi_{\text{name},\text{area}}(\text{Stadt})
$$
liefert die Relation aus den Spalten `name` und `area`.

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


# Beispiel (nicht in 1NF)

| id | name | governors |
|---|---|---|
| 1  | Darmstadt | "Hanno Benz, Jochen Partsch"|


# Beispiel in 1NF überführt

Tabelle \texttt{cities}:

| id | name   | governor  |
|----|--------|-------|
| 1  | Darmstadt | "Hanno Benz" |
| 1  | Darmstadt | "Jochen Partsch" |

# 1NF Formal (algebraische Sicht)

Keine **nicht-atomaren Werte** in Tupeln

## Idee

Verletzung von 1NF:
Ein Attribut enthält mehrere Werte pro Tupel

## Beispiel (nicht in 1NF)

Relation:
$$
R(\text{id}, \text{name}, \text{governors})
$$

mit Tupel:
$$
t = (1,\; \text{"Darmstadt"},\; \{\text{"Benz"},\; \text{"Partsch"}\})
$$

$\Rightarrow$ $\text{governors} \notin D_{\text{governors}}$ (nicht atomar)

# Algebraische Transformation

Ersetze nicht-atomare Werte durch **mehrere Tupel**:

$$
R' = \bigcup_{v \in t(\text{governors})}
(1,\; \text{"Darmstadt"},\; v)
$$

## Resultat (1NF)

$$
R'(\text{id}, \text{name}, \text{governor})
$$

mit:
$$
(1,\; \text{"Darmstadt"},\; \text{"Benz"})
$$
$$
(1,\; \text{"Darmstadt"},\; \text{"Partsch"})
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

# Beispiel (nicht in 2NF)

Relation:
$$
R(\text{country\_id}, \text{river\_id}, \text{country\_name}, \text{river\_name})
$$

Schlüssel:
$$
K = (\text{country\_id}, \text{river\_id})
$$

Funktionale Abhängigkeiten:
$$
\text{country\_id} \to \text{country\_name}
$$
$$
\text{river\_id} \to \text{river\_name}
$$

$\Rightarrow$ partielle Abhängigkeiten von Teilmengen von $K$

# In 2NF überführt

Zerlegung in Relationen mit vollen Abhängigkeiten:

$$
\text{countries}(\text{id}, \text{name}, \text{area})
$$

$$
\text{rivers}(\text{id}, \text{name}, \text{length})
$$

$$
\text{countries\_to\_rivers}(\text{country\_id}, \text{river\_id})
$$

## Eigenschaften

- Keine Redundanz von Namen
- Änderungen lokal
- Struktur entspricht funktionalen Abhängigkeiten

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
