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
		

--JULIETTE
