-- INDEX mathis
DROP INDEX IF EXISTS idx_cali_emp ;
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
				  
CREATE OR REPLACE FUNCTION insert_loop_calibration()
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
    FOR i IN 1..50 LOOP -- 50 a changer
        PERFORM insert_calibration();
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
