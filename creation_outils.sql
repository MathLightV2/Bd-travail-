-- INDEX mathis
DROP INDEX IF EXISTS idx_cali_emp ;
CREATE INDEX idx_cali_emp
ON calibration (employe);


CREATE FUNCTION genere_marque_random()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
	DECLARE
		marque_rand TEXT;
	BEGIN
		marque_rand := substr(MD5(random()::text), 1, 5);
		RETURN marque_rand; 

	END;
$$;

-- Fonction créer par MATHIS transformer en trigger par ROMAIN
CREATE OR REPLACE FUNCTION genere_num_serie_random()
RETURNS TRIGGER
AS $$
	DECLARE
		num_rand TEXT;
	BEGIN
		num_rand := substr(MD5(random()::text), 1, 16);
		NEW.no_serie = num_rand;
		RETURN NEW; 
	END;
$$ LANGUAGE plpgsql;



CREATE PROCEDURE insert_rand_profileur()
LANGUAGE plpgsql
AS $$
-- variable 
	DECLARE 
	_marque			profileur.marque%TYPE;
	_no_serie		profileur.marque%TYPE;		
	_date_fab		profileur.date_fab%TYPE;
	_date_aqui		profileur.date_aqui%TYPE;

	BEGIN
		
		-- ajoute les row
		FOR i IN 1..10 LOOP
			SELECT genere_marque_random() INTO _marque;
			SELECT date_trunc('second', NOW() - (RANDOM() * interval '30 days')) INTO _date_fab;
			SELECT date_trunc('second', _date_fab + (RANDOM() * interval '10 days')) INTO _date_aqui;
		
			INSERT INTO profileur (marque,no_serie,date_fab,date_aqui)
				VALUES (_marque,_no_serie,_date_fab,_date_aqui);

		END LOOP;
	END;
$$;


-- PROCEDURE mathis
CREATE PROCEDURE insert_calibration()
LANGUAGE plpgsql
AS $$

 -- varaible
 	DECLARE 
 	id_calibration calibration.id_calibration%TYPE;
	date_debut calibration.date_debut%TYPE;
	date_fin calibration.date_fin%TYPE;
	employe calibration.employe%TYPE;
	v1 calibration.v1%TYPE;
	v2 calibration.v2%TYPE;
	v3 calibration.v3%TYPE;
	profileur calibration.profileur%TYPE;
	
	BEGIN 
		FOR i IN 1..50 LOOP
			SELECT nextval('seq_cali_id') INTO id_calibration;
			SELECT date_trunc('second', NOW() - (RANDOM() * interval '30 days')) INTO date_debut;
			SELECT date_trunc('second', date_debut + (RANDOM() * interval '10 minutes')) INTO date_fin;
			SELECT select_rand_id('id_employe','employe') INTO employe;
			SELECT FLOOR(RANDOM()*(500 - 1)) + 1 INTO v1;
			SELECT FLOOR(RANDOM()*(500 - 1)) + 1 INTO v2;
			SELECT FLOOR(RANDOM()*(500 - 1)) + 1 INTO v3;
			SELECT select_rand_id ('id_profileur','profileur') INTO profileur;

			-- ajoute les row			  
				INSERT INTO calibration (
					id_calibration,
					date_debut,
					date_fin,
					employe,
					v1,
					v2,
					v3,
					profileur
					) VALUES (

					id_calibration,
					date_debut,
					date_fin,
					employe,
					v1,
					v2,
					v3,
					profileur
					);
		END LOOP;
	END;

$$;
				  

-- ========================= ROMAIN Fonctions ============================================================================
CREATE FUNCTION id_type_pan(
	_nom type_pan.nom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_type_pan FROM type_pan WHERE _nom = nom
	$$;
	
CREATE FUNCTION id_dis_pan(
	_nom type_dis_par.nom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_type_dis_par FROM type_dis_par WHERE _nom = nom
	$$;
	
CREATE FUNCTION id_poste(
	_titre poste.titre%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_poste FROM poste WHERE _titre = titre
	$$;
	
CREATE FUNCTION id_departement(
	_nom departement.nom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_departement FROM departement WHERE _nom = nom
	$$;

CREATE FUNCTION id_employe(
	_nom employe.nom%TYPE
	,_prenom employe.prenom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_employe FROM employe WHERE (_nom = nom) AND (_prenom = prenom)
	$$;
	
CREATE FUNCTION transform_heures(
	_debut	 	TIMESTAMP
	,_fin		TIMESTAMP)
	RETURNS NUMERIC(4,2)
	LANGUAGE SQL
	AS $$
		SELECT 	((EXTRACT(hour FROM (_fin - _debut))*60 + EXTRACT(minutes FROM (_fin - _debut)))/60)::NUMERIC(4,2)
	$$;

--version révisé par romain utilisation d'un query_str car dans la version précédente le compilateur considérait
--table_nom comme le nom de table et non pas le contenu de la varible 
CREATE FUNCTION select_rand_id(
    id_nom      VARCHAR(32), 
    table_nom   VARCHAR(32)) 
RETURNS int
LANGUAGE plpgsql
AS $$
    DECLARE 
        Rand_id integer;
        query_str text;
    BEGIN
        query_str := 'SELECT ' || id_nom || ' FROM ' || table_nom || ' ORDER BY RANDOM () LIMIT 1';
        EXECUTE query_str INTO Rand_id;
        RETURN Rand_id;
    END;
$$;

CREATE TRIGGER insert_no_serie
    BEFORE INSERT ON profileur
    FOR EACH ROW
    EXECUTE FUNCTION genere_num_serie_random();
-- ========================================================================================================================


-- ========================= ROMAIN PROCÉDURES ============================================================================
CREATE PROCEDURE ajout_employe(
	nom				employe.nom%TYPE
	,prenom			employe.prenom%TYPE
	,genre			CHAR(1)
	,nas			employe.nas%TYPE
	,salaire		employe.salaire%TYPE
	,date			employe.date_embauche%TYPE
	,poste			poste.titre%TYPE
	,departement	departement.nom%TYPE)
	LANGUAGE SQL
	AS $$			
	INSERT INTO employe(nom, prenom, genre, nas, salaire, date_embauche, poste, departement)
			VALUES (nom, prenom , CAST(UPPER(genre) AS GENRE),  nas ,salaire ,date , id_poste(poste) , id_departement(departement));
	$$;
	
CREATE PROCEDURE ajout_signalisation(
	_orientation			signalisation.orientation%TYPE
	,_position				signalisation.position%TYPE
	,_troncon				signalisation.troncon%TYPE)
	LANGUAGE SQL
	AS $$			
	INSERT INTO signalisation (orientation,"position",troncon)
			VALUES (_orientation, _position, _troncon);
	$$;	
	
CREATE PROCEDURE ajout_panneau(
	_type					type_pan.nom%TYPE
	,_position				panneau.position%TYPE
	,_troncon				panneau.troncon%TYPE)
	LANGUAGE SQL
	AS $$			
	INSERT INTO panneau ("type", "position", troncon)
			VALUES (id_type_pan(_type), _position, _troncon);
	$$;	


CREATE PROCEDURE insert_rand_panneau()
LANGUAGE plpgsql
AS $$
 -- varaible
 	DECLARE 
 	_type					panneau.type%TYPE;
	_position				panneau.position%TYPE;
	_troncon				panneau.troncon%TYPE;
	
	BEGIN 
		-- ajoute les row			  
		FOR i IN 1..50 LOOP -- 50 a changer
			SELECT select_rand_id('id_type_pan', 'type_pan') INTO _type;
			SELECT (RANDOM()*100) INTO _position;
			SELECT select_rand_id('id_troncon','troncon') INTO _troncon;

			INSERT INTO panneau ("type", "position", troncon)
				VALUES(_type, _position, _troncon);
		END LOOP;	
	END;
$$;

CREATE PROCEDURE insert_rand_signalisation()
LANGUAGE plpgsql
AS $$
 -- varaible
 	DECLARE 
 	_orientation			signalisation.orientation%TYPE;
	_position				signalisation.position%TYPE;
	_troncon				signalisation.troncon%TYPE;
	
	BEGIN 
		-- ajoute les row			  
		FOR i IN 1..50 LOOP 
			-- sélection d'une valeur random du ENUM orientation 
			-- enum_range retourne un array des valeurs du ENUM et unnest les met dans un tableau (rows)
			SELECT * FROM unnest(enum_range(NULL::orientation)) ORDER BY random() LIMIT 1 INTO _orientation;
			SELECT (RANDOM()*100) INTO _position;
			SELECT select_rand_id('id_troncon','troncon') INTO _troncon;

			INSERT INTO signalisation (orientation, "position", troncon)
				VALUES(_orientation, _position, _troncon);
		END LOOP;	
	END;
$$;
-- ===================================================================================================================


-- =================================================== JULIETTE PROCEDURE ============================================

-- Procedure d'insertion dis_particulier aléatoire
CREATE PROCEDURE insert_rand_dis_particulier()
LANGUAGE PLPGSQL
AS $$
    DECLARE 
    _type           dis_particulier.type%TYPE;
    _position       dis_particulier.position%TYPE;
    _troncon        dis_particulier.troncon%TYPE;

    BEGIN

            FOR i IN 1..10 LOOP
            SELECT select_rand_id('id_type_dis_par', 'type_dis_par') INTO _type;
            SELECT (RANDOM()*100) INTO _position;
            SELECT select_rand_id('id_troncon', 'troncon') INTO _troncon;

            INSERT INTO dis_particulier(type, position, troncon)
                    VALUES(_type, _position, _troncon);
                    END LOOP;
        END;
$$;

-- procedure d'insertion lumiere aléatoire
CREATE PROCEDURE insert_rand_lumiere()
LANGUAGE PLPGSQL
AS $$
    DECLARE
     _forme		lumiere.forme%TYPE;
    _couleur		lumiere.couleur%TYPE;
    _mode		lumiere.mode%TYPE;
    _signalisation	lumiere.signalisation%TYPE;

    BEGIN

            FOR i IN 1..30 LOOP
            SELECT select_rand_id('id_forme', 'forme') INTO _forme;
            SELECT select_rand_id('id_couleur', 'couleur') INTO _couleur;
            SELECT * FROM unnest(enum_range(NULL::mode)) ORDER BY random() LIMIT 1 INTO _mode;
            SELECT select_rand_id('id_signalisation', 'signalisation') INTO _signalisation;

            INSERT INTO lumiere(forme, couleur, mode, signalisation)
                VALUES (_forme, _couleur, _mode, _signalisation);
                END LOOP;
        END;
$$;

-- procedure d'insertion lumiere
CREATE PROCEDURE ajout_lumiere(
    _forme		lumiere.forme%TYPE,
    _couleur		lumiere.couleur%TYPE,
    _mode		lumiere.mode%TYPE,
    _signalisation	lumiere.signalisation%TYPE)
    
    LANGUAGE SQL
    AS $$
    INSERT INTO lumiere(forme, couleur, mode, signalisation)
            VALUES(_forme, _couleur, _mode, _signalisation);
$$;

-- procedure d'insertion dis_particulier
CREATE PROCEDURE ajout_dis_par(
    _type           dis_particulier.type%TYPE,
    _position       dis_particulier.position%TYPE,
    _troncon        dis_particulier.troncon%TYPE)
    LANGUAGE SQL
    AS $$
    INSERT INTO dis_particulier(type, position, troncon)
        VALUES(_type, _position, _troncon)
$$;

-- Procedure d'insertion pour la table troncon
CREATE PROCEDURE ajout_troncon(
	id_troncon			troncon.id_troncon%TYPE,
	rue_troncon	 		troncon.rue%TYPE,
    	debut_intersection_tron 	troncon.debut_intersection%TYPE,
    	fin_intersection_tron 		troncon.fin_intersection%TYPE,
    	longueur_troncon 		troncon.longueur%TYPE,
    	limite_troncon 			troncon.limite%TYPE,
    	nb_voie_troncon 		troncon.nb_voie%TYPE,
    	pavage_troncon 			troncon.pavage%TYPE)
	
LANGUAGE SQL
AS $$
INSERT INTO troncon VALUES(
id_troncon, rue_troncon, debut_intersection_tron, fin_intersection_tron,
longueur_troncon, limite_troncon, nb_voie_troncon, pavage_troncon);
$$;

-- ================================================== JULIETTE FONCTION ===============================================

-- Trouve le id d'une forme
CREATE FUNCTION trouver_forme(nom_forme forme.nom%TYPE)
	RETURNS INT
LANGUAGE SQL
AS $$
	SELECT COUNT(*) FROM lumiere AS lum
	INNER JOIN forme AS forme
	ON lum.forme = forme.id_forme
	WHERE nom = nom_forme
	$$;

-- Trouver le salaire total annuel d'un employe
CREATE FUNCTION salaire_annuel(
	_nas	 employe.nas%TYPE)
	RETURNS NUMERIC(8,2)
	LANGUAGE SQL
	AS $$
	SELECT (salaire *  35 * 52)::NUMERIC(8,2) FROM employe WHERE _nas = nas;
	$$;

-- Fonction déclencheur - génère un salaire fixe selon certains poste

CREATE OR REPLACE FUNCTION mise_a_jour_salaire()
RETURNS TRIGGER 
AS $$
	DECLARE
		salaire_fixe NUMERIC(5,2);
BEGIN
    IF NEW.poste = 1 THEN
        NEW.salaire := 220.00;
    ELSIF NEW.poste = 2 THEN
        NEW.salaire := 27.50;
    END IF;
	IF NEW.salaire = null THEN
	NEW.salaire = OLD.salaire;
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER modification_salaire
BEFORE INSERT ON employe
FOR EACH ROW
EXECUTE FUNCTION mise_a_jour_salaire();

-- ===================================================================================================================
--PROCEDURE NOE
CREATE OR REPLACE PROCEDURE insert_rand_inspection_troncon()
LANGUAGE PLPGSQL
AS $$
    DECLARE
     _inspection   inspection_troncon.inspection%TYPE;
     _troncon      inspection_troncon.troncon%TYPE;

    BEGIN

            FOR i IN 1..100 LOOP
				FOR j IN 1..10 LOOP
	            INSERT INTO inspection_troncon(inspection, troncon)
	            VALUES(i,j);
			END LOOP;
			END LOOP;
        END;
$$;


--FUNCTION NOE - calcule le cout d'un vehicule selon le nombre de km
CREATE FUNCTION cout_vehicule(id_vehicule INTEGER, distance_km INTEGER) RETURNS NUMERIC AS $$
DECLARE
    km_cout NUMERIC := 4.79;
BEGIN
    RETURN km_cout * distance_km;
END;
$$ LANGUAGE plpgsql;

--SEQUENCE NOE - incrémente num pour fichier
CREATE SEQUENCE IF NOT EXISTS seq_incr START 20;

--FUNCTION NOE - génère automatiquement un nom de fichier
CREATE FUNCTION generate_nom_fichier_donnees()
RETURNS TRIGGER AS $$
DECLARE
    incr INTEGER;
    date_part VARCHAR(14);
    ext VARCHAR(4);
    nom_fichier VARCHAR(30);
BEGIN
    -- get l'incrément actuel	
	SELECT nextval('seq_incr') INTO incr;
    
    -- generate un nom random
    SELECT to_char(date_trunc('second', NOW() - (Random() * interval '30 days')), 'YYMMDDHH24MISS') INTO date_part;

    -- generate une extention random
    SELECT CASE floor(Random() * 4)
        WHEN 0 THEN 'xdat'
        WHEN 1 THEN 'jdat'
        WHEN 2 THEN 'bdat'
        WHEN 3 THEN 'kdat'
    END INTO ext;

    -- combine les parties
    nom_fichier := 'PZ2_' || lpad(incr::text, 8, '0') || '_' || date_part || '.' || ext;

    -- set le filename
    NEW.nom_fichier_donnees := nom_fichier;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--TRIGGER NOE - insère le nom de fichier de la fonction précédente dans l'inspection
CREATE TRIGGER insert_nom_fichier_donnees
    BEFORE INSERT ON inspection
    FOR EACH ROW
    EXECUTE FUNCTION generate_nom_fichier_donnees();

--PROCEDURE NOE - facilite la création d'une inspection
CREATE PROCEDURE insert_inspection()
LANGUAGE plpgsql
AS $$
    -- variable pour file_name
    DECLARE
        date_d inspection.date_debut%TYPE;
        date_f inspection.date_fin%TYPE;
        conducteur inspection.conducteur%TYPE;
        vehicule inspection.vehicule%TYPE;
        km_debut inspection.km_debut_inspect%TYPE;
        km_fin inspection.km_fin_inspect%TYPE;
        profileur inspection.profileur%TYPE;
        operateur inspection.operateur%TYPE;
        chemin_fichier inspection.chemin_fichier_donnees%TYPE;
        
    BEGIN
        -- utilise le trigger
        --SELECT generate_nom_fichier_donnees() INTO nom_fichier; PAS SUR
        SELECT date_trunc('second', NOW() - (Random() * interval '30 days')) INTO date_d;
        SELECT date_trunc('second', date_d + (Random() * interval '12 hours')) INTO date_f;
        SELECT select_rand_id('id_employe', 'employe') INTO conducteur;
        SELECT select_rand_id('id_vehicule', 'vehicule') INTO vehicule;
        SELECT FLOOR(Random()*(250000 - 1)) + 1 INTO km_debut;
        SELECT km_debut + FLOOR(Random() * 250) + 50 INTO km_fin;
        SELECT select_rand_id('id_profileur', 'profileur') INTO profileur;
        SELECT select_rand_id('id_employe', 'employe') INTO operateur;
        SELECT 'x:\' INTO chemin_fichier;

        -- insert new row
        INSERT INTO inspection (
            date_debut,
            date_fin,
            conducteur,
            vehicule,
            km_debut_inspect,
            km_fin_inspect,
            profileur,
            operateur,
            chemin_fichier_donnees
            --nom_fichier_donnees
     		) VALUES (
            date_d,
            date_f,
            conducteur,
            vehicule,
            km_debut,
            km_fin,
            profileur,
            operateur,
            chemin_fichier
        );
    END;
$$;

--FUNCTION NOE - loop pour insertion automatique
CREATE PROCEDURE insert_loop()
LANGUAGE plpgsql AS $$
BEGIN
    FOR i IN 1..100 LOOP -- 50 a changer
        CALL insert_inspection();
    END LOOP;
END$$;


--VIEW NOE - sélectionne informations de inspection et véhicule
CREATE VIEW vue_inspection_vehicule AS
SELECT ins.id_inspection, ins.date_debut, ins.date_fin, v.marque, v.modele, v.immatriculation
FROM inspection ins
JOIN vehicule v ON ins.vehicule = v.id_vehicule;
