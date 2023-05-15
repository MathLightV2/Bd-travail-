DROP VIEW IF EXISTS rapport_inspection, inspection_fees, nbr_ins_emp;

DROP TRIGGER IF EXISTS insert_nom_fichier_donnees on inspection;

DROP FUNCTION IF EXISTS id_type_pan, id_dis_pan, id_poste, id_departement, id_employe, salaire_total_emp, 
						insert_loop_calibration, select_rand_id, cout_vehicule, generate_nom_fichier_donnees;
						
DROP PROCEDURE IF EXISTS ajout_employe, ajout_signalisation, ajout_panneau, ajout_troncon, insert_calibration
						,insert_rand_panneau, insert_rand_signalisation, ajout_lumiere, ajout_dis_par
						,insert_inspection, insert_rand_dis_particulier, insert_rand_lumiere, insert_loop;

ALTER TABLE IF EXISTS calibration DROP CONSTRAINT IF EXISTS fk_cal_emp;
ALTER TABLE IF EXISTS calibration DROP CONSTRAINT IF EXISTS fk_cal_pro;
ALTER TABLE IF EXISTS inspection DROP CONSTRAINT IF EXISTS fk_insp_con;
ALTER TABLE IF EXISTS inspection DROP CONSTRAINT IF EXISTS fk_insp_veh;
ALTER TABLE IF EXISTS inspection DROP CONSTRAINT IF EXISTS fk_insp_pro;
ALTER TABLE IF EXISTS inspection DROP CONSTRAINT IF EXISTS fk_insp_ope;
ALTER TABLE IF EXISTS inspection_troncon DROP CONSTRAINT IF EXISTS fk_insp_tron_insp;
ALTER TABLE IF EXISTS inspection_troncon DROP CONSTRAINT IF EXISTS fk_insp_tron_tron;
ALTER TABLE IF EXISTS employe DROP CONSTRAINT IF EXISTS fk_emp_post;
ALTER TABLE IF EXISTS employe DROP CONSTRAINT IF EXISTS fk_emp_dep;
ALTER TABLE IF EXISTS troncon DROP CONSTRAINT IF EXISTS fk_tron_deb;
ALTER TABLE IF EXISTS troncon DROP CONSTRAINT IF EXISTS fk_tron_fin;
ALTER TABLE IF EXISTS panneau DROP CONSTRAINT IF EXISTS fk_pan_tron;
ALTER TABLE IF EXISTS panneau DROP CONSTRAINT IF EXISTS fk_pan_type;
ALTER TABLE IF EXISTS dis_particulier DROP CONSTRAINT IF EXISTS fk_dis_par_tron;
ALTER TABLE IF EXISTS dis_particulier DROP CONSTRAINT IF EXISTS fk_dis_par_type;
ALTER TABLE IF EXISTS signalisation DROP CONSTRAINT IF EXISTS fk_signal_tron;
ALTER TABLE IF EXISTS lumiere DROP CONSTRAINT IF EXISTS fk_lum_signal;
ALTER TABLE IF EXISTS lumiere DROP CONSTRAINT IF EXISTS fk_lum_forme;
ALTER TABLE IF EXISTS lumiere DROP CONSTRAINT IF EXISTS fk_lum_couleur;

DROP SEQUENCE IF EXISTS seq_cali_id;
DROP SEQUENCE IF EXISTS seq_insp_nom_fich;
DROP SEQUENCE IF EXISTS seq_inter_iden;
DROP SEQUENCE IF EXISTS seq_tron_id;

DROP TABLE IF EXISTS troncon;
DROP TABLE IF EXISTS dis_particulier;
DROP TABLE IF EXISTS lumiere;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS rue;

DROP TABLE IF EXISTS calibration;
DROP TABLE IF EXISTS profileur;
DROP TABLE IF EXISTS type_pan;
DROP TABLE IF EXISTS type_dis_par;
DROP TABLE IF EXISTS forme;

DROP TABLE IF EXISTS employe;
DROP TABLE IF EXISTS poste;
DROP TABLE IF EXISTS departement;
DROP TABLE IF EXISTS panneau;
DROP TABLE IF EXISTS signalisation;

DROP TABLE IF EXISTS inspection;
DROP TABLE IF EXISTS vehicule;
DROP TABLE IF EXISTS intersection;
DROP TABLE IF EXISTS inspection_troncon;

DROP TYPE IF EXISTS GENRE;
DROP TYPE IF EXISTS ORIENTATION;
DROP TYPE IF EXISTS PAVAGE;
DROP TYPE IF EXISTS MODE;

CREATE TYPE GENRE AS ENUM ('H','F','X');
CREATE TYPE ORIENTATION AS ENUM ('horizontale', 'verticale', 'autre');
CREATE TYPE PAVAGE AS ENUM ('asphalte', 'ciment', 'pave', 'pavé pierre', 'non pavé', 'indéterminé');
CREATE TYPE MODE AS ENUM ('solide', 'clignotant', 'contrôlé', 'intelligente');

-- TABLE rue JULIETTE
CREATE TABLE rue(
	id_rue					SERIAL
	,nom					VARCHAR(32)			NOT NULL
	
	,CONSTRAINT pk_rue_id PRIMARY KEY (id_rue)
);
-- TABLE troncon JULIETTE	
CREATE TABLE troncon(
	id_troncon				SERIAL,
	rue						VARCHAR(32)		NOT NULL,
	debut_intersection		INTEGER,
	fin_intersection		INTEGER,
	longueur				NUMERIC(6,2)	NOT NULL,
	limite					INT				NOT NULL,
	nb_voie					INT				NOT NULL DEFAULT 1,
	pavage					PAVAGE			NOT NULL,
	
	CONSTRAINT pk_troncon PRIMARY KEY(id_troncon),
	CONSTRAINT cc_troncon_longueur CHECK(longueur >= 0.0 AND longueur <= 100000.0),
	CONSTRAINT cc_troncon_limite CHECK(limite >= 25 AND limite <= 120),
	CONSTRAINT cc_troncon_nb_voie CHECK(nb_voie >= 1 AND nb_voie <= 8)
);

-- TABLE dis_particulier JULIETTE
CREATE TABLE dis_particulier(
	id_dis_par			SERIAL,
	type 				INT,
	position			DECIMAL(5,2)		NOT NULL,
	troncon				INT,
	
	CONSTRAINT pk_dis_particulier PRIMARY KEY(id_dis_par),
	CONSTRAINT cc_dis_particulier_position CHECK(position >= 0.00 AND position <= 100.00)
);

-- TABLE lumiere JULIETTE
CREATE TABLE lumiere(
	id_lumiere 			SERIAL,
	forme				INT,
	couleur				INT,
	mode				MODE		NOT NULL,
	signalisation		INT,
	
	CONSTRAINT pk_lumiere PRIMARY KEY(id_lumiere)
);

-- TABLE couleur JULIETTE
CREATE TABLE couleur(
	id_couleur		SERIAL,
	nom				VARCHAR(32)	NOT NULL,
	hex				VARCHAR(6)	NOT NULL,
	
	CONSTRAINT pk_couleur PRIMARY KEY(id_couleur),
	CONSTRAINT cc_couleur_hex CHECK(hex ~* '^[0-9A-F]{6}$')
);

-- TABLE calibration MATHIS
CREATE TABLE calibration(
	id_calibration		INTEGER,
	date_debut			TIMESTAMP		NOT NULL,
	date_fin			TIMESTAMP		NOT NULL,
	employe				INTEGER,
	v1					DECIMAL(8,4)	NOT NULL,
	v2					DECIMAL(8,4)	NOT NULL,
	v3					DECIMAL(8,4)	NOT NULL,
	profileur			INTEGER,
	
	CONSTRAINT pk_calibration PRIMARY KEY (id_calibration),
	
	CONSTRAINT cc_cali_v1	CHECK(v1 BETWEEN -1000 AND 1000),
	CONSTRAINT cc_cali_v2 	CHECK(v2 BETWEEN -1000 AND 1000),
	CONSTRAINT cc_cali_v3	CHECK(v3 BETWEEN -1000 AND 1000)
);


-- TABLE profileur MATHIS 
CREATE TABLE profileur(
	
	id_profileur	SERIAL,
	marque			VARCHAR(32)		NOT NULL,
	no_serie		VARCHAR(16)		NOT NULL,
	date_fab		DATE,
	date_aqui		DATE,
	
	CONSTRAINT pk_profileur PRIMARY KEY (id_profileur)
);

-- TABLE type_pan MATHIS 
CREATE TABLE type_pan(
	id_type_pan		SERIAL,
	nom				VARCHAR(20),
	
	CONSTRAINT pk_type_pan PRIMARY KEY (id_type_pan)
);

--TABLE type_dis_par MATHIS
CREATE TABLE type_dis_par(
	id_type_dis_par		SERIAL,
	nom					VARCHAR(20),
	
	CONSTRAINT pk_type_dis_par PRIMARY KEY (id_type_dis_par)
);

-- TABLE forme MATHIS 
CREATE TABLE forme (
	id_forme 			SERIAL,
	nom					VARCHAR(20),
	
	CONSTRAINT pk_forme  PRIMARY KEY (id_forme)
);

-- TABLE employe ROMAIN
CREATE TABLE employe(
	id_employe				SERIAL				
	,nom					VARCHAR(32)			NOT NULL
	,prenom					VARCHAR(32)			NOT NULL
	,genre					GENRE				NOT NULL
	,nas					CHAR(9)				NOT NULL
	,salaire				NUMERIC(5,2)		DEFAULT 27.50 NOT NULL
	,date_embauche			DATE				
	,poste					INTEGER				NOT NULL	--fk
	,departement			INTEGER				NOT NULL	--fk
	
	,CONSTRAINT pk_emp_id PRIMARY KEY (id_employe)
	
	,CONSTRAINT cc_date_emb CHECK (date_embauche BETWEEN '2018-01-01' AND CURRENT_DATE)
);


-- TABLE poste ROMAIN
CREATE TABLE poste(
	id_poste				SERIAL
	,titre					VARCHAR(32)			NOT NULL
	
	,CONSTRAINT pk_pos_id PRIMARY KEY (id_poste)

);

-- TABLE departement ROMAIN
CREATE TABLE departement(
	id_departement			SERIAL
	,nom					VARCHAR(32)			NOT NULL
	
	,CONSTRAINT pk_dep_id PRIMARY KEY (id_departement)
);

-- TABLE panneau ROMAIN
CREATE TABLE panneau(
	id_panneau				SERIAL
	,type					INTEGER				NOT NULL	--fk
	,position				INTEGER				NOT NULL	
	,troncon				INTEGER				NOT NULL	--fk
	
	,CONSTRAINT pk_pan_id PRIMARY KEY (id_panneau)
	
	,CONSTRAINT cc_pan_pos CHECK (position BETWEEN 0 AND 100)
);

-- TABLE signalisation ROMAIN
CREATE TABLE signalisation(
	id_signalisation		SERIAL
	,orientation			ORIENTATION			NOT NULL	
	,position				INTEGER				NOT NULL	
	,troncon				INTEGER				NOT NULL	--fk
	
	,CONSTRAINT pk_signal_id PRIMARY KEY (id_signalisation)
	
	,CONSTRAINT cc_sigal_pos CHECK (position BETWEEN 0 AND 100)
);


-- TABLE vehicule NOE
CREATE TABLE vehicule (
    id_vehicule         SERIAL,
    marque              VARCHAR(32) NOT NULL,
    modele              VARCHAR(32) NOT NULL,
    date_aqui           DATE,
    immatriculation     CHAR(6)     NOT NULL,
	
    CONSTRAINT pk_veh_id PRIMARY KEY (id_vehicule),
    CONSTRAINT cc_imma CHECK (LENGTH(immatriculation) = 6)
);

-- TABLE intersection NOE
CREATE TABLE intersection (
    id_intersection             SERIAL,    
    identifiant                 NUMERIC(7,0)   	NOT NULL,
    latitude                    NUMERIC(10, 6) 	NOT NULL,
    longitude                   NUMERIC(10, 6) 	NOT NULL,
    type_pavage                 PAVAGE   		NOT NULL,
    
	CONSTRAINT pk_inter_id PRIMARY KEY (id_intersection),
	
	CONSTRAINT cc_inter_iden CHECK (identifiant BETWEEN 1000000 AND 9999999)
);

-- TABLE inspection NOE
CREATE TABLE inspection (
    id_inspection               SERIAL,
    date_debut                  TIMESTAMP   	NOT NULL,
    date_fin                    TIMESTAMP   	NOT NULL,
    conducteur                  INTEGER     	NOT NULL, --fk
    vehicule                    INTEGER     	NOT NULL, --fk
    km_debut_inspect            INTEGER     	NOT NULL,
    km_fin_inspect              INTEGER     	NOT NULL,
    profileur                   INTEGER     	NOT NULL, --fk
    operateur                   INTEGER     	NOT NULL, --fk
    chemin_fichier_donnees      VARCHAR(1024) 	NOT NULL,
    nom_fichier_donnees         VARCHAR(30)   	NOT NULL,
	
    CONSTRAINT pk_insp PRIMARY KEY (id_inspection),
    CONSTRAINT cc_km_deb CHECK (km_debut_inspect >= 1 AND km_debut_inspect <= 500000),
    CONSTRAINT cc_km_fin CHECK (km_fin_inspect >= 1 AND km_fin_inspect <= 500000)
);

-- TABLE inspection_troncon NOE
CREATE TABLE inspection_troncon (
    id_inspect_tron     SERIAL,
    inspection          INTEGER NOT NULL,
    troncon             INTEGER NOT NULL,
	
    CONSTRAINT pk_insp_tron PRIMARY KEY (id_inspect_tron)
);

--FOREIGN KEY calibration
ALTER TABLE calibration ADD CONSTRAINT fk_cal_emp FOREIGN KEY (employe) REFERENCES employe(id_employe);
ALTER TABLE calibration ADD CONSTRAINT fk_cal_pro FOREIGN KEY (profileur) REFERENCES profileur(id_profileur);

--FOREIGN KEY inspection
ALTER TABLE inspection ADD CONSTRAINT fk_insp_con FOREIGN KEY (conducteur) REFERENCES employe(id_employe);
ALTER TABLE inspection ADD CONSTRAINT fk_insp_veh FOREIGN KEY (vehicule) REFERENCES vehicule(id_vehicule);
ALTER TABLE inspection ADD CONSTRAINT fk_insp_pro FOREIGN KEY (profileur) REFERENCES profileur(id_profileur);
ALTER TABLE inspection ADD CONSTRAINT fk_insp_ope FOREIGN KEY (operateur) REFERENCES employe(id_employe);

--FOREIGN KEY inspection_troncon
ALTER TABLE inspection_troncon ADD CONSTRAINT fk_insp_tron_insp FOREIGN KEY (inspection) REFERENCES inspection(id_inspection);
ALTER TABLE inspection_troncon ADD CONSTRAINT fk_insp_tron_tron FOREIGN KEY (troncon) REFERENCES troncon(id_troncon);

--FOREIGN KEY employe
ALTER TABLE employe ADD CONSTRAINT fk_emp_post FOREIGN KEY (poste) REFERENCES poste(id_poste);
ALTER TABLE employe ADD CONSTRAINT fk_emp_dep FOREIGN KEY (departement) REFERENCES departement(id_departement);

--FOREIGN KEY troncon
ALTER TABLE troncon ADD CONSTRAINT fk_tron_deb FOREIGN KEY (debut_intersection) REFERENCES intersection(id_intersection);
ALTER TABLE troncon ADD CONSTRAINT fk_tron_fin FOREIGN KEY (fin_intersection) REFERENCES intersection(id_intersection);

--FOREIGN KEY panneau
ALTER TABLE panneau ADD CONSTRAINT fk_pan_tron FOREIGN KEY (troncon) REFERENCES troncon(id_troncon);
ALTER TABLE panneau ADD CONSTRAINT fk_pan_type FOREIGN KEY (type) REFERENCES type_pan(id_type_pan);

--FOREIGN KEY dis_particulier
ALTER TABLE dis_particulier ADD CONSTRAINT fk_dis_par_tron FOREIGN KEY (troncon) REFERENCES troncon(id_troncon);
ALTER TABLE dis_particulier ADD CONSTRAINT fk_dis_par_type FOREIGN KEY (type) REFERENCES type_dis_par(id_type_dis_par);

--FOREIGN KEY signalisation
ALTER TABLE signalisation ADD CONSTRAINT fk_signal_tron FOREIGN KEY (troncon) REFERENCES troncon(id_troncon);

--FOREIGN KEY lumiere
ALTER TABLE lumiere ADD CONSTRAINT fk_lum_signal FOREIGN KEY (signalisation) REFERENCES signalisation(id_signalisation);
ALTER TABLE lumiere ADD CONSTRAINT fk_lum_forme FOREIGN KEY (forme) REFERENCES forme(id_forme);
ALTER TABLE lumiere ADD CONSTRAINT fk_lum_couleur FOREIGN KEY (couleur) REFERENCES couleur(id_couleur);

-- séquence MATHIS :
-- calibration, id_calibration
CREATE SEQUENCE seq_cali_id START WITH 1 INCREMENT BY 1;

-- séquence ROMAIN :
-- intersection, identifiant
CREATE SEQUENCE seq_inter_iden START WITH 1000000 INCREMENT BY 1;

-- séquence JULIETTE :
-- troncon, identifiant
CREATE SEQUENCE seq_tron_id START WITH 1 INCREMENT BY 1;

-- séquenece NOE :
-- Inspection, nom_fichier_donnees
CREATE SEQUENCE seq_insp_nom_fich START WITH 20 INCREMENT BY 1;

-- vue ROMAIN : 
-- rapport d'inspection
CREATE VIEW rapport_inspection AS
	SELECT 	ins.date_debut "Date et heure de début",  ins.date_fin "Date et heure de fin"
			,con.nom || ', ' || con.prenom "Nom du conducteur", con.salaire "Salaire horaire du conducteur"
			,v.marque || ' ' || v.modele || ', ' || v.immatriculation "Informations du véhicule utilisé"
			,ins.km_debut_inspect "Kilomètrage au début de l''inspection", ins.km_fin_inspect "Kilomètrage fin de l''inspection"
			,ins.km_fin_inspect - ins.km_debut_inspect "Nb de kilometre parcouru"
			,ope.nom || ', ' || ope.prenom "Nom de l''opérateur", ope.salaire "Salaire horaire de l''opérateur"
			,pro.no_serie "No. de série du profileur utilisé"
	FROM inspection AS ins
	INNER JOIN employe AS con ON con.id_employe = ins.conducteur
	INNER JOIN employe AS ope ON ope.id_employe = ins.operateur
	INNER JOIN vehicule AS v ON v.id_vehicule = ins.vehicule
	INNER JOIN profileur AS pro ON pro.id_profileur = ins.profileur
	ORDER BY ins.date_debut;

	--SELECT * FROM rapport_inspection;
-- index ROMAIN
CREATE INDEX idx_calibration ON calibration(date_debut);

