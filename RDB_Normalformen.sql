BEGIN;

  -- CREATE cities
  CREATE TABLE cities (
    name TEXT NOT NULL,
    country_name TEXT NOT NULL,
    area REAL NOT NULL CHECK (area > 0),
    governors TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    PRIMARY KEY (name, country_id),
    FOREIGN KEY (country_id) REFERENCES countries(id)
  );

  -- CREATE countries
  CREATE TABLE countries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    area REAL NOT NULL CHECK (area > 0),
    languages TEXT NOT NULL,
    capital_name TEXT NOT NULL,
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
    country_capital_name TEXT NOT NULL,
    country_capital_area REAL NOT NULL,
    river_id INTEGER NOT NULL,
    PRIMARY KEY (country_id, river_id),
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (river_id) REFERENCES rivers(id)
  );

  -- CREATE relation between rivers and cities
  CREATE TABLE river_cities (
      river_name TEXT NOT NULL,
      city_name TEXT NOT NULL,
      PRIMARY KEY (river_name, city_name)
  );

  -- CREATE city_postcodes
  CREATE TABLE city_postcodes (
    city_name TEXT,
    postcode TEXT,
    district TEXT,
    PRIMARY KEY(city_name, postcode)
  );

  -- CREATE ports
  CREATE TABLE ports (
    name TEXT NOT NULL,
    river_id INTEGER NOT NULL,
    river_mouth_coordinates TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    country_name TEXT NOT NULL,
    PRIMARY KEY (name, country_id),
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (river_id) REFERENCES rivers(id)
  );

COMMIT;
