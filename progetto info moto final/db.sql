-- Creazione della tabella moto con la colonna aggiuntiva per l'immagine e la velocità massima
CREATE TABLE moto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    modello TEXT NOT NULL,
    cilindrata TEXT NOT NULL,
    cv TEXT NOT NULL,
    image_path TEXT,
    velocita_massima INT
);

-- Creazione della tabella tracciati con la colonna aggiuntiva per l'immagine
CREATE TABLE tracciati (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    lunghezza REAL NOT NULL,
    curvatura INTEGER NOT NULL,
    nazione TEXT NOT NULL,
    image_path TEXT
);

-- Creazione della tabella utenti
CREATE TABLE utenti (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    data_di_registrazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creazione della tabella commenti
CREATE TABLE commenti (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    utente_id INTEGER NOT NULL,
    moto_id INTEGER,
    tracciato_id INTEGER,
    testo TEXT NOT NULL,
    data_ora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_id) REFERENCES utenti(id),
    FOREIGN KEY (moto_id) REFERENCES moto(id),
    FOREIGN KEY (tracciato_id) REFERENCES tracciati(id)
);





INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Monza Circuit', 5.793, 11, 'Italia', 'images/tracks/monza_circuit.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Stelvio Pass', 24.3, 48, 'Italia', 'images/tracks/passo_dello_stelvio.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Laguna Seca', 3.602, 11, 'USA', 'images/tracks/laguna_seca.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Imola Circuit', 4.909, 17, 'Italia', 'images/tracks/imola_circuit.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Passo dello Stelvio', 20.7, 60, 'Italia', 'images/tracks/passo_dello_stelvio.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Nürburgring Nordschleife', 20.832, 154, 'Germania', 'images/tracks/nurburgring_nordschleife.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Passo di Gavia', 25.6, 30, 'Italia', 'images/tracks/passo_di_gavia.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Circuit de Spa-Francorchamps', 7.004, 19, 'Belgio', 'images/tracks/spa_francorchamps.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Passo del Mortirolo', 12.4, 33, 'Italia', 'images/tracks/passo_del_mortirolo.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Silverstone Circuit', 5.891, 18, 'Regno Unito', 'images/tracks/silverstone_circuit.jpg');
INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES ('Passo del Bernina', 13, 13, 'Svizzera', 'images/tracks/passo_del_bernina.jpg');


INSERT INTO moto (modello,cilindrata,cv, velocita_massima,image_path) VALUES ('ktm','450','35', '190','images/motos/450.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('KTM SX', '250', '45', '170', 'images/motos/ktm_sx.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Ducati Panigale V4', '1103', '214', '300', 'images/motos/ducati_panigale_v4.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Yamaha YZF-R1', '998', '200', '285', 'images/motos/yamaha_yzf_r1.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Honda CBR600RR', '599', '120', '250', 'images/motos/honda_cbr600rr.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Suzuki GSX-R1000', '999', '199', '290', 'images/motos/suzuki_gsx_r1000.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('BMW S1000RR', '999', '207', '299', 'images/motos/bmw_s1000rr.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Aprilia RSV4', '1099', '217', '305', 'images/motos/aprilia_rsv4.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('MV Agusta F4', '998', '205', '292', 'images/motos/mv_agusta_f4.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Triumph Daytona', '765', '128', '260', 'images/motos/triumph_daytona.jpg');
INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES ('Kawasaki Ninja ZX-10R', '998', '203', '300', 'images/motos/kawasaki_ninja_zx_10r.jpg');

INSERT INTO commenti (utente_id, moto_id, testo) VALUES 
(1, 1, 'Incredibilmente agile e veloce, un piacere da guidare.'),
(1, 1, 'Ottimo maneggevolezza ma il comfort di guida potrebbe essere migliorato.');

-- Commenti per la moto con id = 2
INSERT INTO commenti (utente_id, moto_id, testo) VALUES 
(1, 2, 'Perfetta per chi ama le velocità elevate e le prestazioni sportive.'),
(1, 2, 'Il design è eccezionale, ma la manutenzione può essere costosa.');

-- Commenti per la moto con id = 3
INSERT INTO commenti (utente_id, moto_id, testo) VALUES 
(1, 3, 'Un vero mostro di potenza, ideale per gli amanti delle prestazioni pure.'),
(1, 3, 'La Ducati Panigale V4 non delude mai, dal sound alla velocità.');

INSERT INTO commenti (utente_id, tracciato_id, testo) VALUES 
(1, 1, 'Un classico tracciato pieno di storia, sempre un piacere correrci.'),
(1, 1, 'Perfetto per testare le capacità tecniche in curva.');

-- Commenti per il tracciato con id = 2
INSERT INTO commenti (utente_id, tracciato_id, testo) VALUES 
(1, 2, 'Uno dei passaggi montani più emozionanti e sfidanti d\'Europa.'),
(1, 2, 'Ottimo per allenarsi per gare di resistenza, ma attenzione alle condizioni meteorologiche variabili.');


INSERT INTO commenti (utente_id, tracciato_id, testo) VALUES 
(1, 3, 'Laguna Seca è famoso per il suo "Corkscrew", unico e adrenalico.'),
(1, 3, 'Tracciato corto ma intenso, con eccellenti opportunità di sorpasso.');


