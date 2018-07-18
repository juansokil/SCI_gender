-- -------------------------------------
-- RESUMEN

-- Se desduplican autores por cambios en las firmas seg�n el siguiente criterio:

-- Coincide el apellido y todas las iniciales en los casos en que tiene m�s de una
-- Coincide el apellido, el �rea disciplinar y la inicial (s�lo tiene una inicial)

-- Crea una tabla de autorXut (con el autor desduplicado) para medir productividad.
-- Crea una tabla de autorXinst en la que puede variar la instituci�n por a�o.
-- -------------------------------------


-- Normaliza los apellidos e iniciales (may�sculas, trimea, elimina acentos, �. reemplaza " " por - para apellidos compuestos y elimina ".")


update author_address
set surname=upper(surname);

update author_address
set surname=TRIM(surname);

update author_address set surname = replace(surname,'�','A');
update author_address set surname = replace(surname,'�','E');
update author_address set surname = replace(surname,'�','I');
update author_address set surname = replace(surname,'�','O');
update author_address set surname = replace(surname,'�','U');
update author_address set surname = replace(surname,'�','U');
update author_address set surname = replace(surname,'�','N');
update author_address set surname = replace(surname,' ','-');
update author_address set surname = replace(surname,'.','');

update author_address
set name=upper(name);

update author_address
set name=TRIM(name);

update author_address set name = replace(name,'.','');

update author_address set name = replace(name,' ','');



-- Crea name1 para la primera inicial, permitiendo comparar con los casos en que tiene firma s�lo una inicial.

ALTER TABLE author_address
ADD name1 VARCHAR(1);

update author_address
set name1=left(name,1);


-- Trae datos adicionales de author_addresss a la tabla authorXinstition (surname, name, name1)
ALTER TABLE authorXinstitution 
ADD surname text;

ALTER TABLE authorXinstitution
ADD name1 text;

update authorXinstitution, author_address
set authorXinstitution.surname=author_address.surname, authorXinstitution.name1=author_address.name1
where authorXinstitution.ut=author_address.ut and authorXinstitution.order=author_address.order;


ALTER TABLE authorXinstitution
ADD name text;

update authorXinstitution, author_address
set authorXinstitution.name=author_address.name
where authorXinstitution.ut=author_address.ut and authorXinstitution.order=author_address.order;


-- Trae el �rea a authorXinstitution

ALTER TABLE authorXinstitution
ADD area_desc VARCHAR(255);

update authorXinstitution, article, scopus.discXrevista
set authorXinstitution.area_desc=scopus.discXrevista.area_desc
where authorXinstitution.ut=article.ut and article.pub_issn=scopus.discXrevista.issn;




-- Crea la tabla autores (�nicos para contar despu�s la productividad)  y dos tablas temporales iguales

create table autores
(surname varchar(255), name varchar(10), name1 varchar(1), inst_id int(11), address varchar(255), area_desc varchar(100));

create table temp_autores
(surname varchar(255), name varchar(10), name1 varchar(1), inst_id int(11), address varchar(255), area_desc varchar(100));

create table temp2_autores
(surname varchar(255), name varchar(10), name1 varchar(1), inst_id int(11), address varchar(255), area_desc varchar(100), clave varchar(255));


-- 1� INSERT

-- Inserta en autores a los que cumplen la condici�n: igual apellido, igual inicial, tienen m�s de una inicial.

insert into autores (surname, name, name1, inst_id, address, area_desc)
select surname, name, name1, min(inst_id), min(address), min(area_desc)
from `authorXinstitution`
group by surname, name, `name1`
having name<>name1;


-- 2� INSERT

-- Inserta en temp_autores a los que cumplen la condici�n: igual apellido, igual �rea, igual inicial, no tienen m�s de una inicial.

insert into temp_autores (surname, name, name1, inst_id, address, area_desc)
select surname, name, name1, min(inst_id), min(address), area_desc
from `authorXinstitution`
group by surname, name, `name1`, area_desc
having name=name1;


-- Inserta en temp2_autores los datos temp_autores sin duplicaciones, eligiendo el m�nimo de instituci�n y de �rea.

insert into temp2_autores (surname, name, name1, inst_id, address, area_desc)
select surname, name, name1, inst_id, min(address), min(area_desc)
from `temp_autores`
group by surname, name, `name1`, inst_id;


-- La tabla temp_insert_autores genera una clave �nica para cada uno a partir del concatenado del apellido, la primera inicial y el id de instituci�n de la tabla autores. Es clave primaria, para evitar duplicaciones.




create table temp_insert_autores 
(clave varchar(255));


insert ignore into temp_insert_autores
select concat(surname,name1,inst_id)
from autores;


-- Crea una clave equivalente en temp2_autores

update temp2_autores
set clave=concat(surname,name1,inst_id);


-- Inserta en autores desde temp2_autores a los que tengan una clave que a�n no est� en autores (evita duplicaciones)

insert into autores (surname, name, name1, inst_id, address, area_desc)
select surname, name, name1, inst_id, address, area_desc
from temp2_autores
where clave not in (select clave from temp_insert_autores);


-- TERMINAN LOS INSERTS

-- Le inventa un ID autom�tico a los sutores
ALTER TABLE  `autores` ADD  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ;









-- LLENA LA TABLA autorXut para medir productividad. Incluye el id �nico de autor y los ut que tienen asignado el mismo apellido, iniciales e instituci�n en authorXinstitution





create table autorXut 
(id int(11), surname varchar(255), ut varchar(255));


ALTER TABLE  `authorXinstitution` CHANGE  `name`  `name` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ;
ALTER TABLE  `authorXinstitution` CHANGE  `surname`  `surname` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ;
ALTER TABLE  `authorXinstitution` ADD INDEX (  `inst_id` ,  `name` ,  `surname` ) ;


insert ignore into autorXut
select id, a.surname, ut
from autores a, authorXinstitution b
where a.surname=b.surname and a.name=b.name and a.inst_id=b.inst_id;


-- LLENA LA TABLA autorXinst que incluye apellido, iniciales e instituci�n de cada autor en cada a�o. Porque los autores cambian de instituci�n.


create table autorXinst 
(id int(11), surname varchar(255),  name varchar(255), inst_id int(11), inst_name varchar(255), year int(11));


insert into autorXinst
select distinct a.id, a.surname, a.name, c.inst_id, c.inst_name, d.year
from autores a, autorXut b, authorXinstitution c, article d
where a.id=b.id and b.ut=c.ut and b.ut=d.ut and b.surname=c.surname;


