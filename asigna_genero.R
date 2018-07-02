


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
author_address_gender<- dbSendQuery(sci_ibero, "select a.ut, a.order, a.name, a.surname, a.country from author_address a where country='Argentina' or country='Chile' or country='Uruguay' or country='Paraguay' or country='Peru' or country='Brazil'")
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
dbWriteTable(sci_ibero, name='temp_genero', value=nombres_prob)
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
dbWriteTable(sci_ibero, name='TEMP_genero_argentina', value=argentina_total_genero)
dbListTables(sci_ibero)


cantidades_argentina <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_argentina GROUP BY year, gender")
cantidades_argentina <-  fetch(cantidades_argentina, n=-1)
cantidades_argentina

cantidades_genero_argentina <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_argentina GROUP BY year, gender")
cantidades_genero_argentina <-  fetch(cantidades_genero_argentina, n=-1)
cantidades_genero_argentina


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_argentina_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_argentina WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_argentina_con_autor <-  fetch(cantidades_argentina_con_autor, n=-1)
cantidades_argentina_con_autor


#####PAISES##########
country <- 'mexico'
mexico_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Mexico' group by a.year, b.country")
mexico_total <-  fetch(mexico_total, n=-1)

mexico_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Mexico'")
mexico_total <-  fetch(mexico_total, n=-1)

###Extrae nombres y crea variables
mexico_total$primer_nombre <- sapply(strsplit(mexico_total$name, " "), "[", 1)
mexico_total$segundo_nombre <- sapply(strsplit(mexico_total$name, " "), "[", 2)


##Extrae las iniciales
mexico_total$primera_inicial <- paste(substr(mexico_total$primer_nombre, 1, 1),'.',sep="")
mexico_total$segunda_inicial <- paste(substr(mexico_total$segundo_nombre, 1, 1),'.',sep="")
mexico_total$segunda_inicial[mexico_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(mexico_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
mexico_total_genero <- left_join(mexico_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
mexico_total_genero_red <- mexico_total_genero[c(2,4,5,6,7,8,9,10,12)]
mexico_total_genero_red <- unique(mexico_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_mexico', value=mexico_total_genero)
dbListTables(sci_ibero)


cantidades_mexico <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_mexico GROUP BY year, gender")
cantidades_mexico <-  fetch(cantidades_mexico, n=-1)
cantidades_mexico

cantidades_genero_mexico <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_mexico GROUP BY year, gender")
cantidades_genero_mexico <-  fetch(cantidades_genero_mexico, n=-1)
cantidades_genero_mexico


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_mexico_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_mexico WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_mexico_con_autor <-  fetch(cantidades_mexico_con_autor, n=-1)
cantidades_mexico_con_autor









#####PAISES##########
country <- 'brazil'
brazil_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Brazil' group by a.year, b.country")
brazil_total <-  fetch(brazil_total, n=-1)

brazil_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Brazil'")
brazil_total <-  fetch(brazil_total, n=-1)

###Extrae nombres y crea variables
brazil_total$primer_nombre <- sapply(strsplit(brazil_total$name, " "), "[", 1)
brazil_total$segundo_nombre <- sapply(strsplit(brazil_total$name, " "), "[", 2)


##Extrae las iniciales
brazil_total$primera_inicial <- paste(substr(brazil_total$primer_nombre, 1, 1),'.',sep="")
brazil_total$segunda_inicial <- paste(substr(brazil_total$segundo_nombre, 1, 1),'.',sep="")
brazil_total$segunda_inicial[brazil_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(brazil_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
brazil_total_genero <- left_join(brazil_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
brazil_total_genero_red <- brazil_total_genero[c(2,4,5,6,7,8,9,10,12)]
brazil_total_genero_red <- unique(brazil_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_brazil', value=brazil_total_genero)
dbListTables(sci_ibero)


cantidades_brazil <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_brazil GROUP BY year, gender")
cantidades_brazil <-  fetch(cantidades_brazil, n=-1)
cantidades_brazil

cantidades_genero_brazil <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_brazil GROUP BY year, gender")
cantidades_genero_brazil <-  fetch(cantidades_genero_brazil, n=-1)
cantidades_genero_brazil


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_brazil_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_brazil WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_brazil_con_autor <-  fetch(cantidades_brazil_con_autor, n=-1)
cantidades_brazil_con_autor















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
View(cantidades_chile)

cantidades_genero_chile <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_chile GROUP BY year, gender")
cantidades_genero_chile <-  fetch(cantidades_genero_chile, n=-1)
View(cantidades_genero_chile)

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
View(cantidades_uruguay)



cantidades_genero_uruguay <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_uruguay GROUP BY year, gender")
cantidades_genero_uruguay <-  fetch(cantidades_genero_uruguay, n=-1)
cantidades_genero_uruguay



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

cantidades_genero_paraguay <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_paraguay GROUP BY year, gender")
cantidades_genero_paraguay <-  fetch(cantidades_genero_paraguay, n=-1)
View(cantidades_genero_paraguay)


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_paraguay_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_paraguay WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_paraguay_con_autor <-  fetch(cantidades_paraguay_con_autor, n=-1)
cantidades_paraguay_con_autor










#####PAISES##########
country <- 'peru'
peru_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Peru' group by a.year, b.country")
peru_total <-  fetch(peru_total, n=-1)

peru_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Peru'")
peru_total <-  fetch(peru_total, n=-1)

###Extrae nombres y crea variables
peru_total$primer_nombre <- sapply(strsplit(peru_total$name, " "), "[", 1)
peru_total$segundo_nombre <- sapply(strsplit(peru_total$name, " "), "[", 2)

##Extrae las iniciales
peru_total$primera_inicial <- paste(substr(peru_total$primer_nombre, 1, 1),'.',sep="")
peru_total$segunda_inicial <- paste(substr(peru_total$segundo_nombre, 1, 1),'.',sep="")
peru_total$segunda_inicial[peru_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(peru_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
peru_total_genero <- left_join(peru_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
peru_total_genero_red <- peru_total_genero[c(2,4,5,6,7,8,9,10,12)]
peru_total_genero_red <- unique(peru_total_genero_red )

###Tablas resumen
table(peru_total_genero_red$gender, peru_total_genero_red$year)



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_peru', value=peru_total_genero)
dbListTables(sci_ibero)

cantidades_peru <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_peru GROUP BY year, gender")
cantidades_peru <-  fetch(cantidades_peru, n=-1)


cantidades_genero_peru <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_peru GROUP BY year, gender")
cantidades_genero_peru <-  fetch(cantidades_genero_peru, n=-1)
View(cantidades_genero_peru)


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_peru_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_peru WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_peru_con_autor <-  fetch(cantidades_peru_con_autor, n=-1)
cantidades_peru_con_autor












#####PAISES##########
country <- 'colombia'
colombia_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Colombia' group by a.year, b.country")
colombia_total <-  fetch(colombia_total, n=-1)
View(colombia_total)

colombia_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Colombia'")
colombia_total <-  fetch(colombia_total, n=-1)

###Extrae nombres y crea variables
colombia_total$primer_nombre <- sapply(strsplit(colombia_total$name, " "), "[", 1)
colombia_total$segundo_nombre <- sapply(strsplit(colombia_total$name, " "), "[", 2)

##Extrae las iniciales
colombia_total$primera_inicial <- paste(substr(colombia_total$primer_nombre, 1, 1),'.',sep="")
colombia_total$segunda_inicial <- paste(substr(colombia_total$segundo_nombre, 1, 1),'.',sep="")
colombia_total$segunda_inicial[colombia_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(colombia_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
colombia_total_genero <- left_join(colombia_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
colombia_total_genero_red <- colombia_total_genero[c(2,4,5,6,7,8,9,10,12)]
colombia_total_genero_red <- unique(colombia_total_genero_red )

###Tablas resumen
table(colombia_total_genero_red$gender, colombia_total_genero_red$year)



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_colombia', value=colombia_total_genero)
dbListTables(sci_ibero)

cantidades_colombia <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_colombia GROUP BY year, gender")
cantidades_colombia <-  fetch(cantidades_colombia, n=-1)
View(cantidades_colombia)

cantidades_genero_colombia <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_colombia GROUP BY year, gender")
cantidades_genero_colombia <-  fetch(cantidades_genero_colombia, n=-1)
View(cantidades_genero_colombia)


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_colombia_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_colombia WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_colombia_con_autor <-  fetch(cantidades_colombia_con_autor, n=-1)
cantidades_colombia_con_autor













#####PAISES##########
country <- 'mexico'
mexico_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Mexico' group by a.year, b.country")
mexico_total <-  fetch(mexico_total, n=-1)
View(mexico_total)

mexico_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Mexico'")
mexico_total <-  fetch(mexico_total, n=-1)

###Extrae nombres y crea variables
mexico_total$primer_nombre <- sapply(strsplit(mexico_total$name, " "), "[", 1)
mexico_total$segundo_nombre <- sapply(strsplit(mexico_total$name, " "), "[", 2)

##Extrae las iniciales
mexico_total$primera_inicial <- paste(substr(mexico_total$primer_nombre, 1, 1),'.',sep="")
mexico_total$segunda_inicial <- paste(substr(mexico_total$segundo_nombre, 1, 1),'.',sep="")
mexico_total$segunda_inicial[mexico_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(mexico_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
mexico_total_genero <- left_join(mexico_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
mexico_total_genero_red <- mexico_total_genero[c(2,4,5,6,7,8,9,10,12)]
mexico_total_genero_red <- unique(mexico_total_genero_red )

###Tablas resumen
table(mexico_total_genero_red$gender, mexico_total_genero_red$year)



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_mexico', value=mexico_total_genero)
dbListTables(sci_ibero)

cantidades_mexico <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM genero_mexico GROUP BY year, gender")
cantidades_mexico <-  fetch(cantidades_mexico, n=-1)
View(cantidades_mexico)

cantidades_genero_mexico <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM genero_mexico GROUP BY year, gender")
cantidades_genero_mexico <-  fetch(cantidades_genero_mexico, n=-1)
View(cantidades_genero_mexico)


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_mexico_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM genero_mexico WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_mexico_con_autor <-  fetch(cantidades_mexico_con_autor, n=-1)
cantidades_mexico_con_autor








#####PAISES##########
country <- 'cuba'
cuba_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Cuba' group by a.year, b.country")
cuba_total <-  fetch(cuba_total, n=-1)

cuba_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Cuba'")
cuba_total <-  fetch(cuba_total, n=-1)

###Extrae nombres y crea variables
cuba_total$primer_nombre <- sapply(strsplit(cuba_total$name, " "), "[", 1)
cuba_total$segundo_nombre <- sapply(strsplit(cuba_total$name, " "), "[", 2)


##Extrae las iniciales
cuba_total$primera_inicial <- paste(substr(cuba_total$primer_nombre, 1, 1),'.',sep="")
cuba_total$segunda_inicial <- paste(substr(cuba_total$segundo_nombre, 1, 1),'.',sep="")
cuba_total$segunda_inicial[cuba_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(cuba_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
cuba_total_genero <- left_join(cuba_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
cuba_total_genero_red <- cuba_total_genero[c(2,4,5,6,7,8,9,10,12)]
cuba_total_genero_red <- unique(cuba_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_cuba', value=cuba_total_genero)
dbListTables(sci_ibero)


cantidades_cuba <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_cuba GROUP BY year, gender")
cantidades_cuba <-  fetch(cantidades_cuba, n=-1)
cantidades_cuba

cantidades_genero_cuba <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_cuba GROUP BY year, gender")
cantidades_genero_cuba <-  fetch(cantidades_genero_cuba, n=-1)
cantidades_genero_cuba


###consulta####
####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_cuba_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , YEAR FROM TEMP_genero_cuba WHERE gender =  'male' OR gender =  'female' GROUP BY YEAR")
cantidades_cuba_con_autor <-  fetch(cantidades_cuba_con_autor, n=-1)
cantidades_cuba_con_autor







