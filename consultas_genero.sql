
###AGREGA LOS CAMPOS####
ALTER TABLE author_address2 add first_name varchar(100)
ALTER TABLE author_address2 add second_name varchar(100)


UPDATE author_address2
SET first_name = SUBSTRING_INDEX(surname, ' ', 1);

UPDATE author_address2
SET second_name = SUBSTRING_INDEX(surname, ' ', -1);


