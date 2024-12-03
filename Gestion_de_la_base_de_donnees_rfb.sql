create database rfb;
use rfb;

create table clientsa (
no_client int not null check (no_client > 10),
nom varchar(50) not null,
prenom varchar(50) not null ,
adresse varchar(50) not null,
Primary key (no_client)

);

create table produitsa (
`reference` varchar(50) not null check (`reference` like 'DT___'  ),
designation varchar(50) not null,
prixht float not null,
primary key (`reference`)
);

create table facturesa (
no_facture int not null auto_increment,
date_facture date not null,
Etat varchar(50) not null default 'C' check (Etat in ('R', 'C')),
primary key (no_facture)
);

create table interventions(
no_interv int not null auto_increment,
date_interv date not null,
nom_resp varchar(50) not null,
nom_interv varchar(50) not null,
temps float not null check (temps between 0.1 and 8),
no_client int not null,
no_facture int not null,
primary key  (no_interv),
constraint fk_interventions_clientsa foreign key (no_client)
references clientsa (no_client),
constraint fk_interventions_facturesa foreign key (no_facture)
references facturesa (no_facture)
);

create table remplacements(
`reference` varchar(50) check (`reference` like 'DT___'  ),
no_interv int not null,
qte_remplacee int not null,
constraint fk_remplacements_produitsa foreign key (`reference`)
references produitsa (`reference`),
constraint fk_remplacements_interventions foreign key (no_interv)
references interventions (no_interv)

);



-- Exercice 7. 
-- On désire ajouter la ville, le code postal et le téléphone pour chaque client. 
-- Ajoutez ces trois attributs dans la table CLIENTS, sachant que le numéro de téléphone est 
-- composé d’exactement 14 caractères de format XX-XX-XX-XX-XX. Faites-le en utilisant 
-- des requêtes de modification de table.
alter table clientsa add ville varchar(50);
alter table clientsa add code_postal varchar(50);
alter table clientsa add telephone varchar(50);


-- Exercice 8. Rajoutez la contrainte suivante sur la table : aucun des trois attributs 
-- supplémentaires ville, code postal ni téléphone ne peuvent être nuls. Que se passe-t-il ?

alter table clientsa modify ville varchar(50) not null;
alter table clientsa modify code_postal varchar(50) not null;
alter table clientsa modify telephone varchar(50) not null;
-- le code ne marche pas, il faut rajouter le prénom not null également
-- pour que ça marche





INSERT INTO clientsa (no_client, nom, prenom, adresse, ville, code_postal, telephone) VALUES
(105, 'Dallalon', 'Jean', '5 rue Jean Moulin', 'Orleans','45000', '0657879876'),
(101, 'Rivoire', 'Marie', '18 Rue Ronde','Taverny','95150', '0656870965'),
(102, 'Favero', 'André', '43 Rue Beaujolais','Paris','75016', '0765890843'),
(103, 'Provent', 'Catherine', '38 Rue du stade','Toulouse','31100', '0634567898'),
(104, 'Labric', 'Catherine', '35 Rue des fleurs','Cergy','95800', '0786950463');


INSERT INTO produitsa (reference, designation, prixht) VALUES
('DT010', 'Disjoncteur 10A', 7.21),
('DT180', 'Bloc Huger', 5.12),
('DT802', 'Boîte contrôle', 58.35),
('DT711', 'Cellule', 25.36),
('DT125', 'Bloc soc', 5.89),
('DT015', 'Disjoncteur 15A', 14.94),
('DT205', 'Brûleur Huger', 153.37),
('DT310', 'Brûleur soc', 200.20),
('DT120', 'Connecteur', 20.35);


INSERT INTO facturesa (no_facture, date_facture, Etat) VALUES
(1000, '2009-01-01', 'R'),
(1001, '2009-02-12', 'R'),
(1002, '2009-03-17', 'R'),
(1003, '2009-04-24', 'R'),
(1004, '2009-05-16', 'R'),
(1005, '2009-08-07', 'R'),
(1006, '2009-08-07', 'R'),
(1008, '2009-07-22', 'R'),
(1012, '2009-08-07', 'C'),
(1013, '2009-10-19', 'C');

INSERT INTO interventions (no_interv, date_interv, nom_resp, nom_interv, temps, no_client, no_facture) VALUES
(1039, '2009-02-10', 'Mauras', 'Sautier', 1, 101, 1001),
(1040, '2009-03-10', 'Mauras', 'Sautier', 1, 103, 1002),
(1041, '2009-03-15', 'Foucher', 'Sautier', 2, 103, 1002),
(1042, '2009-04-06', 'Foucher', 'Sautier', 1.5, 105, 1005),
(1043, '2009-03-07', 'Mauras', 'Bonnaz', 0.5, 105, 1008),
(1044, '2009-05-16', 'Mauras', 'Crespin', 1.5, 104, 1004),
(1045, '2009-07-15', 'Foucher', 'Sautier', 2.5, 104, 1012),
(1046, '2009-07-22', 'Mauras', 'Bonnaz', 1.5, 105, 1013),
(1047, '2009-07-29', 'Mauras', 'Bonnaz', 1.5, 105, 1013),
(1052, '2009-07-29', 'Mauras', 'Bonnaz', 1.5, 105, 1013);

INSERT INTO remplacements (reference, no_interv, qte_remplacee) VALUES
('DT802', 1043, 1),
('DT711', 1043, 2),
('DT180', 1043, 1),
('DT205', 1044, 1),
('DT125', 1044, 1),
('DT015', 1045, 1),
('DT310', 1045, 2),
('DT711', 1047, 4),
('DT120', 1052, 3),
('DT120', 1052, 3);










-- Exercice 11. Référence et désignation des produits dont le prix est supérieur à 50 euros. 
select reference, designation from produitsa where prixht>50;

-- Exercice 12. Numéro, date et temps passé des interventions effectuées par Crespin. 
select no_interv, date_interv, temps from interventions where nom_interv='Crespin';

-- Exercice 13. Nom, prénom et numéro de téléphone des clients, triés par ordre alphabétique croissant. 
select prenom, telephone from clientsa order by prenom asc;

-- Exercice 14. Numéro et date des factures réglées triées par ordre décroissant. 
select no_facture, date_facture from facturesa order by no_facture desc;

-- Exercice 15. Désignation des produits dont la différence entre quantité en stock et quantité de 
-- sécurité est comprise dans l’intervalle [1;10]. 

-- Exercice 16. Référence et désignation des produits dont la référence se termine par le chiffre 1.
select `reference`, designation from produitsa where reference like '%1';

-- Exercice 17. Référence des produits remplacés au moins 2 fois lors de la même intervention, 
-- triées par ordre croissant. Chaque produit ne doit apparaitre qu’une fois. 

select distinct `reference`, no_interv from remplacements where qte_remplacee > 2 order by no_interv asc;

-- Exercice 18. Nom du client, nom de l’intervenant et date de l’intervention pour toutes les 
-- interventions. 

select nom_resp, nom_interv, date_interv from interventions;

-- Exercice 19. Numéro et date des interventions relatives à la facture réglée le 15/07/2009.
select no_interv, date_interv from interventions join facturesa on interventions.no_facture=facturesa.no_facture
where date_facture='2009-07-15';

-- Exercice 20. Numéro des factures affectées au client Rivoire. 
select no_facture from interventions join clientsa on interventions.no_client=clientsa.no_client
where prenom='Rivoire';

-- Exercice 21. Désignation des produits remplacés lors de l’intervention du 03/07/2009.  
select designation from produitsa join remplacements on produitsa.`reference`=remplacements.`reference`
join interventions on remplacements.no_interv=interventions.no_interv 
where date_interv='2009-07-03';

-- Exercice 22. Numéro des factures non réglées, en ordre croissant, et nom du client correspondant. 
select f.no_facture, nom from facturesa f join interventions on f.no_facture=interventions.no_facture
join clientsa on interventions.no_client=clientsa.no_client
where f.Etat='C' order by f.no_facture asc;

-- Exercice 23. Date des factures intégrant le remplacement de Bruleurs, et pour lesquelles 
-- l’intervenant est Saultier. Gérez la casse (minuscules et majuscules). 

select date_facture from facturesa join interventions on facturesa.no_facture=interventions.no_facture
where nom_resp='Bruleurs' and nom_interv='Saultier';

-- Exercice 24. Désignations des produits remplacés pour le client Provent.  

select designation from produitsa join remplacements on produitsa.`reference`=remplacements.`reference`
join interventions on remplacements.no_interv=interventions.no_interv
where nom_resp='Provent';

-- Exercice 25. Numéro des clients chez lesquels Saultier est intervenu mais pas Bonnaz. 

select no_client from interventions where nom_interv='Saultier'and no_client not in (select no_client from interventions where 
nom_interv='Bonnaz');


-- Exercice 26. Numéro et date des factures réglées du client Rivoire, avec en plus numéro et date 
-- des factures en cours du client Dallalon. 
select f.no_facture, date_facture from facturesa f join interventions on f.no_facture=interventions.no_facture
join clientsa on interventions.no_client=clientsa.no_client
where nom='Rivoire' and Etat='R'
union
select f.no_facture, date_facture from facturesa f join interventions on f.no_facture=interventions.no_facture
join clientsa on interventions.no_client=clientsa.no_client
where prenom='Dallalon' and Etat='C';



-- ----------------------------------------------------------------------------------------------------------
-- Ecrire les requêtes SQL demandées en utilisant la base suivante (il n’est pas nécessaire de créer la 
-- base) : 

-- Membre (NumBuveur, NomB, PrenomB, VilleB)  
-- Viticulteur (NumVitic, NomV, PrenomV, VilleV)  
-- Vin (NumVin, Cru, Millesime, Region, NumVitic#) 
-- Commande (NumCom, NumBuveur#, NumVin#, QtteCommandee, DateCom) 

-- Exercice 27. Liste des régions avec son nom et le nombre de vins produits ; 
select Region, count(*) from Vin 
group by Region; 

-- Exercice 28. Pour chaque membre de Paris, nom, le numéro et la quantité moyenne 
-- commandée ; 

select NomB, NumBuveur, avg(QtteCommandee) from Membre join Commande on Membre.NomBuveur=Commande.NomBuveur 
where VilleB='Paris';

-- Exercice 29. Les vins (numéro, cru, nombre de commandes) ayant été commandés au moins deux fois.
select NumVin, Cru, Count(*) from Vin join Commande on Vin.NumVin=Commande.NumVin 
where QtteCommandee>=2
group by numVin, Cru; 



