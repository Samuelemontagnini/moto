CREATE TABLE moto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    modello TEXT NOT NULL,
    cilindrata TEXT NOT NULL,
    cv TEXT NOT NULL
);

CREATE TABLE tracciati (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    lunghezza REAL NOT NULL,
    curvatura INTEGER NOT NULL,
    nazione TEXT NOT NULL
);

CREATE TABLE utenti (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);
ALTER TABLE moto ADD COLUMN image_path TEXT;
ALTER TABLE tracciati ADD COLUMN image_path TEXT;



INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path)
VALUES ('Monza Circuit', 5.793, 11, 'Italia', 'images/tracks/monza_circuit.jpg');


