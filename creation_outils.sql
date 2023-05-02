-- ROMAIN
CREATE OR REPLACE PROCEDURE ajout_employe_departement(
	nom				employe.nom%TYPE
	,prenom			employe.prenom%TYPE
	,genre			employe.genre%TYPE
	,nas			employe.nas%TYPE
	,salaire		employe.salaire%TYPE
	,date			employe.date_emabauche%TYPE
	,poste			employe.poste%TYPE
	,departement	employe.departement%TYPE
	LANGUAGE SQL
	AS $$			
	INSERT INTO employe(nom, prenom, genre, nas, salaire, date_emabauche, poste, departement)
			VALUES (nom,prenom ,genre ,nas ,salaire ,date ,poste ,departement);		
	$$;

-- NOÉ

-- MATHIS

-- JULIETTE





