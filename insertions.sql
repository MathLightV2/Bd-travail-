-- ROMAIN

-- NOÉ

-- MATHIS

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
		

-- insertion forme MATHIS 

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
		
		-- insertion profileur MATHIS

INSERT INTO profileur (marque,no_serie,date_fab,date_aqui)
VALUES 	('Solinst','485321','2008-09-14','2018-10-19'),
		('Dektak','972459','2014-08-22','2019-06-07'),
		('Normandin','442785','2007-05-17','2016-08-06');
		
-- insertion calibration MATHIS
INSERT INTO calibration (id_calibration,date_debut,date_fin,employe,v1,v2,v3,profileur)
VALUES 	(nextval('seq_cali_id'),'2020-11-24 10:10:53','2010-11-24 10:10:53','TODO',290.03,290.07,290.08,(SELECT id_profileur FROM profileur WHERE marque ='Solinst')),
		(nextval('seq_cali_id'),'2021-11-24 10:10:53','2021-11-24 10:10:53','TODO',301.03,302.07,304.08,(SELECT id_profileur FROM profileur WHERE marque ='Dektak' )),
		(nextval('seq_cali_id'),'2015-11-24 10:10:53','2015-11-24 10:10:53','TODO',260.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Dektak')),
		(nextval('seq_cali_id'),'2016-11-24 10:10:53','2016-11-24 10:10:53','TODO',265.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Dektak')),
		(nextval('seq_cali_id'),'2017-11-24 10:10:53','2017-11-24 10:11:53','TODO',280.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
		(nextval('seq_cali_id'),'2018-11-24 10:10:53','2018-11-24 10:08:53','TODO',270.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
		(nextval('seq_cali_id'),'2021-11-24 10:10:53','2021-11-24 10:08:53','TODO',234.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
		(nextval('seq_cali_id'),'2018-11-24 10:10:53','2018-11-24 10:08:53','TODO',245.03,250.07,250.08,(SELECT id_profileur FROM profileur WHERE marque ='Normandin')),
		(nextval('seq_cali_id'),'2023-11-24 10:10:53','2023-11-24 10:11:53','TODO',150.05,150.05,150.05,(SELECT id_profileur FROM profileur WHERE marque ='Normandin'));
		

-- insertion rue JULIETTE
INSERT INTO rue(nom)
VALUES
    ('Viau'),
    ('Sherbrooke'),
    ('Pie IX'),
    ('Rosemont'),
    ('Pierre de Coubertin');
    
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
    
 -- table couleur JULIETTE
INSERT INTO couleur(nom, hex)
VALUES
    ('rouge', 'FF0000'),
    ('jaune', 'FFFF00'),
    ('vert', '00FF00'),
    ('orange', 'FFBF00'),
    ('blanc', 'FFFFFF');

-- insertion dis_particulier JULIETTE
INSERT INTO dis_particulier(type, position, troncon)
VALUES
    (1, 100, 2),
    (2, 0, 5),
    (3, 50, 7);

-- insertion lumiere JULIETTE
INSERT INTO lumiere (forme, couleur, mode, signalisation)
VALUES
    (1, 1, 'solide', 1),
    (1, 2, 'solide', 1),
    (1, 3, 'solide', 1),
    (2, 1, 'controle', 2),
    (2, 2, 'controle', 2),
    (3, 3, 'intelligente', 2),
    (4, 1, 'solide', 3),
    (4, 2, 'solide', 3),
    (4, 3, 'solide', 3),
    (6, 4, 'clignotant', 4),
    (5, 5, 'controle', 5),
    (7, 5, 'solide', 6),
    (8, 3, 'solide', 7),
    (9, 1, 'solide', 8);
