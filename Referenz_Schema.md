---
title: |
    | Normalformen in Datenbanken in Theorie und Praxis — Referenzschema
author: Prof. Dr. Asis Hallab
date: 13.06.2026
numbersections: false
aspectratio: 169
theme: Pittsburgh
colortheme: default
---

# Referenzschema für alle Beispiele

$$
\text{cities}(\text{id}, \text{name}, \text{area}, \text{is\_capital}, \text{country\_id})
$$

$$
\text{countries}(\text{id}, \text{name}, \text{area})
$$

$$
\text{rivers}(\text{id}, \text{name}, \text{length})
$$

$$
\text{countries\_to\_rivers}(\text{country\_id}, \text{river\_id})
$$

## Domänen

$$
\text{id}, \text{country\_id}, \text{river\_id} \in \mathbb{N}
$$

$$
\text{area}, \text{length} \in \mathbb{R}_{>0}
$$

$$
\text{is\_capital} \in \{\text{true}, \text{false}\}
$$

$$
\text{name} \in \text{String}
$$

## Schlüssel

Primärschlüssel:
$$
\text{cities.id},\quad \text{countries.id},\quad \text{rivers.id}
$$

$$
(\text{country\_id}, \text{river\_id}) \text{ für } \text{countries\_to\_rivers}
$$

## Fremdschlüssel

$$
\text{cities.country\_id} \subseteq \text{countries.id}
$$

$$
\text{countries\_to\_rivers.country\_id} \subseteq \text{countries.id}
$$

$$
\text{countries\_to\_rivers.river\_id} \subseteq \text{rivers.id}
$$

## Kardinalitäten

- 1:n  
$$
\text{countries} \to \text{cities}
$$

- n:m  
$$
\text{countries} \leftrightarrow \text{rivers}
$$

- 1:1 (semantisch)  
$$
\text{countries} \leftrightarrow \text{cities} \quad (\text{is\_capital} = \text{true})
$$
