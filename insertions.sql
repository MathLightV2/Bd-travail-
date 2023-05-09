-- ROMAIN

-- NOÉ

--INSERT vehicule NOE
DELETE FROM vehicule;
INSERT INTO vehicule (marque, modele, date_aqui, immatriculation)
VALUES
('Ford', 'F-150', '2022-04-18', 'W68 BSA'),
('Chevrolet', 'Silverado', '2022-10-28', 'S52 AGC'),
('Toyota', 'Tacoma', '2023-02-05', '756 JWB');

--INSERT intersection NOE
DELETE FROM intersection;
INSERT INTO intersection (identifiant, latitude, longitude, type_pavage)
VALUES
('Pie/pr'    , 45.553676, -73.551715, 'asphalte'), 
('Pr/Viau'    , 45.562572, -73.545911, 'asphalte'), 
('Viau/Sh'    , 45.565361, -73.554467, 'asphalte'),
('Viau/Ro'    , 45.569242, -73.566290, 'asphalte'), 
('Pie/Ro'    , 45.560774, -73.573856, 'asphalte'),
('Pie/Dan'    , 45.559922, -73.571203, 'asphalte'), 
('Pie/Mas'    , 45.559037, -73.568459, 'asphalte'), 
('Pie/Lau'    , 45.558110, -73.565585, 'asphalte'),
('Pie/StJ'    , 45.557198, -73.562760, 'asphalte'),
('Pie/MtR'    , 45.555962, -73.558897, 'beton'), 
('Pie/Sh'    , 45.554599, -73.554580, 'asphalte');

-- MATHIS

--JULIETTE
