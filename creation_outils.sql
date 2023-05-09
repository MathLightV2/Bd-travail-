-- ROMAIN
DROP FUNCTION IF EXISTS id_type_pan, id_dis_pan, id_poste, id_departement, id_employe;
DROP PROCEDURE IF EXISTS ajout_employe, ajout_signalisation, ajout_panneau;

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
	INSERT INTO signalisation (orientation,position,troncon)
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
	
-- NOÉ

-- MATHIS

-- JULIETTE





