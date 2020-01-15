
########################articleXinstitution########################

#####Estas son las actualizaciones manuales que hay que hacer tras ejecutar el clasificador#####
UPDATE articleXinstitution SET inst_id=1004 WHERE inst_id=9999 and address like '%Universidad Nacional de Cuyo%'
UPDATE articleXinstitution SET inst_id=1023 WHERE inst_id=9999 and address like '%Universidad National de Rosario%'
UPDATE articleXinstitution SET inst_id=1023 WHERE inst_id=9999 and address like '%Rosario National University%'

#####Esto le pega las etiquetas#####
UPDATE articleXinstitution t1 
INNER JOIN institution_search t2 
ON t1.inst_id = t2.inst_id
SET t1.inst_name = t2.inst_name 
WHERE t1.inst_id = t2.inst_id





########################authors########
#####crea una nueva variable en la tabla author_adress con el nombre completo#####
ALTER TABLE author_address ADD COLUMN author_id int (32);



#####Hace un update con el concat, pasa a mayusculas####
UPDATE author_address SET name_complete = TRIM(UPPER(CONCAT(surname, ' ', name))) WHERE name_complete is null;
UPDATE author SET name_complete = TRIM(UPPER(name)) where name_complete is null;

UPDATE author SET name = TRIM(UPPER(name));





#################ACTUALIZA DATOS########################

#####Esto trae los id#####
UPDATE scopus_ibero.author t1 
INNER JOIN scopus_id.author t2 
ON t1.name = t2.name and t1.ut = t2.ut
SET t1.author_id = t2.author_id 
WHERE (t1.name = t2.name and t1.ut = t2.ut);


#####Esto actualiza la tabla author_address#####
UPDATE author_address t1 
INNER JOIN author t2 
ON (t1.name_complete = t2.name and t1.ut=t2.ut)
SET t1.author_id = t2.author_id 
WHERE t1.author_id is null and t1.name_complete = t2.name and t1.ut=t2.ut;












#####DESDE R - ARMA LA CANTIDAD DE PUBLICACIONES POR INSTITUCION#####
#### POR LO QUE ESTUVE VIENDO SCOPUS AUMENTA LA CANTIDAD DE PUBLICACIONES DE UNR - LAS MEZCLA CON CORDOBA.. CHEQUEAR####

library(dplyr)
library(tidyr)

articleXinstitution_inst <- dbSendQuery(scopus_ibero, "SELECT year, inst_id, inst_name, count(distinct ut) as cant FROM `articleXinstitution` group by year, inst_id, inst_name")
articleXinstitution_inst <-  fetch(articleXinstitution_inst, n=-1)

articleXinstitution_totales <- dbSendQuery(scopus_ibero, "SELECT year, count(distinct ut) as cant FROM `articleXinstitution` group by year")
articleXinstitution_totales <-  fetch(articleXinstitution_totales, n=-1)


data_wide_inst <- spread(articleXinstitution_inst, year, cant)
data_wide_total <- spread(articleXinstitution_totales, year, cant)

dd <- data_wide_inst %>%
  filter(inst_id == 0 | (inst_id >= 1000 & inst_id <= 2000 ))

View(dd)
