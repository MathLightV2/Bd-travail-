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

-- =======================================================
-- Requête #1
-- Objectif : Donner le nombre de calibrations que chaque employé a fait.
--
--
-- Évaluation : Fonctionnel
-- Réalisé par : Mathis
-- Aidé par :
-- =======================================================
SELECT emp.nom, 
COUNT(*) AS nombre_calibrations
FROM calibration AS cali
	INNER JOIN employe AS emp 
		ON cali.employe = emp.id_employe
GROUP BY emp.nom;
-- =======================================================

-- =======================================================
-- Requête #2
-- Objectif : Pour chaque véhicule, combien de kilomètres de tronçons ont été parcourus pour réaliser les inspections.
--
--
-- Évaluation : Fonctionnel
-- Réalisé par : Mathis
-- Aidé par :
-- =======================================================
SELECT v.immatriculation, 
CONCAT(SUM(ins.km_fin_inspect - ins.km_debut_inspect), ' km')  AS kilometres_parcourus
FROM inspection ins
	INNER JOIN vehicule AS v
		ON ins.vehicule = v.id_vehicule
GROUP BY v.immatriculation;
-- =======================================================

-- =======================================================
-- Requête #3
-- Objectif : Retourne le nombre en ordre décroisant  des différentes 
-- 		combinaisons de forme et de couleur se situant sur les
--		différent tronçons ( doit en avoir plus que 1) et 5 max
-- Évaluation : Fonctionnel
-- Réalisé par : Mathis
-- Aidé par :
-- =======================================================
SELECT form.nom AS nom_forme, cou.nom AS nom_couleur, COUNT(*) AS nombre_fois
	FROM lumiere AS lum
	INNER JOIN signalisation AS sig 
		ON lum.signalisation = sig.id_signalisation
	INNER JOIN forme form 
		ON lum.forme = form.id_forme
	INNER JOIN couleur AS  cou 
		ON lum.couleur = cou.id_couleur
WHERE EXISTS (
	SELECT 
		FROM lumiere AS lum2
		INNER JOIN signalisation AS sig2
			ON lum2.signalisation = sig2.id_signalisation
		INNER JOIN forme form2 
			ON lum2.forme = form2.id_forme
		INNER JOIN couleur AS  cou2 
			ON lum2.couleur = cou2.id_couleur
		WHERE form2.nom = form.nom
			AND cou2.nom = cou.nom
	GROUP BY form2.nom, cou2.nom
	HAVING COUNT(*) > 1
)
GROUP BY lum.forme, lum.couleur, form.nom, cou.nom
ORDER BY nombre_fois DESC
LIMIT 5;
-- =======================================================

--JULIETTE
