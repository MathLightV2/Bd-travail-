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

-- requête 2 mathis 
SELECT v.immatriculation, 
CONCAT(SUM(ins.km_fin_inspect - ins.km_debut_inspect), ' km')  AS kilometres_parcourus
FROM inspection ins
	INNER JOIN vehicule AS v
		ON ins.vehicule = v.id_vehicule
GROUP BY v.immatriculation;

--JULIETTE
