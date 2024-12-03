create database fb;
use fb;

create table `client` (
    numcli varchar(50),
    nomcli varchar(50) not null,
    adressecli varchar(50),
    Primary key (numcli)
    
);

create table facture(
    numfact varchar(50),
    datefact date not null,
    numcli varchar(50) not null,
	Primary key (numfact),
    constraint fk_facture_client foreign key (numcli)
references `client` (numcli)
);


create table produit (
    refprod varchar(50),
    desigprod varchar(50) not null,
    prixprod float not null,
    Primary key (refprod)
);

create table ligne_facture (
    numfact varchar(50),
    refprod varchar(50),
    quantite int not null,
    primary key (numfact, refprod),
    foreign key (numfact) references facture(numfact),
    foreign key (refprod) references produit(refprod)
);

-- ////////////////////////// REMPLISSAGE DES TABLES //////////////////////////

insert into `client`(numcli, nomcli, adressecli) values ('C1', 'Ali', 'Tunis'),
('C2', 'Ahmed', 'Tunis'),
('C3', 'Majdi', 'Nabeul'),
('C4', 'Imen', 'Sfax');

insert into facture (numfact, datefact, numcli) values 
('F1', str_to_date('14/10/06', '%d/%m/%Y' ),'C3'),
('F2', str_to_date('14/10/06', '%d/%m/%Y' ),'C1'),
('F3', str_to_date('16/10/06', '%d/%m/%Y' ),'C2'),
('F4', str_to_date('21/10/06', '%d/%m/%Y' ),'C3'),
('F5', str_to_date('21/10/06', '%d/%m/%Y' ),'C1');

insert into produit (refprod, desigprod, prixprod) values 
(1, 'creme hydratante', 22.10 ),
(2, 'soint des levres', 14.69),
(3, 'café expresso', 4.26),
(4, 'lessive', 8.48),
(5, 'chocolat noir', 2.56),
(6, 'riz long', 11.66);

insert into ligne_facture (numfact,refprod,quantite) values
('F1', 1,10),
('F1', 2, 7),
('F1', 3, 5),
('F2', 4, 10),
('F2', 5, 20),
('F3', 6, 15),
('F3', 3, 3),
('F4', 5, 4),
('F5', 3, 8);

-- //////////////////////// REQUETES SQL /////////////////////////////

-- 1/ Afficher les adresses des clients.
select adressecli from `client`;

-- 2/ Afficher tous les produits
select refprod from produit;

-- 3/ Afficher les numéros, noms et prix de l’ensemble des produits dont 
-- le prix est inférieur ou égal à 10 DT.
select * from produit where prixprod <=10;
-- 4/ Afficher la liste des articles (noms et numéros) de la facture « F3 »
select p.refprod,desigprod from produit as p join ligne_facture as l on
p.refprod=l.refprod where numfact='F3';

-- 5/ Afficher les produits achetés par le client « Ali»
select nomcli, desigprod from `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where nomcli='Ali';

-- 6/ Afficher les produits non achetés par le client « Ali »
select desigprod from produit where desigprod NOT IN (
select desigprod from `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where nomcli='Ali');


-- 7/ Afficher les produits achetés par les clients « Ali » et « Ahmed »
select desigprod from `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where nomcli='Ali' and desigprod in 
( select desigprod from `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where nomcli='Ahmed');
 
 
 -- 8/Afficher les produits achetés par « Ali » et non achetés par « Ahmed »
 select desigprod from `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where nomcli='Ali' and desigprod not in 
( select desigprod from `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where nomcli='Ahmed');

-- 9/ Afficher les produits non achetés par aucun client
select desigprod from  `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod and desigprod not in
(
select distinct desigprod from  `client`
as c join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod where c.nomcli in ('Ali', 'Ahmed', 'Majdi', 'Imen')

);
-- ou
select p.desigprod from produit as p left join ligne_facture as l 
on p.refprod=l.refprod where p.refprod is null;

-- 10/Afficher les clients qui non pas de factures
select c.nomcli from `client` as c left join facture as f on c.numcli=f.numcli
where f.numfact is null; 

-- 11/Afficher les clients qui ont des factures entre 13/10/06 et 18/10/06
select c.nomcli from `client` as c join facture as f on c.numcli=f.numcli
where f.datefact between '2006-10-13' and '2006-10-18';

-- 12/ Modifier la quantité du produit 3 de la facture F5 de 8 à 10 unités
update ligne_facture set quantite=10 where numfact='F5' and refprod=3;

-- 13/ Augmenter de 3% le prix de tous les produits
set sql_safe_updates=0;

update produit set prixprod=prixprod +  (prixprod*3/100);

set sql_safe_updates=1;

-- 14/Afficher tous les produits du mois cher au plus cher
select desigprod,prixprod from produit order by prixprod asc;

-- 15/Afficher tous les produits contenant ou commençant par 'ca'
select desigprod from produit where desigprod like '%ca%'
or refprod like 'ca%';

-- 16/Quel est le prix moyen des articles proposés
select avg(prixprod) from produit ;

-- 17/ Afficher les totaux des factures par client 
select nomcli, sum(prixprod) from `client` as c 
join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod group by nomcli;

-- 18/Afficher les totaux des factures par date
select datefact, sum(prixprod) from `client` as c 
join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod group by datefact;


-- 19/. Afficher les clients qui ont achetés des produits d’un montant 
-- supérieur à 200 DT.
select nomcli, sum(prixprod) as sm from `client` as c 
join facture as f on c.numcli=f.numcli
join ligne_facture as l on f.numfact=l.numfact
join produit as p on l.refprod=p.refprod group by nomcli
having sm>2;











