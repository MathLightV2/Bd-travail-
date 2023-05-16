ALTER SEQUENCE seq_cali_id RESTART WITH 1;
ALTER SEQUENCE seq_inter_iden RESTART WITH 1;
ALTER SEQUENCE seq_insp_nom_fich RESTART WITH 1;
ALTER SEQUENCE seq_insp_nom_fich RESTART WITH 1;

-- insertion poste ROMAIN
INSERT INTO poste (titre)
	VALUES 	('professionnel'), ('technicien'), ('ingénieur'), ('scientifique'), ('manutentionnaire'), ('soutient');

-- insertion departement ROMAIN
INSERT INTO departement (nom)
	VALUES 	('administration'), ('ventes et représentation'), ('achats'), ('mécanique'), ('électrique'), ('informatique'), ('recherche');

-- insertion employe ROMAIN
CALL ajout_employe('Fuoco-Binette', 'Romain', 'h', '123456789', 35.30, '2018-01-01', 'ingénieur', 'mécanique');
CALL ajout_employe('Leclerc', 'Mathis', 'h', '987654321', 15.00, '2020-02-01', 'manutentionnaire', 'informatique');
CALL ajout_employe('Bousquet', 'Noé', 'h', '123459876', 27.50, '2021-03-01', 'technicien', 'électrique');
CALL ajout_employe('Vincent', 'Juliette', 'f', '987651234', 150.75, '2023-04-01','scientifique', 'recherche');					   
CALL ajout_employe('Webster', 'Patrick', 'H', '654321789', 220.3, '2023-04-01', 'professionnel', 'informatique');

-- insertion profileur MATHIS
INSERT INTO profileur (marque,no_serie,date_fab,date_aqui)
VALUES 	('Solinst','485321QWERFGTHYT','2008-09-14','2018-10-19'),
		('Dektak','484321QWFRFGTHBT','2014-08-22','2019-06-07'),
		('Normandin','486321QWEGFGTLYT','2007-05-17','2016-08-06');
CALL insert_rand_profileur();		
		
-- insertion calibration MATHIS
INSERT INTO calibration (id_calibration,date_debut,date_fin,employe,v1,v2,v3,profileur)
VALUES     (nextval('seq_cali_id'),'2020-11-24 10:10:53','2010-11-24 10:20:53',id_employe('Bousquet','Noé'),290.03,290.07,290.08,(SELECT id_profileur FROM profileur WHERE marque ='Solinst')),
        (nextval('seq_cali_id'),'2021-11-24 10:10:53','2021-11-24 10:20:53',id_employe('Bousquet','Noé'),301.03,302.07,304.08,(SELECT id_profileur FROM profileur WHERE marque ='Dektak' )),
        (nextval('seq_cali_id'),'2015-11-24 10:10:53','2015-11-24 10:20:53',id_employe('Webster','Patrick'),260.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Dektak')),
        (nextval('seq_cali_id'),'2016-11-24 10:10:53','2016-11-24 10:20:53',id_employe('Webster','Patrick'),265.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Dektak')),
        (nextval('seq_cali_id'),'2017-11-24 10:10:53','2017-11-24 10:21:53',id_employe('Webster','Patrick'),280.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
        (nextval('seq_cali_id'),'2018-11-24 10:10:53','2018-11-24 10:28:53',id_employe('Webster','Patrick'),270.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
        (nextval('seq_cali_id'),'2021-11-24 10:10:53','2021-11-24 10:28:53',id_employe('Fuoco-Binette','Romain'),234.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
        (nextval('seq_cali_id'),'2018-11-24 10:10:53','2018-11-24 10:28:53',id_employe('Fuoco-Binette','Romain'),245.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
        (nextval('seq_cali_id'),'2023-11-24 10:10:53','2023-11-24 10:21:53',id_employe('Fuoco-Binette','Romain'),150.05,150.05,150.05,(SELECT id_profileur FROM profileur WHERE marque ='Normandin'));
CALL insert_calibration();

-- insertion rue JULIETTE
INSERT INTO rue(nom)
VALUES
    ('Viau'),
    ('Sherbrooke'),
    ('Pie IX'),
    ('Rosemont'),
    ('Pierre de Coubertin');
	
-- insertion intersection NOE
INSERT INTO intersection (identifiant, latitude, longitude, type_pavage)
VALUES
(1234567, 45.553676, -73.551715, 'asphalte'), 
(4923424    , 45.562572, -73.545911, 'asphalte'), 
(1247542    , 45.565361, -73.554467, 'asphalte'),
(1243469    , 45.569242, -73.566290, 'asphalte'), 
(6586595   , 45.560774, -73.573856, 'asphalte'),
(6345767    , 45.559922, -73.571203, 'asphalte'), 
(7745673    , 45.559037, -73.568459, 'asphalte'), 
(9411111    , 45.558110, -73.565585, 'asphalte'),
(1346626    , 45.557198, -73.562760, 'asphalte'),
(5683835    , 45.555962, -73.558897, 'ciment'), 
(1342475    , 45.554599, -73.554580, 'asphalte');	
    
-- table troncon JULIETTE
INSERT INTO troncon
VALUES
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 2, 3, 717.69, 50, 2, 'asphalte'), --1
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pierre de Coubertin'), 1, 2, 1070, 50, 2,'asphalte'), --2
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 3, 4, 1000, 30, 2, 'asphalte'),--3
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Rosemont'), 4, 5, 1100, 50, 2, 'asphalte'),--4
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Sherbrooke'), 3, 11, 1200, 50, 2, 'asphalte'),--5
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 5, 6, 217.78, 50, 2, 'asphalte'),--6
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 6, 7, 237.51, 50, 2, 'asphalte'),--7
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 7, 8, 246.30, 50, 2, 'asphalte'),--8
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 8, 9, 236.38, 50, 2, 'ciment'), -- 9
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 9, 10, 321.75, 50, 2, 'ciment'), -- 10
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 10, 11, 361.68, 50, 2, 'asphalte'), -- 11
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 11, 1, 230.10, 50, 2, 'asphalte'), -- 12
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 3, 2, 717.69, 50, 2, 'asphalte'), -- 13
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pierre de Coubertin'), 2, 1, 1070, 50, 2, 'asphalte'), -- 14
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 4, 3, 1000, 30, 2, 'asphalte'), -- 15
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Rosemont'), 5, 4, 1100, 50, 2, 'asphalte'), -- 16
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Sherbrooke'), 11, 3, 1200, 50, 2, 'asphalte'), -- 17
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 6, 5, 217.78, 50, 2, 'asphalte'), -- 18
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 7, 6, 237.51, 50, 2, 'asphalte'), -- 19
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 8, 7, 245.74, 50, 2, 'asphalte'), -- 20
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 9, 8, 233.15, 50, 2, 'asphalte'), -- 21
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 10, 9, 323.29, 50, 2, 'asphalte'), -- 22
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 11, 10, 358.3, 50, 2, 'asphalte'), -- 23
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 1, 11, 233.90, 50, 2, 'asphalte'); -- 24
  
 -- insertion table type_pan MATHIS

INSERT INTO type_pan (nom)
VALUES 	('arret'),
		('ceder'),
		('ralentir'),
		('limite_de_vitesse');
		
		
-- insertion table type_dis_par MATHIS

INSERT INTO type_dis_par(nom)
VALUES 	('acces_fauteuil'),
		('signal_audio_pieton'),
		('radar');

-- insertion dis_particulier JULIETTE
 CALL ajout_dis_par(1, 100, 2);
 CALL ajout_dis_par(2, 0, 5);
 CALL ajout_dis_par(3, 50, 7);
 CALL insert_rand_dis_particulier();
		
 -- table couleur JULIETTE
INSERT INTO couleur(nom, hex)
VALUES
    ('rouge', 'FF0000'),
    ('jaune', 'FFFF00'),
    ('vert', '00FF00'),
    ('orange', 'FFBF00'),
    ('blanc', 'FFFFFF');
	
-- insertion signalisation ROMAIN	
CALL ajout_signalisation('verticale', 100, 2);
CALL ajout_signalisation('horizontale', 100, 8);
CALL ajout_signalisation('verticale', 100, 9);
CALL ajout_signalisation('verticale', 75, 5);
CALL ajout_signalisation('verticale', 10, 11);
CALL ajout_signalisation('verticale', 50, 22);
CALL ajout_signalisation('verticale', 100, 21);
CALL ajout_signalisation('verticale', 88, 20);
CALL insert_rand_signalisation();

-- insertion panneau ROMAIN
CALL ajout_panneau('arret', 100, 10);
CALL ajout_panneau('limite_de_vitesse', 50, 10);
CALL ajout_panneau('arret', 100, 5);
CALL ajout_panneau('ceder', 100, 12);
CALL ajout_panneau('ralentir', 60, 4);
CALL insert_rand_panneau();

INSERT INTO forme(nom)
VALUES 	('ronde'),
		('carree'),
		('losange'),
		('fleche'),
		('humains'),
		('main'),
		('velo'),
		('barre_verticale'),
		('barre horizontale');
		
-- insertion lumiere JULIETTE	
CALL ajout_lumiere(1, 1, 'solide', 1);
CALL ajout_lumiere(1, 2, 'solide', 1);
CALL ajout_lumiere(1, 3, 'solide', 1);
CALL ajout_lumiere(2, 1, 'contrôlé', 2);
CALL ajout_lumiere(2, 2, 'contrôlé', 2);
CALL ajout_lumiere(3, 3, 'intelligente', 2);
CALL ajout_lumiere(4, 1, 'solide', 3);
CALL ajout_lumiere(4, 2, 'solide', 3);
CALL ajout_lumiere(4, 3, 'solide', 3);
CALL ajout_lumiere(6, 4, 'clignotant', 4);
CALL ajout_lumiere(5, 5, 'contrôlé', 5);
CALL ajout_lumiere(7, 5, 'solide', 6);
CALL ajout_lumiere(8, 3, 'solide', 7);
CALL ajout_lumiere(9, 1, 'solide', 8);
CALL insert_rand_lumiere();

--INSERT vehicule NOE
INSERT INTO vehicule (marque, modele, date_aqui, immatriculation)
VALUES
('Ford', 'F-150', '2022-04-18', 'W68BSA'),
('Chevrolet', 'Silverado', '2022-10-28', 'S52AGC'),
('Toyota', 'Tacoma', '2023-02-05', '756JWB');

-- insertion inspection NOE
CALL insert_loop();
-- insertion inspection_troncon NOE
CALL insert_rand_inspection_troncon();
