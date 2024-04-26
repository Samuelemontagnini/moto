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
ALTER TABLE moto ADD COLUMN velocita_massima INT;
ALTER TABLE moto ,
ADD COLUMN tracciato_id INTEGER,
ADD FOREIGN KEY (tracciato_id) REFERENCES tracciati(id);




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




