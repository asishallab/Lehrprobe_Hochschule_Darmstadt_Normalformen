-- Step One: Setup Schema
-------------------------
BEGIN;

  -- CREATE cities
  CREATE TABLE cities (
    name TEXT NOT NULL,
    country_name TEXT NOT NULL,
    area REAL NOT NULL CHECK (area > 0),
    governors TEXT NOT NULL, -- NF 1: Example entry 'Hanno Benz (2023-heute), Jochen Bartsch (2017-2023)' 
    country_id INTEGER NOT NULL,
    PRIMARY KEY (name, country_id), -- NF 2: country_name only depends on country_id NOT on name of the city
    FOREIGN KEY (country_id) REFERENCES countries(id)
  );

  -- CREATE countries
  CREATE TABLE countries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    area REAL NOT NULL CHECK (area > 0),
    languages TEXT NOT NULL,
    capital_name TEXT NOT NULL, -- NF 3: Transitive Abhängigkeit id→capital_id und capital_id→capital_name,capital_current_governor Also transitiv: id→capital_current_governor
    capital_current_governor TEXT NOT NULL,
    FOREIGN KEY (id, capital_name) REFERENCES cities(country_id, name)
  );

  -- CREATE rivers
  CREATE TABLE rivers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    length REAL NOT NULL CHECK (length > 0)
  );

  -- CREATE cross-table countries_to_rivers
  CREATE TABLE countries_to_rivers (
    country_id INTEGER NOT NULL,
    river_id INTEGER NOT NULL,
    PRIMARY KEY (country_id, river_id),
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (river_id) REFERENCES rivers(id)
  );

  -- CREATE relation between rivers and cities
  CREATE TABLE river_cities (
      river_name TEXT NOT NULL,
      city_name TEXT NOT NULL,
      river_km REAL NOT NULL CHECK (river_km >= 0),
      PRIMARY KEY (river_name, city_name),
      UNIQUE (river_name, river_km)
  );

COMMIT;
-- END Step One

-- Step Two - Solve a violation of 1NF
BEGIN;

  -- One tuple per city-governor pair
  CREATE TABLE city_governors (
    city_name TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    governor_name TEXT NOT NULL,
    from_date TEXT NOT NULL,
    PRIMARY KEY (city_name, country_id, from_date),
    FOREIGN KEY (city_name, country_id)
        REFERENCES cities(name, country_id)
  );

  -- Clean up violation of 1NF
  ALTER TABLE cities DROP COLUMN governors;

COMMIT;
-- END STEP Two

-- INSERT example data:
-- Countries
INSERT INTO countries (name, area, languages) VALUES
('Deutschland', 357000, 'Deutsch'),
('Österreich', 84000, 'Deutsch'),
('Ungarn', 93000, 'Ungarisch');

-- Rivers
INSERT INTO rivers (name, length) VALUES
('Rhein', 1230),
('Donau', 2850);

-- Cities
INSERT INTO cities (name, area, is_capital, governors, country_id) VALUES
('Wien', 415, 1, 'Michael Ludwig', 2),
('Budapest', 525, 1, 'Gergely Karácsony', 3),
('Berlin', 892, 1, 'Kai Wegner', 1),
('Darmstadt', 122, 0, 'Hanno Benz, Jochen Partsch', 1),
('Köln', 405, 0, 'Henriette Reker', 1);

-- countries_to_rivers (n:m)
INSERT INTO countries_to_rivers (country_id, river_id) VALUES
(1, 1), -- Deutschland - Rhein
(1, 2), -- Deutschland - Donau
(2, 2), -- Österreich - Donau
(3, 2); -- Ungarn - Donau
