-- =======================================================
-- Requête #
-- Objectif : ...
-- ...
-- ...
-- Évaluation : ...
-- ...
-- ...
-- Réalisé par : ...
-- Aidé par : ...
-- =======================================================
votre requête
-- =======================================================

-- ROMAIN

-- NOÉ

-- MATHIS

-- requête 1 mathis 

SELECT emp.nom, 
COUNT(*) AS nombre_calibrations
FROM calibration AS cali
	INNER JOIN employe AS emp 
		ON cali.employe = emp.id_employe
GROUP BY emp.nom;

--JULIETTE
