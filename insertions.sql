
INSERT INTO rue(nom)
VALUES
    ('Viau'),
    ('Sherbrooke'),
    ('Pie IX'),
    ('Rosemont'),
    ('Pierre de Coubertin');

-- table troncon
INSERT INTO troncon
VALUES
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 2, 3, 717.69, 50, 2, 'asphalte'), --1
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pierre de Coubertin'), 1, 2, 1070, 50, 2,'asphalte'), --2
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 3, 4, 1000, 30, 2, 'asphalte'),--3
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Rosemont'), 4, 5, 1100, 50, 2, 'asphalte'),--4
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Sherbrooke'), 3, 11, 1200, 50, 2, 'asphalte'),--5
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 5, 6, 217.78, 50, 2, 'asphalte'),--6
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 6, 7, 237.51, 50, 2, 'asphalte'),--7
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 7, 8, 246.30, 50, 2, 'asphalte'),--8
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 8, 9, 236.38, 50, 2, 'ciment'), -- 9
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 9, 10, 321.75, 50, 2, 'ciment'), -- 10
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 10, 11, 361.68, 50, 2, 'asphalte'), -- 11
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 11, 1, 230.10, 50, 2, 'asphalte'), -- 12
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 3, 2, 717.69, 50, 2, 'asphalte'), -- 13
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pierre de Coubertin'), 2, 1, 1070, 50, 2, 'asphalte'), -- 14
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Viau'), 4, 3, 1000, 30, 2, 'asphalte'), -- 15
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Rosemont'), 5, 4, 1100, 50, 2, 'asphalte'), -- 16
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Sherbrooke'), 11, 3, 1200, 50, 2, 'asphalte'), -- 17
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 6, 5, 217.78, 50, 2, 'asphalte'), -- 18
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 7, 6, 237.51, 50, 2, 'asphalte'), -- 19
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 8, 7, 245.74, 50, 2, 'asphalte'), -- 20
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 9, 8, 233.15, 50, 2, 'asphalte'), -- 21
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 10, 9, 323.29, 50, 2, 'asphalte'), -- 22
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 11, 10, 358.3, 50, 2, 'asphalte'), -- 23
    (nextval('seq_tron_id'), (SELECT id_rue FROM rue WHERE nom = 'Pie IX'), 1, 11, 233.90, 50, 2, 'asphalte'); -- 24

INSERT INTO couleur(nom, hex)
VALUES
    ('rouge', 'FF0000'),
    ('jaune', 'FFFF00'),
    ('vert', '00FF00'),
    ('orange', 'FFBF00'),
    ('blanc', 'FFFFFF');

INSERT INTO dis_particulier(type, position, troncon)
VALUES
    (1, 100, 2),
    (2, 0, 5),
    (3, 50, 7);

INSERT INTO lumiere (forme, couleur, mode, signalisation)
VALUES
    (1, 1, 'solide', 1),
    (1, 2, 'solide', 1),
    (1, 3, 'solide', 1),
    (2, 1, 'controle', 2),
    (2, 2, 'controle', 2),
    (3, 3, 'intelligente', 2),
    (4, 1, 'solide', 3),
    (4, 2, 'solide', 3),
    (4, 3, 'solide', 3),
    (6, 4, 'clignotant', 4),
    (5, 5, 'controle', 5),
    (7, 5, 'solide', 6),
    (8, 3, 'solide', 7),
    (9, 1, 'solide', 8);

-- insertion random lumiere JULIETTE
				
CREATE PROCEDURE insertion_lumiere()
LANGUAGE PLPGSQL
AS $$
	DECLARE
		id_lumiere			lumiere.id_lumiere%TYPE;
		forme_lum			lumiere.forme%TYPE;
		couleur_lum			lumiere.couleur%TYPE;
		mode_lum			lumiere.mode%TYPE;
		signalisation_lum	lumiere.signalisation%TYPE;
BEGIN
		SELECT nextval('lumiere_id') INTO id_lumiere;
		SELECT select_rand_id('id_forme', 'forme') INTO forme_lum;
        SELECT select_rand_id('id_couleur', 'couleur') INTO couleur_lum;
        -- ENUM RANDOM
        SELECT select_rand_id('id_signalisation', 'signalisation') INTO signalisation_lum;

	INSERT INTO lumiere
	VALUES (
        id_lumiere, --???
        forme_lum,
        -- MODE
        signalisation_lum
    );
END;
$$;
				
				
CREATE FUNCTION insert_lumiere_loop()
RETURN VOID
LANGUAGE PLPGSQL
AS $$
DECLARE
i INTEGER;
BEGIN
	FOR I IN 1..6 LOOP
			PERFORM insertion_lumiere();
	END LOOP;
END$$;	

-- insertion aleatoire dispositif particulier JULIETTE
CREATE PROCEDURE insertion_dis_par()
LANGUAGE PLPGSQL
AS $$
	DECLARE
		id_dis_par			lumiere.id_dis_par%TYPE;
		type_dis			lumiere.type%TYPE;
		position_dis			lumiere.position%TYPE;
		troncon_dis			lumiere.troncon%TYPE;
BEGIN
		SELECT nextval('id_dis_par') INTO id_dis_par;
		SELECT select_rand_id('id_type_dis_par', 'type_dis_par') INTO type_dis;
        SELECT select_rand_id(RAND()*(100.00 - 0.00)) INTO position_dis;
        SELECT select_rand_id('id_troncon', 'troncon') INTO troncon_dis;

	INSERT INTO dis_particulier
	VALUES (
        id_type_dis_par,
        type_dis,
        position_dis,
        troncon_dis
    );
END;
$$;
				
-- insertion random dis_particulier JULIETTE
CREATE FUNCTION inster_dis_loop()
RETURN VOID
LANGUAGE PLPGSQL
AS $$
DECLARE
i INTEGER;
BEGIN
	FOR I IN 1..6 LOOP
			PERFORM inser_dis_par();
	END LOOP;
END$$;