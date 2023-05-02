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

-- MATHIS

-- JULIETTE





