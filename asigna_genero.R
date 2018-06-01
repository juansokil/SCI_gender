

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

###chequear conexion###
sci_ibero

###Al descargar los archivos hay que descargar el registro completo (sin referencias) - Es la 3era opcion

#############TOTALES##############
author_address_gender<- dbSendQuery(sci_ibero, "select a.ut, a.order, a.name, a.surname, a.country from author_address a where country='Argentina'")
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

nombres
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]


####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero', value=nombres_prob)
dbListTables(sci_ibero)






#####PAISES##########
country <- 'Argentina'
argentina_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Argentina' group by a.year, b.country")
argentina_total <-  fetch(argentina_total, n=-1)


argentina_total <- dbSendQuery(sci_ibero, "select a.ut, a.order, a.name, a.surname, a.country from author_address a where country='Argentina'")
argentina_total <-  fetch(argentina_total, n=-1)

###Extrae nombres y crea variables
argentina_total$primer_nombre <- sapply(strsplit(argentina_total$surname, " "), "[", 1)
argentina_total$segundo_nombre <- sapply(strsplit(argentina_total$surname, " "), "[", 2)

##Extrae las iniciales
argentina_total$primera_inicial <- paste(substr(argentina_total$primer_nombre, 1, 1),'.',sep="")
argentina_total$segunda_inicial <- paste(substr(argentina_total$segundo_nombre, 1, 1),'.',sep="")
argentina_total$segunda_inicial[argentina_total$segunda_inicial=='NA.'] <- NA


######CALCULA PROBA#####
nombres <- unique(argentina_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
str(nombres_prob)
argentina_total_genero <- left_join(argentina_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
argentina_total_genero_red <- argentina_total_genero[c(3,4,5,6,7,8,9,11)]
argentina_total_genero_red <- unique(argentina_total_genero_red )

###Tablas resumen
table(argentina_total_genero_red$gender)
summarize(group_by(argentina_total_genero_red, gender), count = n())

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_argentina', value=argentina_total_genero)
dbListTables(sci_ibero)


cantidades_argentina <- dbSendQuery(sci_ibero, "SELECT gender, COUNT(DISTINCT ut)  FROM genero_argentina GROUP BY gender")
cantidades_argentina <-  fetch(cantidades_argentina, n=-1)
cantidades_argentina




#####PAISES##########
country <- 'chile'
chile_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Chile' group by a.year, b.country")
chile_total <-  fetch(chile_total, n=-1)


chile_total <- dbSendQuery(sci_ibero, "select a.ut, a.order, a.name, a.surname, a.country from author_address a where country='Chile'")
chile_total <-  fetch(chile_total, n=-1)

###Extrae nombres y crea variables
chile_total$primer_nombre <- sapply(strsplit(chile_total$surname, " "), "[", 1)
chile_total$segundo_nombre <- sapply(strsplit(chile_total$surname, " "), "[", 2)

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
chile_total_genero_red <- chile_total_genero[c(3,4,5,6,7,8,9,11)]
chile_total_genero_red <- unique(chile_total_genero_red )

###Tablas resumen
table(chile_total_genero_red$gender)
summarize(group_by(chile_total_genero_red, gender), count = n())



####Pega la tabla al sql
dbWriteTable(sci_ibero, name='genero_chile', value=chile_total_genero)
dbListTables(sci_ibero)

cantidades_chile <- dbSendQuery(sci_ibero, "SELECT gender, COUNT(DISTINCT ut)  FROM genero_chile GROUP BY gender")
cantidades_chile <-  fetch(cantidades_chile, n=-1)
cantidades_chile
