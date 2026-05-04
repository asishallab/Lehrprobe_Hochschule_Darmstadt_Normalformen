-- CREATE cities
CREATE TABLE cities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    area REAL NOT NULL CHECK (area > 0),
    is_capital BOOLEAN DEFAULT 0,
    governors TEXT NOT NULL,
    country_id INTEGER,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- CREATE countries
CREATE TABLE countries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    area REAL NOT NULL CHECK (area > 0),
    languages TEXT NOT NULL
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
