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
    SELECT to_char(date_trunc('second', NOW() + (random() * interval '30 days')), 'YYMMDDHH24MISS') INTO date_part;

    -- Generate a random extension
    SELECT CASE floor(random() * 4)
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
    
--PROCEDURE NOE - facilite la création d'une inspection
CREATE OR REPLACE PROCEDURE insert_inspection(
    p_date_debut TIMESTAMP,
    p_date_fin TIMESTAMP,
    p_conducteur INTEGER,
    p_vehicule INTEGER,
    p_km_debut_inspect INTEGER,
    p_km_fin_inspect INTEGER,
    p_profileur INTEGER,
    p_operateur INTEGER,
    p_chemin_fichier_donnees VARCHAR(1024)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- variable pour file_name
    DECLARE
        nom_fichier VARCHAR(30);
    BEGIN
        -- utilise le trigger
        SELECT generate_nom_fichier_donnees() INTO nom_fichier;

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
            nom_fichier_donnees
        ) VALUES (
            p_date_debut,
            p_date_fin,
            p_conducteur,
            p_vehicule,
            p_km_debut_inspect,
            p_km_fin_inspect,
            p_profileur,
            p_operateur,
            p_chemin_fichier_donnees,
            nom_fichier
        );
    END;
END;
$$;

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





