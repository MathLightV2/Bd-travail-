-- ROMAIN
DROP FUNCTION IF EXISTS id_type_pan, id_dis_pan, id_poste, id_departement, id_employe;

CREATE OR REPLACE FUNCTION id_type_pan(
	_nom type_pan.nom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_type_pan FROM type_pan WHERE _nom = nom
	$$;
	
CREATE OR REPLACE FUNCTION id_dis_pan(
	_nom type_dis_par.nom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_type_dis_par FROM type_dis_par WHERE _nom = nom
	$$;
	
CREATE OR REPLACE FUNCTION id_poste(
	_titre poste.titre%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_poste FROM poste WHERE _titre = titre
	$$;
	
CREATE OR REPLACE FUNCTION id_departement(
	_nom departement.nom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_departement FROM departement WHERE _nom = nom
	$$;

CREATE OR REPLACE FUNCTION id_employe(
	_nom employe.nom%TYPE
	,_prenom employe.prenom%TYPE)
	RETURNS INT
	LANGUAGE SQL
	AS $$
		SELECT id_employe FROM employe WHERE (_nom = nom) AND (_prenom = prenom)
	$$;

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

-- Declencheur :
-- Le salaire ne doit pas depasser 250$
CREATE FUNCTION max_salaire()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
IF NEW.salaire > 250 THEN
RAISE EXCEPTION 'Le salaire ne peut pas depasser 250$';
END IF;
RETURN NEW;
END;
-- Trigger :
CREATE TRIGGER salaire_max ON employe
FOR EACH ROW
EXECUTE FUNCTION max_salaire();
