--Exo 1: Afficher le nom de toutes les agences --

SELECT nom FROM agence;

--Exo 2 : Afficher le nom de l'agence 'Orpi' --

SELECT nom FROM agence WHERE nom = "orpi";
--Exo 3 : Afficher le premier enregistrement de la table logement --

SELECT * FROM logement LIMIT 0,1;

--Exo 4 : Afficher le nombre de logement (Avec Alias: Nombre de logments) --

SELECT COUNT(idLogement) AS 'Nombre de logements' FROM logement;

--Exo 5 : Afficher les logements à vendre à moins de 150K dans l'odre croissant des prix --

SELECT * FROM logement WHERE prix < 150000 AND categorie = 'vente' ORDER BY prix ASC;


--Exo 6: Afficher le nombre de logements à la location (Avec alias: Logements en location) --

SELECT COUNT(*) AS 'Logements en location' FROM logement WHERE categorie = 'location';

--Exo 7: Afficher les différentes villes recherchées par les personnes en demande de logement --

SELECT DISTINCT ville FROM demande;

--Exo 8: Afficher le nombre de demandes de biens à vendre par ville --
SELECT ville, COUNT(ville) AS 'Nombre de biens à vendre' FROM demande WHERE categorie = 'vente' GROUP BY ville;

-- Biens à vendre disponibles --
SELECT ville, COUNT(ville) AS 'Nombre de biens à vendre' FROM logement WHERE categorie = 'vente' GROUP BY ville;

--Exo 9: Quels sont les id des logements destinés à la location --

SELECT idLogement FROM logement  WHERE categorie = 'location';

--Exo 10: Quels sont les id des logements entre 20 et 30m2? --

SELECT idLogement FROM logement WHERE superficie BETWEEN 20 AND 30;

--Exo 11: Quel est le prix vendeur (hors frais) du logement le moins cher à vendre (Avec alias: 'Prix minimum') --
SELECT prix AS 'prix minimum' FROM logement WHERE categorie = 'vente' ORDER BY prix ASC LIMIT 1;
-- Autre manière de faire --

SELECT MIN(prix) AS 'Prix minimum' FROM logement WHERE categorie = 'vente';

--Exo 12 Dans quelle(s) ville(s) se trouvent les maisons à vendre? --
    SELECT genre, ville FROM logement WHERE genre = 'maison' AND categorie = 'vente';

--Exo 13: L'agence Orpi souhaite diminuer les frais qu'elle applique sur le logement ayant l'id "5246". Il faut passer les frais de se logement de 800 à 730€ --
UPDATE logement_agence SET frais="730" WHERE idLogement = 5246 AND idAgence = (SELECT idAgence FROM agence WHERE nom = "orpi");
--Exo 14: Quels sont les logements gérés par l'agence "laforet" ? --
SELECT idLogement FROM logement_agence WHERE idAgence = (SELECT idAgence FROM agence WHERE nom = "laforet"); 
--Exo 15: Affichez le nombre de propriétaires dans la ville de Paris (Avec Alias: Nb Proprios) --
SELECT COUNT(DISTINCT idPersonne) AS 'Nb Proprio' FROM logement_personne WHERE idLogement IN (SELECT idLogement FROM logement WHERE ville = 'paris');

--Autre manière --
SELECT COUNT(DISTINCT(ip.idPersonne)) AS 'Nb proprio' FROM logement_personne ip, logement l WHERE ip.idLogement = l.idLogement AND l.ville = 'paris';
--Exo 16: Afficher les informations des trois premières personnes souhaitant acheter un logement --
SELECT * FROM personne WHERE idPersonne IN (SELECT idPersonne FROM demande WHERE categorie = 'vente') LIMIT 0,3;

--Exo 17: Afficher le prénom du vendeur pour le logement ayant la référence '5770' --
SELECT p.prenom 
FROM personne p, logement_personne lp 
WHERE p.idPersonne = lp.idPersonne
AND lp.idLogement = 5770;

--Requête imbriqué --
SELECT prenom FROM personne WHERE idPersonne = (SELECT idPersonne FROM logement_personne WHERE idLogement = 5770);
--Exo 18: Afficher les prénoms des personnes souhaitant accèder à un logement sur la ville de Lyon --
SELECT p.prenom 
FROM personne p, demande d 
WHERE p.idPersonne = d.idPersonne 
AND d.ville = 'lyon';

-- Requête imbriquée--

SELECT prenom FROM personne WHERE idPersonne IN (SELECT idPersonne FROM demande WHERE ville = 'Lyon');
--Exo 19:  Afficher les prénoms des personnes souhaitant accèder à un logement en location sur la ville de Paris--
SELECT p.prenom 
FROM personne p, demande d 
WHERE p.idPersonne = d.idPersonne 
AND d.ville = 'paris' 
AND d.categorie = 'location'; 

--Exo 20: Indiquer les frais ajoutés par l'agence immobilière pour le logement ayant la référence "5873" --
SELECT frais FROM logement_agence WHERE idLogement = 5873;

--Exo 21: Quel est le prénom du propriétaire proposant le logement le moins cher à louer? --
SELECT prenom FROM personne WHERE idPersonne IN (SELECT idPersonne FROM logement_personne WHERE idLogement 
IN (SELECT idLogement FROM logement WHERE prix IN (SELECT MIN(prix) FROM logement WHERE categorie = 'location')) );

-- Requête avec jointure --
SELECT p.prenom
FROM personne p, logement_personne lp, logement l
WHERE p.idPersonne = lp.idPersonne
AND lp.idLogement = l.idLogement
AND l.categorie = 'location';
HAVING MIN(l.prix);


-- exo 22 afficher le prenom et le ville ou se trouve la logement de chaque proprio

SELECT p.prenom,  l.ville
FROM personne p,logement l,logement_personne lp 
WHERE p.idPersonne=lp.idPersonne
AND l.idLogement=lp.idLogement;