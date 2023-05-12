DROP PROCEDURE IF EXISTS insert_inspection;
DROP TRIGGER IF EXISTS insert_nom_fichier_donnees on inspection;
DROP VIEW IF EXISTS inspection_fees;
DROP INDEX IF EXISTS inspect_debut;
DROP FUNCTION IF EXISTS generate_nom_fichier_donnees, select_rand_id, insert_loop, cout_vehicule;

--FUNCTION NOE - calcule le cout d'un vehicule selon le nombre de km
CREATE FUNCTION cout_vehicule(id_vehicule INTEGER, distance_km INTEGER) RETURNS NUMERIC AS $$
DECLARE
    km_cout NUMERIC := 4.79;
BEGIN
    RETURN km_cout * distance_km;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE IF NOT EXISTS seq_incr START 20;

--FUNCTION NOE - génère automatiquement un nom de fichier
CREATE FUNCTION generate_nom_fichier_donnees()
RETURNS TRIGGER AS $$
DECLARE
    incr INTEGER;
    date_part VARCHAR(14);
    ext VARCHAR(4);
    nom_fichier VARCHAR(30);
BEGIN
    -- get l'incrément actuel	
	SELECT nextval('seq_incr') INTO incr;
    
    -- generate un nom random
    SELECT to_char(date_trunc('second', NOW() - (Random() * interval '30 days')), 'YYMMDDHH24MISS') INTO date_part;

    -- generate une extention random
    SELECT CASE floor(Random() * 4)
        WHEN 0 THEN 'xdat'
        WHEN 1 THEN 'jdat'
        WHEN 2 THEN 'bdat'
        WHEN 3 THEN 'kdat'
    END INTO ext;

    -- combine les parties
    nom_fichier := 'PZ2_' || lpad(incr::text, 8, '0') || '_' || date_part || '.' || ext;

    -- set le filename
    NEW.nom_fichier_donnees := nom_fichier;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--TRIGGER NOE - insère le nom de fichier de la fonction précédente dans l'inspection
CREATE TRIGGER insert_nom_fichier_donnees
    BEFORE INSERT ON inspection
    FOR EACH ROW
    EXECUTE FUNCTION generate_nom_fichier_donnees();
    
--FUNCTION NOE - Select random id d'une table
CREATE FUNCTION select_rand_id(id_nom VARCHAR(32), table_nom VARCHAR(32)) RETURNS int
LANGUAGE plpgsql
AS $$
    DECLARE 
		Rand_id integer;
		query TEXT;
	BEGIN
        query := format('SELECT MIN(%I) FROM %I WHERE %I <> 1 ORDER BY RANDOM()', id_nom, table_nom, id_nom);
    	EXECUTE query INTO Rand_id;
    	RETURN Rand_id;
END$$;

--PROCEDURE NOE - facilite la création d'une inspection
CREATE PROCEDURE insert_inspection()
LANGUAGE plpgsql
AS $$
    -- variable pour file_name
    DECLARE
        date_d inspection.date_debut%TYPE;
        date_f inspection.date_fin%TYPE;
        conducteur inspection.conducteur%TYPE;
        vehicule inspection.vehicule%TYPE;
        km_debut inspection.km_debut_inspect%TYPE;
        km_fin inspection.km_fin_inspect%TYPE;
        profileur inspection.profileur%TYPE;
        operateur inspection.operateur%TYPE;
        chemin_fichier inspection.chemin_fichier_donnees%TYPE;
        
    BEGIN
        -- utilise le trigger
        --SELECT generate_nom_fichier_donnees() INTO nom_fichier; PAS SUR
        SELECT date_trunc('second', NOW() - (Random() * interval '30 days')) INTO date_d;
        SELECT date_trunc('second', date_d - (Random() * interval '30 days')) INTO date_f;
        SELECT select_rand_id('id_employe', 'employe') INTO conducteur;
        SELECT select_rand_id('id_vehicule', 'vehicule') INTO vehicule;
        SELECT FLOOR(Random()*(250000 - 1)) + 1 INTO km_debut;
        SELECT FLOOR(Random()*(500000 - 250000)) + 250000 INTO km_fin;
        SELECT select_rand_id('id_profileur', 'profileur') INTO profileur;
        SELECT select_rand_id('id_employe', 'employe') INTO operateur;
        SELECT 'x:\' INTO chemin_fichier;

        -- insert new row
        INSERT INTO inspection (
            date_debut,
            date_fin,
            conducteur,
            vehicule,
            km_debut_inspect,
            km_fin_inspect,
            profileur,
            operateur,
            chemin_fichier_donnees
            --nom_fichier_donnees
     		) VALUES (
            date_d,
            date_f,
            conducteur,
            vehicule,
            km_debut,
            km_fin,
            profileur,
            operateur,
            chemin_fichier
        );
    END;
$$;

--FUNCTION NOE - loop pour insertion automatique
CREATE FUNCTION insert_loop()
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
    FOR i IN 1..50 LOOP -- 50 a changer
        CALL insert_inspection();
    END LOOP;
END$$;

--VIEW NOE - donne le cout total d'une inspection
CREATE VIEW inspection_fees AS 
SELECT 
  i.id_inspection, 
  (e.salaire * EXTRACT(hour FROM (i.date_fin - i.date_debut))) AS employee_fee, 
  cout_vehicule(i.vehicule, (i.km_fin_inspect - i.km_debut_inspect)) AS vehicle_fee, 
  (e.salaire * EXTRACT(hour FROM (i.date_fin - i.date_debut))) + cout_vehicule(i.vehicule, (i.km_fin_inspect - i.km_debut_inspect)) AS total_fee
FROM inspection i 
INNER JOIN employe e ON i.conducteur = e.id_employe;

--INDEX NOE - sort les inspections par date_debut
CREATE INDEX inspect_debut ON inspection (date_debut);

SELECT insert_loop();
