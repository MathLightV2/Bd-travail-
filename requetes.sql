-- ROMAIN
-- =======================================================
-- Requête #1
-- Objectif : Donner la liste des employés : nom, prénom, poste, nom du département, ancienneté
--			  (en année et mois), leur salaire annuel (considérant qu’ils travaillent 35 heures par
--			  semaine et 52 semainespar année) et leur salaire annuel augmenté de 15%.
-- Évaluation : Fonctionnel
-- Réalisé par : Romain
-- Aidé par :
-- =======================================================
SELECT emp.nom "Nom", emp.prenom "Prénom", poste.titre "Poste", dep.nom "Département"
		,TO_CHAR(AGE(CURRENT_DATE, emp.date_embauche), 'YY "ans et" MM "mois"') "Ancienneté"
		,salaire_annuel(emp.nas) "Salaire annuel", (salaire_annuel(emp.nas)*1.15)::NUMERIC(8,2) "Salaire annuel augementé"
FROM employe AS emp
	INNER JOIN departement AS dep ON dep.id_departement = emp.departement
	INNER JOIN poste ON poste.id_poste = emp.poste;
-- =======================================================



-- =======================================================
-- Requête #2
-- Objectif : Pour chacune des inspections, on désire savoir quels ont été les frais associés (vous
--			  devez tenir compte du temps passé pour les deux employés lors de l’inspection et des
--			  coûts d’exploitation du véhicule à 4.79$ par kilomètre.). Les met en ordre de la plus cher a la moins cher
-- Évaluation : Fonctionnel
-- Réalisé par : Romain
-- Aidé par : 
-- =======================================================
SELECT r.*, r."Salaire conducteur ($)" + r."Salaire opérateur ($)" + r."Coût des déplacements ($)" AS "Total ($)"
FROM (SELECT rap."No. Inspection"
			,transform_heures(rap."Date et heure de début", rap."Date et heure de fin") AS "temps d''inspection (H)"
			,(transform_heures(rap."Date et heure de début", rap."Date et heure de fin") * rap."Salaire horaire du conducteur")::NUMERIC(6,2) AS "Salaire conducteur ($)"
			,(transform_heures(rap."Date et heure de début", rap."Date et heure de fin") * rap."Salaire horaire de l''opérateur")::NUMERIC(6,2) AS "Salaire opérateur ($)"
			,(rap."Nb de kilometre parcouru" * 4.79)::NUMERIC(6,2) "Coût des déplacements ($)"
		FROM rapport_inspection AS rap ) AS r
ORDER BY "Total ($)" DESC
-- =======================================================



-- =======================================================
-- Requête #3
-- Objectif : Sort un rapport des 3 employés ayant la plus haute moyenne de Km parcouruentant que conducteur
--			  en ordre décroisant et ayant un salaire supérieur a la moyenne salarial de leur département
-- Évaluation : Fonctionnel
-- Réalisé par : Romain
-- Aidé par :
-- =======================================================
SELECT AVG(ins.km_fin_inspect - ins.km_debut_inspect)::NUMERIC(5,2) "Moyenne km", con.nom || ', ' || con.prenom AS "Conducteur"
		,po.titre "Poste", con.salaire, dep.nom "Département"
FROM inspection AS ins
	INNER JOIN employe AS con ON con.id_employe = ins.conducteur
	INNER JOIN poste AS po ON po.id_poste = con.poste
	INNER JOIN departement AS dep ON dep.id_departement = con.departement
GROUP BY con.nom, con.prenom, po.titre, con.salaire, con.departement, dep.nom
HAVING con.salaire >= (SELECT AVG(emp.salaire)
					 FROM employe as emp
					 WHERE emp.departement = con.departement )
ORDER BY "Moyenne km" DESC
LIMIT 3;
-- =======================================================




-- NOÉ
-- =======================================================
-- Requête #1
-- Objectif : Donner le nombre d’inspections que chaque employé a fait.
-- Explication : La requête combine premièrement le nom et le prénom pour les mettres dans la même colonne 'employe'	(SELECT)	
-- 				 on compte ensuite le nombre de fois (COUNT(*)) que cet employé apparait dans les inspections (FROM inspection ins)
--				 le JOIN permet de récupérer les employés qui apparaissent soit comme conducteur ou opérateur d'une inspection, pour les identifier.
-- Évaluation : Fonctionnel
-- 
-- 
-- Réalisé par : Noé
-- Aidé par :
-- =======================================================
SELECT e.nom || ' ' || e.prenom AS employe, COUNT(*) AS nombre_inspections
FROM inspection ins
JOIN employe e ON ins.conducteur = e.id_employe OR ins.operateur = e.id_employe
GROUP BY e.nom, e.prenom
ORDER BY nombre_inspections DESC;
-- =======================================================


-- =======================================================
-- Requête #2
-- Objectif : Donner la liste des profileurs laser ayant besoin d’être calibrés.
-- Explication : la requête séletionne toutes les colonnes de la table 'profileur' si la formule du WHERE est vrai.
--				 les données sont prisent de la table 'calibration' et joins a la table 'profileur' pour les afficher dans les colonnes.
-- 
-- Évaluation : Fonctionnel
-- 
-- 
-- Réalisé par : Noé
-- Aidé par :
-- =======================================================
SELECT p.*
FROM calibration c
JOIN profileur p ON c.profileur = p.id_profileur
WHERE SQRT(ABS(((c.v1 * c.v2) / POWER(c.v3, 2)) - 1)) <= 1 / POWER(PI(), 2);
-- ======================================================= 


-- =======================================================
-- Requête #3
-- Objectif :  Donne les 5 inspections les plus récentes qui ont 
--			   un nombre de km parcouru plus élevé que la moyenne des km parcourus,
--			   en donnant aussi le nas de l'employé conducteur et le id du véhicule utilisé.	
-- Explication : Sélectionne le id_inspection, km_parcourus, date_debut, le nas de l'employe et id du véhicule
--				 en joignant les tables 'employe', 'inspection' et 'vehicule' avec les clées étrangères. 
--				 le résultat est aussi groupé par le nas, le id_inspection, id_vehicule et la date_debut pour ne pas faire de calculs inutiles 
--				 et de filtrer les groupes par rapport au critère du HAVING, qui sélectionne seulement les inspections qui ont un nombre de km plus élevé que ceux
--				 de la moyenne. les résultats sont limités à 5 et en ordre de date
--				 
--				 
-- 
-- Évaluation : Fonctionnel
-- 
-- 
-- Réalisé par : Noé
-- Aidé par :
-- =======================================================
SELECT i.id_inspection, i.date_debut, (i.km_fin_inspect - i.km_debut_inspect) AS km_parcourus, e.nas AS conducteur_nas, v.id_vehicule
FROM employe e
JOIN inspection i ON e.id_employe = i.conducteur
JOIN vehicule v ON i.vehicule = v.id_vehicule
GROUP BY e.nas, i.id_inspection, v.id_vehicule, i.date_debut
HAVING (i.km_fin_inspect - i.km_debut_inspect) > (
    SELECT AVG(km_fin_inspect - km_debut_inspect)
    FROM inspection) 
ORDER BY i.date_debut DESC
LIMIT 5;
-- =======================================================




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

-- JULIETTE

-- =======================================================
-- Requête # 1
-- Objectif : Donner le nombre d’inspections où chaque employé était conducteur.
-- ...
-- ...
-- Évaluation : Complètement fonctionnelle
-- ...
-- ...
-- Réalisé par : Juliette Vincent
-- =======================================================
SELECT COUNT(*) AS "nombre inspections"
FROM inspection AS insp
INNER JOIN employe AS conduct
ON insp.conducteur = conduct.id_employe
GROUP BY insp.conducteur
-- =======================================================

-- =======================================================
-- Requête # 2
-- Objectif : Identifier tous les tronçons de rue qui ont un dispositif de signalisation lumineux de
-- forme « humain », « main » ou « vélo » et en quelle quantité. Le résultat doit montrer
-- le nom de la rue du tronçon et le nombre de dispositifs lumineux de chaque forme
-- spécifiée. Le résultat ne devrait pas montrer de NULL (0 si aucune), ni les tronçons qui
-- n’ont aucun dispositif avec des lumières de ces formes.
-- ...
-- ...
-- Évaluation : Complètement fonctionnelle
-- ...
-- ...
-- Réalisé par : Juliette Vincent
-- =======================================================
SELECT rue.nom,
        COALESCE(sum(case when lum.forme  = trouver_id_forme('humains') then 1 end), 0) as "HUMAIN",
        COALESCE(sum(case when lum.forme  = trouver_id_forme('main') then 1 end), 0) as "MAIN",
        COALESCE(sum(case when lum.forme  = trouver_id_forme('velo') then 1 end), 0) as "VELO"
FROM troncon AS tron
INNER JOIN rue AS rue
ON tron.rue = rue.id_rue
INNER JOIN signalisation AS sign
ON sign.troncon = tron.id_troncon
INNER JOIN lumiere AS lum
ON sign.id_signalisation = lum.signalisation

GROUP BY rue.nom;
-- =======================================================

-- =======================================================
-- Requête # 3
-- Objectif : Le nom de la couleur principale (celle qui revient le plus souvent) 
-- ayant le plus de dispositif lumineux qui ont des lumiere de forme de type fleche
-- et d'orientation de type verticale.
-- ...
-- ...
-- Évaluation : Complètement fonctionnelle
-- ...
-- ...
-- Réalisé par : Juliette Vincent
-- =======================================================
SELECT couleur.nom AS "nom couleur"
FROM couleur
INNER JOIN lumiere AS lum
ON lum.couleur = couleur.id_couleur
INNER JOIN signalisation AS sign
ON lum.signalisation = sign.id_signalisation
WHERE lum.forme = (SELECT forme.id_forme FROM forme AS "forme" WHERE nom = 'fleche') 
 					AND sign.orientation = 'verticale'
GROUP BY couleur.nom
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 1;
-- =======================================================
