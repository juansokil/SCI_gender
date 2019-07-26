
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
ALTER TABLE author_address ADD COLUMN name_complete text;
ALTER TABLE author_address ADD COLUMN author_id int (22);

#####Hace un update con el concat####
UPDATE author_address SET name_complete = CONCAT(surname, ' ', name);



