-- ROMAIN
INSERT INTO poste (titre)
	VALUES 	('professionnel'), ('technicien'), ('ingénieur'), ('scientifique'), ('manutentionnaire'), ('soutient');

INSERT INTO departement (nom)
	VALUES 	('administration'), ('ventes et représentation'), ('achats'), ('mécanique'), ('électrique'), ('informatique'), ('recherche');

CALL ajout_employe('Fuoco-Binette', 'Romain', 'h', '123456789', 35.30, '2018-01-01', 'ingénieur', 'mécanique');
CALL ajout_employe('Leclerc', 'Mathis', 'h', '987654321', 15.00, '2020-02-01', 'manutentionnaire', 'informatique');
CALL ajout_employe('Bousquet', 'Noé', 'h', '123459876', 27.50, '2021-03-01', 'technicien', 'électrique');
CALL ajout_employe('Vincent', 'Juliette', 'f', '987651234', 150.75, '2023-04-01','scientifique', 'recherche');					   
CALL ajout_employe('Webster', 'Patrick', 'H', '654321789', 220.3, '2023-04-01', 'professionnel', 'informatique');

CALL ajout_signalisation('verticale', 100, 2);
CALL ajout_signalisation('horizontale', 100, 8);
CALL ajout_signalisation('verticale', 100, 9);
CALL ajout_signalisation('verticale', 75, 5);
CALL ajout_signalisation('verticale', 10, 11);
CALL ajout_signalisation('verticale', 50, 22);
CALL ajout_signalisation('verticale', 100, 21);
CALL ajout_signalisation('verticale', 88, 20);

CALL ajout_panneau('arret', 100, 10);
CALL ajout_panneau('limite_de_vitesse', 50, 10);
CALL ajout_panneau('arret', 100, 5);
CALL ajout_panneau('ceder', 100, 12);
CALL ajout_panneau('ralentir', 60, 4);

-- NOÉ

-- MATHIS

--JULIETTE
