


#####LIBRERIAS
#install.packages("DBI")
library(DBI)
#install.packages("RMySQL")
library(RMySQL)
#install.packages("Hmisc")
library(Hmisc)
##install.packages("dplyr")
library(dplyr)
##install.packages("gender")
library(gender)


setwd("~/SCI_genero")
source('./00-sql.r', encoding = 'latin1')

###Al descargar los archivos hay que descargar el registro completo ######
### Es la 3era opcion (Sin referencias)#####
###chequear conexion###
sci_ibero

####CONSULTA PARA VER LAS CANTIDADES POR PAIS
cantidades_por_pais<- dbSendQuery(sci_ibero, "select b.country, a.year, count(distinct a.ut) as cant from article a, author_address b where a.ut=b.ut group by b.country, a.year order by cant desc")
cantidades_por_pais <-  fetch(cantidades_por_pais, n=-1)
View(cantidades_por_pais)

#############TOTALES##############
author_address_gender<- dbSendQuery(sci_ibero, "select a.ut, a.order, a.name, a.surname, a.country from author_address a where country='Argentina' or country='Chile'")
author_address_gender <-  fetch(author_address_gender, n=-1)


###Extrae nombres y crea variables
author_address_gender$primer_nombre <- sapply(strsplit(author_address_gender$surname, " "), "[", 1)
author_address_gender$segundo_nombre <- sapply(strsplit(author_address_gender$surname, " "), "[", 2)

##Extrae las iniciales
author_address_gender$primera_inicial <- paste(substr(author_address_gender$primer_nombre, 1, 1),'.',sep="")
author_address_gender$segunda_inicial <- paste(substr(author_address_gender$segundo_nombre, 1, 1),'.',sep="")
author_address_gender$segunda_inicial[author_address_gender$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
listado <- as.character(rbind(author_address_gender$primer_nombre,author_address_gender$segundo_nombre))
nombres <- unique(listado)


nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####Esta tabla es la general, es el listado de todos los nombres
####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero', value=nombres_prob)
dbListTables(sci_ibero)






#####PAISES##########
country <- 'Argentina'
argentina_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Argentina' group by a.year, b.country")
argentina_total <-  fetch(argentina_total, n=-1)

argentina_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Argentina'")
argentina_total <-  fetch(argentina_total, n=-1)

###Extrae nombres y crea variables
argentina_total$primer_nombre <- sapply(strsplit(argentina_total$name, " "), "[", 1)
argentina_total$segundo_nombre <- sapply(strsplit(argentina_total$name, " "), "[", 2)


##Extrae las iniciales
argentina_total$primera_inicial <- paste(substr(argentina_total$primer_nombre, 1, 1),'.',sep="")
argentina_total$segunda_inicial <- paste(substr(argentina_total$segundo_nombre, 1, 1),'.',sep="")
argentina_total$segunda_inicial[argentina_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(argentina_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
argentina_total_genero <- left_join(argentina_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
argentina_total_genero_red <- argentina_total_genero[c(2,4,5,6,7,8,9,10,12)]
argentina_total_genero_red <- unique(argentina_total_genero_red )




####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_argentina', value=argentina_total_genero)
dbListTables(sci_ibero)


cantidades_argentina <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_argentina GROUP BY year, gender")
cantidades_argentina <-  fetch(cantidades_argentina, n=-1)
cantidades_argentina

###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_argentina_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_argentina WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_argentina_con_autor <-  fetch(cantidades_argentina_con_autor, n=-1)
cantidades_argentina_con_autor






#####PAISES##########
country <- 'chile'
chile_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Chile' group by a.year, b.country")
chile_total <-  fetch(chile_total, n=-1)

chile_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Chile'")
chile_total <-  fetch(chile_total, n=-1)

###Extrae nombres y crea variables
chile_total$primer_nombre <- sapply(strsplit(chile_total$name, " "), "[", 1)
chile_total$segundo_nombre <- sapply(strsplit(chile_total$name, " "), "[", 2)

##Extrae las iniciales
chile_total$primera_inicial <- paste(substr(chile_total$primer_nombre, 1, 1),'.',sep="")
chile_total$segunda_inicial <- paste(substr(chile_total$segundo_nombre, 1, 1),'.',sep="")
chile_total$segunda_inicial[chile_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(chile_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
chile_total_genero <- left_join(chile_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
chile_total_genero_red <- chile_total_genero[c(2,4,5,6,7,8,9,10,12)]
chile_total_genero_red <- unique(chile_total_genero_red )

###Tablas resumen
table(chile_total_genero_red$gender, chile_total_genero_red$year)



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_chile', value=chile_total_genero)
dbListTables(sci_ibero)

cantidades_chile <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_chile GROUP BY year, gender")
cantidades_chile <-  fetch(cantidades_chile, n=-1)
cantidades_chile


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_chile_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_chile WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_chile_con_autor <-  fetch(cantidades_chile_con_autor, n=-1)
cantidades_chile_con_autor






#####PAISES##########
country <- 'uruguay'
uruguay_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Uruguay' group by a.year, b.country")
uruguay_total <-  fetch(uruguay_total, n=-1)

uruguay_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Uruguay'")
uruguay_total <-  fetch(uruguay_total, n=-1)

###Extrae nombres y crea variables
uruguay_total$primer_nombre <- sapply(strsplit(uruguay_total$name, " "), "[", 1)
uruguay_total$segundo_nombre <- sapply(strsplit(uruguay_total$name, " "), "[", 2)

##Extrae las iniciales
uruguay_total$primera_inicial <- paste(substr(uruguay_total$primer_nombre, 1, 1),'.',sep="")
uruguay_total$segunda_inicial <- paste(substr(uruguay_total$segundo_nombre, 1, 1),'.',sep="")
uruguay_total$segunda_inicial[uruguay_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(uruguay_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
uruguay_total_genero <- left_join(uruguay_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
uruguay_total_genero_red <- uruguay_total_genero[c(2,4,5,6,7,8,9,10,12)]
uruguay_total_genero_red <- unique(uruguay_total_genero_red )

###Tablas resumen
table(uruguay_total_genero_red$gender, uruguay_total_genero_red$year)



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_uruguay', value=uruguay_total_genero)
dbListTables(sci_ibero)

cantidades_uruguay <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_uruguay GROUP BY year, gender")
cantidades_uruguay <-  fetch(cantidades_uruguay, n=-1)
cantidades_uruguay


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_uruguay_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_uruguay WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_uruguay_con_autor <-  fetch(cantidades_uruguay_con_autor, n=-1)
cantidades_uruguay_con_autor
















#####PAISES##########
country <- 'paraguay'
paraguay_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Paraguay' group by a.year, b.country")
paraguay_total <-  fetch(paraguay_total, n=-1)

paraguay_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Paraguay'")
paraguay_total <-  fetch(paraguay_total, n=-1)

###Extrae nombres y crea variables
paraguay_total$primer_nombre <- sapply(strsplit(paraguay_total$name, " "), "[", 1)
paraguay_total$segundo_nombre <- sapply(strsplit(paraguay_total$name, " "), "[", 2)

##Extrae las iniciales
paraguay_total$primera_inicial <- paste(substr(paraguay_total$primer_nombre, 1, 1),'.',sep="")
paraguay_total$segunda_inicial <- paste(substr(paraguay_total$segundo_nombre, 1, 1),'.',sep="")
paraguay_total$segunda_inicial[paraguay_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(paraguay_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
paraguay_total_genero <- left_join(paraguay_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
paraguay_total_genero_red <- paraguay_total_genero[c(2,4,5,6,7,8,9,10,12)]
paraguay_total_genero_red <- unique(paraguay_total_genero_red )

###Tablas resumen
table(paraguay_total_genero_red$gender, paraguay_total_genero_red$year)



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_paraguay', value=paraguay_total_genero)
dbListTables(sci_ibero)

cantidades_paraguay <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_paraguay GROUP BY year, gender")
cantidades_paraguay <-  fetch(cantidades_paraguay, n=-1)
cantidades_paraguay


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_paraguay_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_paraguay WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_paraguay_con_autor <-  fetch(cantidades_paraguay_con_autor, n=-1)
cantidades_paraguay_con_autor









