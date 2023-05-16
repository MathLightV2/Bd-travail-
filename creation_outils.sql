-- INDEX mathis
CREATE INDEX idx_cali_emp
ON calibration (employe);


-- PROCEDURE mathis
CREATE OR REPLACE PROCEDURE insert_calibration()
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
	SELECT nextval('seq_cali_id') INTO id_calibration;
	SELECT ('second', NOW() - (RAND() * interval '30 days')) INTO date_debut;
	SELECT ('second', NOW() - (RAND() * interval '30 days')) INTO date_fin;
	SELECT select_rand_id('id_employe','employe') INTO employe;
	SELECT FLOOR(RAND()*(500 - 1)) + 1 INTO v1;
	SELECT FLOOR(RAND()*(500 - 1)) + 1 INTO v2;
	SELECT FLOOR(RAND()*(500 - 1)) + 1 INTO v3;
	SELECT select_rand_id ('id_profileur','profileur');
				  
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
	END;

$$;
				  
	
-- fonction mathis - loop pour l'insertion  				  
CREATE OR REPLACE PROCEDURE insert_loop_calibration()
LANGUAGE plpgsql AS $$
BEGIN
    FOR i IN 1..50 LOOP -- 50 a changer
        CALL insert_calibration();
    END LOOP;
END$$;

-- ROMAIN FONCTIONS
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

-- ROMAIN PROCÉDURES 
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


CREATE OR REPLACE PROCEDURE insert_rand_panneau()
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

CREATE OR REPLACE PROCEDURE insert_rand_signalisation()
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
			-- enum_range retourne un array de valeurs et unnest les met dans un tableau (rows)
			SELECT * FROM unnest(enum_range(NULL::orientation)) ORDER BY random() LIMIT 1 INTO _orientation;
			SELECT (RANDOM()*100) INTO _position;
			SELECT select_rand_id('id_troncon','troncon') INTO _troncon;

			INSERT INTO signalisation (orientation, "position", troncon)
				VALUES(_orientation, _position, _troncon);
		END LOOP;	
	END;
$$;

-- JULIETTE
-- procedure : insertion dis_particulier aléatoire
CREATE OR REPLACE PROCEDURE insert_rand_dis_particulier()
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

-- procedure : insertion lumiere aléatoire
CREATE OR REPLACE PROCEDURE insert_rand_lumiere()
LANGUAGE PLPGSQL
AS $$
    DECLARE
     _forme			lumiere.forme%TYPE;
    _couleur			lumiere.couleur%TYPE;
    _mode		    lumiere.mode%TYPE;
    _signalisation	lumiere.signalisation%TYPE;

    BEGIN

            FOR i IN 1..10 LOOP
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
    _forme			lumiere.forme%TYPE,
    _couleur			lumiere.couleur%TYPE,
    _mode		    lumiere.mode%TYPE,
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

-- Vue
CREATE VIEW nbr_ins_emp AS
SELECT employe.nom, COUNT(*) AS "Nombres dinspections"
FROM inspection
INNER JOIN employe
ON inspection.operateur = employe.id_employe
GROUP BY employe.nom;


-- Index :
-- trier le nom des employes par ordre ascendant
CREATE INDEX idx_emp_nom
	ON employe (nom);


-- Procedure :
-- Insertion pour la table troncon
CREATE PROCEDURE ajout_troncon(
	id_troncon troncon.id_troncon%TYPE,
	rue_troncon troncon.rue%TYPE,
    debut_intersection_tron troncon.debut_intersection%TYPE,
    fin_intersection_tron troncon.fin_intersection%TYPE,
    longueur_troncon troncon.longueur%TYPE,
    limite_troncon troncon.limite%TYPE,
    nb_voie_troncon troncon.nb_voie%TYPE,
    pavage_troncon troncon.pavage%TYPE
)
LANGUAGE SQL
AS $$
INSERT INTO troncon VALUES(
id_troncon, rue_troncon, debut_intersection_tron, fin_intersection_tron,
longueur_troncon, limite_troncon, nb_voie_troncon, pavage_troncon);
$$;

-- Fonction :
-- Trouver le salaire total annuel d'un employe
CREATE FUNCTION salaire_total_emp(
salaire_emp employe.salaire%TYPE,
nom_emp employe.nom%TYPE
)
RETURNS NUMERIC(5,2)
LANGUAGE SQL
AS $$
SELECT (salaire *  32 * 4 * 12) FROM employe WHERE nom_emp = nom;
$$;

----------------------------------------------------------------------------------

-- DROP PROCEDURE IF EXISTS insert_inspection;
-- DROP TRIGGER IF EXISTS insert_nom_fichier_donnees on inspection;
-- DROP VIEW IF EXISTS inspection_fees;
-- DROP INDEX IF EXISTS inspect_debut;
-- DROP FUNCTION IF EXISTS generate_nom_fichier_donnees, select_rand_id, insert_loop, cout_vehicule;

--FUNCTION NOE - calcule le cout d'un vehicule selon le nombre de km
CREATE FUNCTION cout_vehicule(id_vehicule INTEGER, distance_km INTEGER) RETURNS NUMERIC AS $$
DECLARE
    km_cout NUMERIC := 4.79;
BEGIN
    RETURN km_cout * distance_km;
END;
$$ LANGUAGE plpgsql;

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
        SELECT date_trunc('second', date_d - (Random() * interval '30 days')) INTO date_f;
        SELECT select_rand_id('id_employe', 'employe') INTO conducteur;
        SELECT select_rand_id('id_vehicule', 'vehicule') INTO vehicule;
        SELECT FLOOR(Random()*(250000 - 1)) + 1 INTO km_debut;
        SELECT FLOOR(Random()*(500000 - 250000)) + 250000 INTO km_fin;
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
    FOR i IN 1..50 LOOP -- 50 a changer
        CALL insert_inspection();
    END LOOP;
END$$;

--VIEW NOE - donne le cout total d'une inspection
CREATE VIEW inspection_fees AS 
SELECT 
  i.id_inspection, 
  (e.salaire * EXTRACT(hour FROM (i.date_fin - i.date_debut))) AS employee_fee, 
  cout_vehicule(i.vehicule, (i.km_fin_inspect - i.km_debut_inspect)) AS vehicle_fee, 
  (e.salaire * EXTRACT(hour FROM (i.date_fin - i.date_debut))) + cout_vehicule(i.vehicule, (i.km_fin_inspect - i.km_debut_inspect)) AS total_fee
FROM inspection i 
INNER JOIN employe e ON i.conducteur = e.id_employe;

--INDEX NOE - sort les inspections par date_debut
CREATE INDEX inspect_debut ON inspection (date_debut);



-- -- Declencheur :
-- -- Le salaire ne doit pas depasser 250$
-- CREATE FUNCTION max_salaire()
-- RETURNS TRIGGER
-- LANGUAGE PLPGSQL
-- AS $$
-- BEGIN
-- IF NEW.salaire > 250 THEN
-- RAISE EXCEPTION 'Le salaire ne peut pas depasser 250$';
-- END IF;
-- RETURN NEW;
-- END$$;
-- -- Trigger :
-- CREATE TRIGGER salaire_max ON employe
-- FOR EACH ROW
-- EXECUTE FUNCTION max_salaire();
