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

-- requête 3 mathis 

SELECT form.nom AS nom_forme, cou.nom AS nom_couleur, COUNT(*) AS nombre_fois
FROM lumiere AS lum
INNER JOIN signalisation AS sig 
ON lum.signalisation = sig.id_signalisation
INNER JOIN forme form 
ON lum.forme = form.id_forme
INNER JOIN couleur AS  cou 
ON lum.couleur = cou.id_couleur
GROUP BY lum.forme, lum.couleur, form.nom, cou.nom
ORDER BY nombre_fois DESC;

--JULIETTE
