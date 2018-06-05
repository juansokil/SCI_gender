
###AGREGA LOS CAMPOS####
ALTER TABLE author_address2 add first_name varchar(100)
ALTER TABLE author_address2 add second_name varchar(100)
ALTER TABLE author_address2 add first_initial varchar(3)
ALTER TABLE author_address2 add second_initial varchar(3)

UPDATE author_address2
SET first_name = SUBSTRING_INDEX(name, ' ', 1);

UPDATE author_address2
SET second_name = SUBSTRING_INDEX(name, ' ', -1);

UPDATE author_address2 
SET second_name = NULL WHERE first_name=second_name;

UPDATE author_address2
SET first_initial = concat(substring(first_name,1,1),'.');

UPDATE author_address2
SET second_initial = concat(substring(second_name,1,1),'.');

