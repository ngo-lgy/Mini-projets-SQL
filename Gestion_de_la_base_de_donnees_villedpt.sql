create table villedpt;
use villedpt;

-- 1/ Obtenir la liste des 10 villes les plus peuplées en 2012
select ville_nom from ville order by ville_population_2012 desc limit 10;

-- 2/ Obtenir la liste des 50 villes ayant la plus faible superficie
select ville_nom from ville order by ville_surface asc limit 50;

select * from departement;
-- 3/ Obtenir la liste des départements d’outres-mer, c’est-à-dire ceux dont le numéro de département commencent par “97
select departement_nom from departement where departement_code like '%97%';

-- 4/ Obtenir le nom des 10 villes les plus peuplées en 2012, ainsi que le nom du département associé
select ville_nom, departement_nom from ville join departement on ville.ville_departement=departement.departement_code order by
 ville_population_2012 desc limit 10;
 
 -- 5/Obtenir la liste du nom de chaque département, associé à son code et du nombre de commune au sein de ces département, en triant afin 
 -- d’obtenir en priorité les départements qui possèdent le plus de communes
 
 select distinct departement_nom, departement_code, count(*) as nbre_communes from departement join ville on 
 departement.departement_code=ville.ville_departement group by departement_nom,departement_code  order by nbre_communes desc;
 
-- 6/ Obtenir la liste des 10 plus grands départements, en terme de superficie
select distinct departement_nom,departement_code, sum(ville_surface) as superficie_dept from departement join ville on
 departement.departement_code=ville.ville_departement group by departement_nom,departement_code order by superficie_dept desc  ;
 
 -- 7/ Compter le nombre de villes dont le nom commence par “Saint”
select count(*) from ville where ville_nom like 'Saint%';

-- 8/ Obtenir la liste des villes qui ont un nom existants plusieurs fois, et trier afin d’obtenir en premier 
-- celles dont le nom est le plus souvent utilisé par plusieurs communes
select ville_nom, count(ville_nom) as occ_v from ville group by ville_nom
having count(ville_nom)>1 order by occ_v desc;

-- 9/ Obtenir en une seule requête SQL la liste des villes dont la superficie est supérieur à la superficie moyenne
select ville_nom from ville where ville_surface > (select avg(ville_surface) from ville);

-- 10/ Obtenir la liste des départements qui possèdent plus de 2 millions d’habitants
select departement_nom, sum(ville_population_2012) as pop_dept from departement join ville on 
departement.departement_code=ville.ville_departement group by departement_nom
having pop_dept>2000000;

-- 11/ Remplacez les tirets par un espace vide, pour toutes les villes commençant par “SAINT-” 
-- (dans la colonne qui contient les noms en majuscule)
update ville set ville_nom=replace(ville_nom,'-',' ') where ville_nom like 'SAINT-%';



