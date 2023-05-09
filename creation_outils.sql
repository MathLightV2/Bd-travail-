-- ROMAIN

-- NOÉ

--FUNCTION NOE - calcule le cout d'un vehicule selon le nombre de km
CREATE FUNCTION cout_vehicule(id_vehicule INTEGER, distance_km INTEGER) RETURNS NUMERIC AS $$
DECLARE
    km_cout NUMERIC := 4.79;
BEGIN
    RETURN km_cout * distance_km;
END;
$$ LANGUAGE plpgsql;

--FUNCTION NOE - génère automatiquement un nom de fichier
CREATE OR REPLACE FUNCTION generate_nom_fichier_donnees()
RETURNS TRIGGER AS $$
DECLARE
    increment INTEGER;
    date_part VARCHAR(14);
    extension VARCHAR(4);
    nom_fichier VARCHAR(30);
BEGIN
    -- Get the current increment for the filename
    SELECT COALESCE(MAX(increment) + 1, 20) INTO increment FROM (
        SELECT substring(nom_fichier_donnees, 5, 8)::INTEGER AS increment FROM inspection
        WHERE substring(nom_fichier_donnees, 1, 3) = 'PZ2'
    ) AS subquery;
    
    -- Generate a new random date for the filename
    SELECT to_char(date_trunc('second', NOW() - (RAND() * interval '30 days')), 'YYMMDDHH24MISS') INTO date_part;

    -- Generate a random extension
    SELECT CASE floor(RAND() * 4)
        WHEN 0 THEN 'xdat'
        WHEN 1 THEN 'jdat'
        WHEN 2 THEN 'bdat'
        WHEN 3 THEN 'kdat'
    END INTO extension;

    -- Combine the parts into the final filename
    nom_fichier := 'PZ2_' || lpad(increment::text, 8, '0') || '_' || date_part || '.' || extension;

    -- Set the generated filename for the new row
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
AS
BEGIN
    DECLARE @rand_id int;
    set @rand_id = (select top 1 id_nom
                 FROM table_nom
                 WHERE id_nom <> 1
                 ORDER BY NEWID())
    RETURN @rand_id;
END;

    
--PROCEDURE NOE - facilite la création d'une inspection
CREATE OR REPLACE PROCEDURE insert_inspection()
LANGUAGE plpgsql
AS $$
    -- variable pour file_name
    DECLARE
        date_d inspection.date_debut%TYPE,
        date_f inspection.date_fin%TYPE,
        conducteur inspection.conducteur%TYPE,
        vehicule inspection.vehicule%TYPE,
        km_debut inspection.km_debut_inspect%TYPE,
        km_fin inspection.km_fin_inspect%TYPE,
        profileur inspection.profileur%TYPE,
        operateur inspection.operateur%TYPE,
        chemin_fichier inspection.chemin_fichier_donnees%TYPE;
        
    BEGIN
        -- utilise le trigger
        --SELECT generate_nom_fichier_donnees() INTO nom_fichier; PAS SUR
        SELECT date_trunc('second', NOW() - (RAND() * interval '30 days')) INTO date_d;
        SELECT date_trunc('second', date_debut() - (RAND() * interval '30 days')) INTO date_f;
        SELECT select_rand_id('id_conducteur', 'conducteur') INTO conducteur;
        SELECT select_rand_id('id_vehicule', 'vehicule') INTO vehicule;
        SELECT (FLOOR(RAND()*(250000 - 1) + 1) INTO km_debut
        SELECT (FLOOR(RAND()*(500000 - 250000) + 250000) INTO km_fin
        SELECT select_rand_id('id_profileur', 'profileur') INTO profileur;
        SELECT select_rand_id('id_operateur', 'operateur') INTO operateur;
        --rand chemin_fichier

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
            chemin_fichier_donnees,
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
            chemin_fichier,
            nom_fichier
        );
    END;
END;
$$;

--FUNCTION NOE - loop pour insertion automatique
CREATE OR REPLACE FUNCTION insert_loop()
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..50 LOOP -- 50 a changer
        PERFORM insert_inspection()
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

-- MATHIS

-- JULIETTE





