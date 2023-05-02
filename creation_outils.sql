-- ROMAIN

-- NOÉ

-- MATHIS

-- JULIETTE
-- Vue Juliette:
-- nombre d'inspections que chaque employe a fait
CREATE VIEW nbr_ins_emp AS
SELECT employe.nom, COUNT(*) AS "Nombres dinspections"
FROM inspection
INNER JOIN employe
ON inspection.operateur = employe.id_employe
GROUP BY employe.nom;

-- Index Juliette :
-- trier le nom des employes par ordre ascendant
CREATE INDEX idx_emp_nom
	ON employe (nom);

-- Procedure Juliette :
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

-- Fonction Juliette :
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

-- Declencher Juliette :
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

CREATE TRIGGER salaire_max ON employe
FOR EACH ROW
EXECUTE FUNCTION max_salaire();