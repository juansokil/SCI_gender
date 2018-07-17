

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
##install.packages("dplyr")
library(dplyr)
##install.packages("plotly")
library(plotly)

####RUTA####
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
dbWriteTable(sci_ibero, name='TEMP_genero', value=nombres_prob)
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


cantidades_genero_argentina_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_argentina GROUP BY year, gender")
cantidades_genero_argentina_publ <-  fetch(cantidades_genero_argentina_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_argentina_publ <- cbind(country,variable,cantidades_genero_argentina_publ)

cantidades_genero_argentina_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_argentina GROUP BY year, gender")
cantidades_genero_argentina_pers <-  fetch(cantidades_genero_argentina_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_argentina_pers <- cbind(country,variable,cantidades_genero_argentina_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_argentina_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_argentina WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_argentina_con_autor <-  fetch(cantidades_argentina_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_argentina_con_autor <- cbind(country,variable,cantidades_argentina_con_autor)




#####PAISES##########
country <- 'Barbados'
barbados_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Barbados' group by a.year, b.country")
barbados_total <-  fetch(barbados_total, n=-1)

barbados_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Barbados'")
barbados_total <-  fetch(barbados_total, n=-1)

###Extrae nombres y crea variables
barbados_total$primer_nombre <- sapply(strsplit(barbados_total$name, " "), "[", 1)
barbados_total$segundo_nombre <- sapply(strsplit(barbados_total$name, " "), "[", 2)


##Extrae las iniciales
barbados_total$primera_inicial <- paste(substr(barbados_total$primer_nombre, 1, 1),'.',sep="")
barbados_total$segunda_inicial <- paste(substr(barbados_total$segundo_nombre, 1, 1),'.',sep="")
barbados_total$segunda_inicial[barbados_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(barbados_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
barbados_total_genero <- left_join(barbados_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
barbados_total_genero_red <- barbados_total_genero[c(2,4,5,6,7,8,9,10,12)]
barbados_total_genero_red <- unique(barbados_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_barbados', value=barbados_total_genero)
dbListTables(sci_ibero)

cantidades_genero_barbados_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_barbados GROUP BY year, gender")
cantidades_genero_barbados_publ <-  fetch(cantidades_genero_barbados_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_barbados_publ <- cbind(country,variable,cantidades_genero_barbados_publ)

cantidades_genero_barbados_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_barbados GROUP BY year, gender")
cantidades_genero_barbados_pers <-  fetch(cantidades_genero_barbados_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_barbados_pers <- cbind(country,variable,cantidades_genero_barbados_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_barbados_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_barbados WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_barbados_con_autor <-  fetch(cantidades_barbados_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_barbados_con_autor <- cbind(country,variable,cantidades_barbados_con_autor)










#####PAISES##########
country <- 'Bolivia'
bolivia_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Bolivia' group by a.year, b.country")
bolivia_total <-  fetch(bolivia_total, n=-1)

bolivia_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Bolivia'")
bolivia_total <-  fetch(bolivia_total, n=-1)

###Extrae nombres y crea variables
bolivia_total$primer_nombre <- sapply(strsplit(bolivia_total$name, " "), "[", 1)
bolivia_total$segundo_nombre <- sapply(strsplit(bolivia_total$name, " "), "[", 2)


##Extrae las iniciales
bolivia_total$primera_inicial <- paste(substr(bolivia_total$primer_nombre, 1, 1),'.',sep="")
bolivia_total$segunda_inicial <- paste(substr(bolivia_total$segundo_nombre, 1, 1),'.',sep="")
bolivia_total$segunda_inicial[bolivia_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(bolivia_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
bolivia_total_genero <- left_join(bolivia_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
bolivia_total_genero_red <- bolivia_total_genero[c(2,4,5,6,7,8,9,10,12)]
bolivia_total_genero_red <- unique(bolivia_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_bolivia', value=bolivia_total_genero)
dbListTables(sci_ibero)

cantidades_genero_bolivia_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_bolivia GROUP BY year, gender")
cantidades_genero_bolivia_publ <-  fetch(cantidades_genero_bolivia_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_bolivia_publ <- cbind(country,variable,cantidades_genero_bolivia_publ)

cantidades_genero_bolivia_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_bolivia GROUP BY year, gender")
cantidades_genero_bolivia_pers <-  fetch(cantidades_genero_bolivia_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_bolivia_pers <- cbind(country,variable,cantidades_genero_bolivia_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_bolivia_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_bolivia WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_bolivia_con_autor <-  fetch(cantidades_bolivia_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_bolivia_con_autor <- cbind(country,variable,cantidades_bolivia_con_autor)












#####PAISES##########
country <- 'Brazil'
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
dbWriteTable(sci_ibero, name='TEMP_genero_brazil', value=brazil_total_genero)
dbListTables(sci_ibero)

cantidades_genero_brazil_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_brazil GROUP BY year, gender")
cantidades_genero_brazil_publ <-  fetch(cantidades_genero_brazil_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_brazil_publ <- cbind(country,variable,cantidades_genero_brazil_publ)

cantidades_genero_brazil_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_brazil GROUP BY year, gender")
cantidades_genero_brazil_pers <-  fetch(cantidades_genero_brazil_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_brazil_pers <- cbind(country,variable,cantidades_genero_brazil_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_brazil_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_brazil WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_brazil_con_autor <-  fetch(cantidades_brazil_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_brazil_con_autor <- cbind(country,variable,cantidades_brazil_con_autor)




#####PAISES##########
country <- 'Chile'
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
chile_total_genero <- left_join(chile_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
chile_total_genero_red <- chile_total_genero[c(2,4,5,6,7,8,9,10,12)]
chile_total_genero_red <- unique(chile_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_chile', value=chile_total_genero)
dbListTables(sci_ibero)

cantidades_genero_chile_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_chile GROUP BY year, gender")
cantidades_genero_chile_publ <-  fetch(cantidades_genero_chile_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_chile_publ <- cbind(country,variable,cantidades_genero_chile_publ)

cantidades_genero_chile_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_chile GROUP BY year, gender")
cantidades_genero_chile_pers <-  fetch(cantidades_genero_chile_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_chile_pers <- cbind(country,variable,cantidades_genero_chile_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_chile_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_chile WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_chile_con_autor <-  fetch(cantidades_chile_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_chile_con_autor <- cbind(country,variable,cantidades_chile_con_autor)


#####PAISES##########
country <- 'Colombia'
colombia_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Colombia' group by a.year, b.country")
colombia_total <-  fetch(colombia_total, n=-1)

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
colombia_total_genero <- left_join(colombia_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
colombia_total_genero_red <- colombia_total_genero[c(2,4,5,6,7,8,9,10,12)]
colombia_total_genero_red <- unique(colombia_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_colombia', value=colombia_total_genero)
dbListTables(sci_ibero)

cantidades_genero_colombia_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_colombia GROUP BY year, gender")
cantidades_genero_colombia_publ <-  fetch(cantidades_genero_colombia_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_colombia_publ <- cbind(country,variable,cantidades_genero_colombia_publ)

cantidades_genero_colombia_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_colombia GROUP BY year, gender")
cantidades_genero_colombia_pers <-  fetch(cantidades_genero_colombia_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_colombia_pers <- cbind(country,variable,cantidades_genero_colombia_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_colombia_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_colombia WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_colombia_con_autor <-  fetch(cantidades_colombia_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_colombia_con_autor <- cbind(country,variable,cantidades_colombia_con_autor)





#####PAISES##########
country <- 'Costa Rica'
costarica_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Costa Rica' group by a.year, b.country")
costarica_total <-  fetch(costarica_total, n=-1)

costarica_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Costa Rica'")
costarica_total <-  fetch(costarica_total, n=-1)

###Extrae nombres y crea variables
costarica_total$primer_nombre <- sapply(strsplit(costarica_total$name, " "), "[", 1)
costarica_total$segundo_nombre <- sapply(strsplit(costarica_total$name, " "), "[", 2)


##Extrae las iniciales
costarica_total$primera_inicial <- paste(substr(costarica_total$primer_nombre, 1, 1),'.',sep="")
costarica_total$segunda_inicial <- paste(substr(costarica_total$segundo_nombre, 1, 1),'.',sep="")
costarica_total$segunda_inicial[costarica_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(costarica_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
costarica_total_genero <- left_join(costarica_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
costarica_total_genero_red <- costarica_total_genero[c(2,4,5,6,7,8,9,10,12)]
costarica_total_genero_red <- unique(costarica_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_costarica', value=costarica_total_genero)
dbListTables(sci_ibero)

cantidades_genero_costarica_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_costarica GROUP BY year, gender")
cantidades_genero_costarica_publ <-  fetch(cantidades_genero_costarica_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_costarica_publ <- cbind(country,variable,cantidades_genero_costarica_publ)

cantidades_genero_costarica_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_costarica GROUP BY year, gender")
cantidades_genero_costarica_pers <-  fetch(cantidades_genero_costarica_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_costarica_pers <- cbind(country,variable,cantidades_genero_costarica_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_costarica_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_costarica WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_costarica_con_autor <-  fetch(cantidades_costarica_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_costarica_con_autor <- cbind(country,variable,cantidades_costarica_con_autor)





#####PAISES##########
country <- 'Cuba'
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

cantidades_genero_cuba_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_cuba GROUP BY year, gender")
cantidades_genero_cuba_publ <-  fetch(cantidades_genero_cuba_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_cuba_publ <- cbind(country,variable,cantidades_genero_cuba_publ)

cantidades_genero_cuba_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_cuba GROUP BY year, gender")
cantidades_genero_cuba_pers <-  fetch(cantidades_genero_cuba_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_cuba_pers <- cbind(country,variable,cantidades_genero_cuba_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_cuba_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_cuba WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_cuba_con_autor <-  fetch(cantidades_cuba_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_cuba_con_autor <- cbind(country,variable,cantidades_cuba_con_autor)





#####PAISES##########
country <- 'Ecuador'
ecuador_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Ecuador' group by a.year, b.country")
ecuador_total <-  fetch(ecuador_total, n=-1)

ecuador_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Ecuador'")
ecuador_total <-  fetch(ecuador_total, n=-1)

###Extrae nombres y crea variables
ecuador_total$primer_nombre <- sapply(strsplit(ecuador_total$name, " "), "[", 1)
ecuador_total$segundo_nombre <- sapply(strsplit(ecuador_total$name, " "), "[", 2)


##Extrae las iniciales
ecuador_total$primera_inicial <- paste(substr(ecuador_total$primer_nombre, 1, 1),'.',sep="")
ecuador_total$segunda_inicial <- paste(substr(ecuador_total$segundo_nombre, 1, 1),'.',sep="")
ecuador_total$segunda_inicial[ecuador_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(ecuador_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
ecuador_total_genero <- left_join(ecuador_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
ecuador_total_genero_red <- ecuador_total_genero[c(2,4,5,6,7,8,9,10,12)]
ecuador_total_genero_red <- unique(ecuador_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_ecuador', value=ecuador_total_genero)
dbListTables(sci_ibero)

cantidades_genero_ecuador_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_ecuador GROUP BY year, gender")
cantidades_genero_ecuador_publ <-  fetch(cantidades_genero_ecuador_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_ecuador_publ <- cbind(country,variable,cantidades_genero_ecuador_publ)

cantidades_genero_ecuador_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_ecuador GROUP BY year, gender")
cantidades_genero_ecuador_pers <-  fetch(cantidades_genero_ecuador_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_ecuador_pers <- cbind(country,variable,cantidades_genero_ecuador_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_ecuador_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_ecuador WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_ecuador_con_autor <-  fetch(cantidades_ecuador_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_ecuador_con_autor <- cbind(country,variable,cantidades_ecuador_con_autor)








#####PAISES##########
country <- 'El Salvador'
elsalvador_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='El Salvador' group by a.year, b.country")
elsalvador_total <-  fetch(elsalvador_total, n=-1)

elsalvador_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='El Salvador'")
elsalvador_total <-  fetch(elsalvador_total, n=-1)

###Extrae nombres y crea variables
elsalvador_total$primer_nombre <- sapply(strsplit(elsalvador_total$name, " "), "[", 1)
elsalvador_total$segundo_nombre <- sapply(strsplit(elsalvador_total$name, " "), "[", 2)


##Extrae las iniciales
elsalvador_total$primera_inicial <- paste(substr(elsalvador_total$primer_nombre, 1, 1),'.',sep="")
elsalvador_total$segunda_inicial <- paste(substr(elsalvador_total$segundo_nombre, 1, 1),'.',sep="")
elsalvador_total$segunda_inicial[elsalvador_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(elsalvador_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
elsalvador_total_genero <- left_join(elsalvador_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
elsalvador_total_genero_red <- elsalvador_total_genero[c(2,4,5,6,7,8,9,10,12)]
elsalvador_total_genero_red <- unique(elsalvador_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_elsalvador', value=elsalvador_total_genero)
dbListTables(sci_ibero)

cantidades_genero_elsalvador_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_elsalvador GROUP BY year, gender")
cantidades_genero_elsalvador_publ <-  fetch(cantidades_genero_elsalvador_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_elsalvador_publ <- cbind(country,variable,cantidades_genero_elsalvador_publ)

cantidades_genero_elsalvador_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_elsalvador GROUP BY year, gender")
cantidades_genero_elsalvador_pers <-  fetch(cantidades_genero_elsalvador_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_elsalvador_pers <- cbind(country,variable,cantidades_genero_elsalvador_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_elsalvador_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_elsalvador WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_elsalvador_con_autor <-  fetch(cantidades_elsalvador_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_elsalvador_con_autor <- cbind(country,variable,cantidades_elsalvador_con_autor)



  
  
  #####PAISES##########
  country <- 'Spain'
  spain_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Spain' group by a.year, b.country")
  spain_total <-  fetch(spain_total, n=-1)
  
  spain_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Spain'")
  spain_total <-  fetch(spain_total, n=-1)
  
  ###Extrae nombres y crea variables
  spain_total$primer_nombre <- sapply(strsplit(spain_total$name, " "), "[", 1)
  spain_total$segundo_nombre <- sapply(strsplit(spain_total$name, " "), "[", 2)
  
  
  ##Extrae las iniciales
  spain_total$primera_inicial <- paste(substr(spain_total$primer_nombre, 1, 1),'.',sep="")
  spain_total$segunda_inicial <- paste(substr(spain_total$segundo_nombre, 1, 1),'.',sep="")
  spain_total$segunda_inicial[spain_total$segunda_inicial=='NA.'] <- NA
  
  ######CALCULA PROBA#####
  nombres <- unique(spain_total$primer_nombre)
  nombres_prob <- gender(nombres)
  nombres_prob <- nombres_prob[c(1,3,4)]
  
  ####DATOS JUNTOS
  spain_total_genero <- left_join(spain_total, nombres_prob, by = c("primer_nombre"="name"))
  View(spain_total_genero)
  ###UNICOS###
  spain_total_genero_red <- spain_total_genero[c(2,4,5,6,7,8,9,10,12)]
  spain_total_genero_red <- unique(spain_total_genero_red )
  
  ####Pega la tabla al sql
  dbWriteTable(sci_ibero, name='TEMP_genero_spain', value=spain_total_genero)
  dbListTables(sci_ibero)
  
  cantidades_genero_spain_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_spain GROUP BY year, gender")
  cantidades_genero_spain_publ <-  fetch(cantidades_genero_spain_publ, n=-1)
  variable <- 'cantidades_genero_publ'
  cantidades_genero_spain_publ <- cbind(country,variable,cantidades_genero_spain_publ)
  
  cantidades_genero_spain_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_spain GROUP BY year, gender")
  cantidades_genero_spain_pers <-  fetch(cantidades_genero_spain_pers, n=-1)
  variable <- 'cantidades_genero_pers'
  cantidades_genero_spain_pers <- cbind(country,variable,cantidades_genero_spain_pers)
  
  ####identifica la cantidad de articulos que tiene al menos un autor identificado###
  cantidades_spain_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_spain WHERE gender =  'male' OR gender =  'female' GROUP BY year")
  cantidades_spain_con_autor <-  fetch(cantidades_spain_con_autor, n=-1)
  variable <- 'cantidades_con_autor'
  cantidades_spain_con_autor <- cbind(country,variable,cantidades_spain_con_autor)
  



#####PAISES##########
country <- 'Guatemala'
guatemala_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Guatemala' group by a.year, b.country")
guatemala_total <-  fetch(guatemala_total, n=-1)

guatemala_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Guatemala'")
guatemala_total <-  fetch(guatemala_total, n=-1)

###Extrae nombres y crea variables
guatemala_total$primer_nombre <- sapply(strsplit(guatemala_total$name, " "), "[", 1)
guatemala_total$segundo_nombre <- sapply(strsplit(guatemala_total$name, " "), "[", 2)


##Extrae las iniciales
guatemala_total$primera_inicial <- paste(substr(guatemala_total$primer_nombre, 1, 1),'.',sep="")
guatemala_total$segunda_inicial <- paste(substr(guatemala_total$segundo_nombre, 1, 1),'.',sep="")
guatemala_total$segunda_inicial[guatemala_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(guatemala_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
guatemala_total_genero <- left_join(guatemala_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
guatemala_total_genero_red <- guatemala_total_genero[c(2,4,5,6,7,8,9,10,12)]
guatemala_total_genero_red <- unique(guatemala_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_guatemala', value=guatemala_total_genero)
dbListTables(sci_ibero)

cantidades_genero_guatemala_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_guatemala GROUP BY year, gender")
cantidades_genero_guatemala_publ <-  fetch(cantidades_genero_guatemala_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_guatemala_publ <- cbind(country,variable,cantidades_genero_guatemala_publ)

cantidades_genero_guatemala_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_guatemala GROUP BY year, gender")
cantidades_genero_guatemala_pers <-  fetch(cantidades_genero_guatemala_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_guatemala_pers <- cbind(country,variable,cantidades_genero_guatemala_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_guatemala_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_guatemala WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_guatemala_con_autor <-  fetch(cantidades_guatemala_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_guatemala_con_autor <- cbind(country,variable,cantidades_guatemala_con_autor)


#####PAISES##########
country <- 'Guyana'
guyana_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Guyana' group by a.year, b.country")
guyana_total <-  fetch(guyana_total, n=-1)

guyana_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Guyana'")
guyana_total <-  fetch(guyana_total, n=-1)

###Extrae nombres y crea variables
guyana_total$primer_nombre <- sapply(strsplit(guyana_total$name, " "), "[", 1)
guyana_total$segundo_nombre <- sapply(strsplit(guyana_total$name, " "), "[", 2)


##Extrae las iniciales
guyana_total$primera_inicial <- paste(substr(guyana_total$primer_nombre, 1, 1),'.',sep="")
guyana_total$segunda_inicial <- paste(substr(guyana_total$segundo_nombre, 1, 1),'.',sep="")
guyana_total$segunda_inicial[guyana_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(guyana_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
guyana_total_genero <- left_join(guyana_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
guyana_total_genero_red <- guyana_total_genero[c(2,4,5,6,7,8,9,10,12)]
guyana_total_genero_red <- unique(guyana_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_guyana', value=guyana_total_genero)
dbListTables(sci_ibero)

cantidades_genero_guyana_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_guyana GROUP BY year, gender")
cantidades_genero_guyana_publ <-  fetch(cantidades_genero_guyana_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_guyana_publ <- cbind(country,variable,cantidades_genero_guyana_publ)

cantidades_genero_guyana_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_guyana GROUP BY year, gender")
cantidades_genero_guyana_pers <-  fetch(cantidades_genero_guyana_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_guyana_pers <- cbind(country,variable,cantidades_genero_guyana_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_guyana_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_guyana WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_guyana_con_autor <-  fetch(cantidades_guyana_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_guyana_con_autor <- cbind(country,variable,cantidades_guyana_con_autor)







#####PAISES##########
country <- 'Haiti'
haiti_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Haiti' group by a.year, b.country")
haiti_total <-  fetch(haiti_total, n=-1)

haiti_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Haiti'")
haiti_total <-  fetch(haiti_total, n=-1)

###Extrae nombres y crea variables
haiti_total$primer_nombre <- sapply(strsplit(haiti_total$name, " "), "[", 1)
haiti_total$segundo_nombre <- sapply(strsplit(haiti_total$name, " "), "[", 2)


##Extrae las iniciales
haiti_total$primera_inicial <- paste(substr(haiti_total$primer_nombre, 1, 1),'.',sep="")
haiti_total$segunda_inicial <- paste(substr(haiti_total$segundo_nombre, 1, 1),'.',sep="")
haiti_total$segunda_inicial[haiti_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(haiti_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
haiti_total_genero <- left_join(haiti_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
haiti_total_genero_red <- haiti_total_genero[c(2,4,5,6,7,8,9,10,12)]
haiti_total_genero_red <- unique(haiti_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_haiti', value=haiti_total_genero)
dbListTables(sci_ibero)

cantidades_genero_haiti_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_haiti GROUP BY year, gender")
cantidades_genero_haiti_publ <-  fetch(cantidades_genero_haiti_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_haiti_publ <- cbind(country,variable,cantidades_genero_haiti_publ)

cantidades_genero_haiti_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_haiti GROUP BY year, gender")
cantidades_genero_haiti_pers <-  fetch(cantidades_genero_haiti_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_haiti_pers <- cbind(country,variable,cantidades_genero_haiti_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_haiti_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_haiti WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_haiti_con_autor <-  fetch(cantidades_haiti_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_haiti_con_autor <- cbind(country,variable,cantidades_haiti_con_autor)





#####PAISES##########
country <- 'Honduras'
honduras_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Honduras' group by a.year, b.country")
honduras_total <-  fetch(honduras_total, n=-1)

honduras_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Honduras'")
honduras_total <-  fetch(honduras_total, n=-1)

###Extrae nombres y crea variables
honduras_total$primer_nombre <- sapply(strsplit(honduras_total$name, " "), "[", 1)
honduras_total$segundo_nombre <- sapply(strsplit(honduras_total$name, " "), "[", 2)


##Extrae las iniciales
honduras_total$primera_inicial <- paste(substr(honduras_total$primer_nombre, 1, 1),'.',sep="")
honduras_total$segunda_inicial <- paste(substr(honduras_total$segundo_nombre, 1, 1),'.',sep="")
honduras_total$segunda_inicial[honduras_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(honduras_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
honduras_total_genero <- left_join(honduras_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
honduras_total_genero_red <- honduras_total_genero[c(2,4,5,6,7,8,9,10,12)]
honduras_total_genero_red <- unique(honduras_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_honduras', value=honduras_total_genero)
dbListTables(sci_ibero)

cantidades_genero_honduras_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_honduras GROUP BY year, gender")
cantidades_genero_honduras_publ <-  fetch(cantidades_genero_honduras_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_honduras_publ <- cbind(country,variable,cantidades_genero_honduras_publ)

cantidades_genero_honduras_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_honduras GROUP BY year, gender")
cantidades_genero_honduras_pers <-  fetch(cantidades_genero_honduras_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_honduras_pers <- cbind(country,variable,cantidades_genero_honduras_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_honduras_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_honduras WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_honduras_con_autor <-  fetch(cantidades_honduras_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_honduras_con_autor <- cbind(country,variable,cantidades_honduras_con_autor)



#####PAISES##########
country <- 'Jamaica'
jamaica_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Jamaica' group by a.year, b.country")
jamaica_total <-  fetch(jamaica_total, n=-1)

jamaica_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Jamaica'")
jamaica_total <-  fetch(jamaica_total, n=-1)

###Extrae nombres y crea variables
jamaica_total$primer_nombre <- sapply(strsplit(jamaica_total$name, " "), "[", 1)
jamaica_total$segundo_nombre <- sapply(strsplit(jamaica_total$name, " "), "[", 2)


##Extrae las iniciales
jamaica_total$primera_inicial <- paste(substr(jamaica_total$primer_nombre, 1, 1),'.',sep="")
jamaica_total$segunda_inicial <- paste(substr(jamaica_total$segundo_nombre, 1, 1),'.',sep="")
jamaica_total$segunda_inicial[jamaica_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(jamaica_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
jamaica_total_genero <- left_join(jamaica_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
jamaica_total_genero_red <- jamaica_total_genero[c(2,4,5,6,7,8,9,10,12)]
jamaica_total_genero_red <- unique(jamaica_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_jamaica', value=jamaica_total_genero)
dbListTables(sci_ibero)

cantidades_genero_jamaica_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_jamaica GROUP BY year, gender")
cantidades_genero_jamaica_publ <-  fetch(cantidades_genero_jamaica_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_jamaica_publ <- cbind(country,variable,cantidades_genero_jamaica_publ)

cantidades_genero_jamaica_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_jamaica GROUP BY year, gender")
cantidades_genero_jamaica_pers <-  fetch(cantidades_genero_jamaica_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_jamaica_pers <- cbind(country,variable,cantidades_genero_jamaica_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_jamaica_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_jamaica WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_jamaica_con_autor <-  fetch(cantidades_jamaica_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_jamaica_con_autor <- cbind(country,variable,cantidades_jamaica_con_autor)





#####PAISES##########
country <- 'Mexico'
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

cantidades_genero_mexico_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_mexico GROUP BY year, gender")
cantidades_genero_mexico_publ <-  fetch(cantidades_genero_mexico_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_mexico_publ <- cbind(country,variable,cantidades_genero_mexico_publ)

cantidades_genero_mexico_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_mexico GROUP BY year, gender")
cantidades_genero_mexico_pers <-  fetch(cantidades_genero_mexico_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_mexico_pers <- cbind(country,variable,cantidades_genero_mexico_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_mexico_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_mexico WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_mexico_con_autor <-  fetch(cantidades_mexico_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_mexico_con_autor <- cbind(country,variable,cantidades_mexico_con_autor)





#####PAISES##########
country <- 'Nicaragua'
nicaragua_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Nicaragua' group by a.year, b.country")
nicaragua_total <-  fetch(nicaragua_total, n=-1)

nicaragua_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Nicaragua'")
nicaragua_total <-  fetch(nicaragua_total, n=-1)

###Extrae nombres y crea variables
nicaragua_total$primer_nombre <- sapply(strsplit(nicaragua_total$name, " "), "[", 1)
nicaragua_total$segundo_nombre <- sapply(strsplit(nicaragua_total$name, " "), "[", 2)


##Extrae las iniciales
nicaragua_total$primera_inicial <- paste(substr(nicaragua_total$primer_nombre, 1, 1),'.',sep="")
nicaragua_total$segunda_inicial <- paste(substr(nicaragua_total$segundo_nombre, 1, 1),'.',sep="")
nicaragua_total$segunda_inicial[nicaragua_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(nicaragua_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
nicaragua_total_genero <- left_join(nicaragua_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
nicaragua_total_genero_red <- nicaragua_total_genero[c(2,4,5,6,7,8,9,10,12)]
nicaragua_total_genero_red <- unique(nicaragua_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_nicaragua', value=nicaragua_total_genero)
dbListTables(sci_ibero)

cantidades_genero_nicaragua_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_nicaragua GROUP BY year, gender")
cantidades_genero_nicaragua_publ <-  fetch(cantidades_genero_nicaragua_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_nicaragua_publ <- cbind(country,variable,cantidades_genero_nicaragua_publ)

cantidades_genero_nicaragua_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_nicaragua GROUP BY year, gender")
cantidades_genero_nicaragua_pers <-  fetch(cantidades_genero_nicaragua_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_nicaragua_pers <- cbind(country,variable,cantidades_genero_nicaragua_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_nicaragua_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_nicaragua WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_nicaragua_con_autor <-  fetch(cantidades_nicaragua_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_nicaragua_con_autor <- cbind(country,variable,cantidades_nicaragua_con_autor)



#####PAISES##########
country <- 'Panama'
panama_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Panama' group by a.year, b.country")
panama_total <-  fetch(panama_total, n=-1)

panama_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Panama'")
panama_total <-  fetch(panama_total, n=-1)

###Extrae nombres y crea variables
panama_total$primer_nombre <- sapply(strsplit(panama_total$name, " "), "[", 1)
panama_total$segundo_nombre <- sapply(strsplit(panama_total$name, " "), "[", 2)


##Extrae las iniciales
panama_total$primera_inicial <- paste(substr(panama_total$primer_nombre, 1, 1),'.',sep="")
panama_total$segunda_inicial <- paste(substr(panama_total$segundo_nombre, 1, 1),'.',sep="")
panama_total$segunda_inicial[panama_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(panama_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
panama_total_genero <- left_join(panama_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
panama_total_genero_red <- panama_total_genero[c(2,4,5,6,7,8,9,10,12)]
panama_total_genero_red <- unique(panama_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_panama', value=panama_total_genero)
dbListTables(sci_ibero)

cantidades_genero_panama_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_panama GROUP BY year, gender")
cantidades_genero_panama_publ <-  fetch(cantidades_genero_panama_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_panama_publ <- cbind(country,variable,cantidades_genero_panama_publ)

cantidades_genero_panama_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_panama GROUP BY year, gender")
cantidades_genero_panama_pers <-  fetch(cantidades_genero_panama_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_panama_pers <- cbind(country,variable,cantidades_genero_panama_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_panama_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_panama WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_panama_con_autor <-  fetch(cantidades_panama_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_panama_con_autor <- cbind(country,variable,cantidades_panama_con_autor)





#####PAISES##########
country <- 'Paraguay'
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
paraguay_total_genero <- left_join(paraguay_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
paraguay_total_genero_red <- paraguay_total_genero[c(2,4,5,6,7,8,9,10,12)]
paraguay_total_genero_red <- unique(paraguay_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_paraguay', value=paraguay_total_genero)
dbListTables(sci_ibero)

cantidades_genero_paraguay_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_paraguay GROUP BY year, gender")
cantidades_genero_paraguay_publ <-  fetch(cantidades_genero_paraguay_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_paraguay_publ <- cbind(country,variable,cantidades_genero_paraguay_publ)

cantidades_genero_paraguay_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_paraguay GROUP BY year, gender")
cantidades_genero_paraguay_pers <-  fetch(cantidades_genero_paraguay_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_paraguay_pers <- cbind(country,variable,cantidades_genero_paraguay_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_paraguay_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_paraguay WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_paraguay_con_autor <-  fetch(cantidades_paraguay_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_paraguay_con_autor <- cbind(country,variable,cantidades_paraguay_con_autor)






#####PAISES##########
country <- 'Peru'
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
peru_total_genero <- left_join(peru_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
peru_total_genero_red <- peru_total_genero[c(2,4,5,6,7,8,9,10,12)]
peru_total_genero_red <- unique(peru_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_peru', value=peru_total_genero)
dbListTables(sci_ibero)

cantidades_genero_peru_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_peru GROUP BY year, gender")
cantidades_genero_peru_publ <-  fetch(cantidades_genero_peru_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_peru_publ <- cbind(country,variable,cantidades_genero_peru_publ)

cantidades_genero_peru_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_peru GROUP BY year, gender")
cantidades_genero_peru_pers <-  fetch(cantidades_genero_peru_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_peru_pers <- cbind(country,variable,cantidades_genero_peru_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_peru_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_peru WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_peru_con_autor <-  fetch(cantidades_peru_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_peru_con_autor <- cbind(country,variable,cantidades_peru_con_autor)





#####PAISES##########
country <- 'Portugal'
portugal_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Portugal' group by a.year, b.country")
portugal_total <-  fetch(portugal_total, n=-1)

portugal_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Portugal'")
portugal_total <-  fetch(portugal_total, n=-1)

###Extrae nombres y crea variables
portugal_total$primer_nombre <- sapply(strsplit(portugal_total$name, " "), "[", 1)
portugal_total$segundo_nombre <- sapply(strsplit(portugal_total$name, " "), "[", 2)


##Extrae las iniciales
portugal_total$primera_inicial <- paste(substr(portugal_total$primer_nombre, 1, 1),'.',sep="")
portugal_total$segunda_inicial <- paste(substr(portugal_total$segundo_nombre, 1, 1),'.',sep="")
portugal_total$segunda_inicial[portugal_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(portugal_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
portugal_total_genero <- left_join(portugal_total, nombres_prob, by = c("primer_nombre"="name"))
###UNICOS###
portugal_total_genero_red <- portugal_total_genero[c(2,4,5,6,7,8,9,10,12)]
portugal_total_genero_red <- unique(portugal_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_portugal', value=portugal_total_genero)
dbListTables(sci_ibero)

cantidades_genero_portugal_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_portugal GROUP BY year, gender")
cantidades_genero_portugal_publ <-  fetch(cantidades_genero_portugal_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_portugal_publ <- cbind(country,variable,cantidades_genero_portugal_publ)

cantidades_genero_portugal_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_portugal GROUP BY year, gender")
cantidades_genero_portugal_pers <-  fetch(cantidades_genero_portugal_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_portugal_pers <- cbind(country,variable,cantidades_genero_portugal_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_portugal_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_portugal WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_portugal_con_autor <-  fetch(cantidades_portugal_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_portugal_con_autor <- cbind(country,variable,cantidades_portugal_con_autor)

#####PAISES##########
country <- 'Dominican Rep'
dominican_rep_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Dominican Rep' group by a.year, b.country")
dominican_rep_total <-  fetch(dominican_rep_total, n=-1)

dominican_rep_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Dominican Rep'")
dominican_rep_total <-  fetch(dominican_rep_total, n=-1)

###Extrae nombres y crea variables
dominican_rep_total$primer_nombre <- sapply(strsplit(dominican_rep_total$name, " "), "[", 1)
dominican_rep_total$segundo_nombre <- sapply(strsplit(dominican_rep_total$name, " "), "[", 2)


##Extrae las iniciales
dominican_rep_total$primera_inicial <- paste(substr(dominican_rep_total$primer_nombre, 1, 1),'.',sep="")
dominican_rep_total$segunda_inicial <- paste(substr(dominican_rep_total$segundo_nombre, 1, 1),'.',sep="")
dominican_rep_total$segunda_inicial[dominican_rep_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(dominican_rep_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
dominican_rep_total_genero <- left_join(dominican_rep_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
dominican_rep_total_genero_red <- dominican_rep_total_genero[c(2,4,5,6,7,8,9,10,12)]
dominican_rep_total_genero_red <- unique(dominican_rep_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_dominican_rep', value=dominican_rep_total_genero)
dbListTables(sci_ibero)

cantidades_genero_dominican_rep_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_dominican_rep GROUP BY year, gender")
cantidades_genero_dominican_rep_publ <-  fetch(cantidades_genero_dominican_rep_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_dominican_rep_publ <- cbind(country,variable,cantidades_genero_dominican_rep_publ)

cantidades_genero_dominican_rep_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_dominican_rep GROUP BY year, gender")
cantidades_genero_dominican_rep_pers <-  fetch(cantidades_genero_dominican_rep_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_dominican_rep_pers <- cbind(country,variable,cantidades_genero_dominican_rep_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_dominican_rep_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_dominican_rep WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_dominican_rep_con_autor <-  fetch(cantidades_dominican_rep_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_dominican_rep_con_autor <- cbind(country,variable,cantidades_dominican_rep_con_autor)






#####PAISES##########
country <- 'Trinid & Tobago'
trinid_tobago_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Trinid & Tobago' group by a.year, b.country")
trinid_tobago_total <-  fetch(trinid_tobago_total, n=-1)

trinid_tobago_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Trinid & Tobago'")
trinid_tobago_total <-  fetch(trinid_tobago_total, n=-1)

###Extrae nombres y crea variables
trinid_tobago_total$primer_nombre <- sapply(strsplit(trinid_tobago_total$name, " "), "[", 1)
trinid_tobago_total$segundo_nombre <- sapply(strsplit(trinid_tobago_total$name, " "), "[", 2)


##Extrae las iniciales
trinid_tobago_total$primera_inicial <- paste(substr(trinid_tobago_total$primer_nombre, 1, 1),'.',sep="")
trinid_tobago_total$segunda_inicial <- paste(substr(trinid_tobago_total$segundo_nombre, 1, 1),'.',sep="")
trinid_tobago_total$segunda_inicial[trinid_tobago_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(trinid_tobago_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
trinid_tobago_total_genero <- left_join(trinid_tobago_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
trinid_tobago_total_genero_red <- trinid_tobago_total_genero[c(2,4,5,6,7,8,9,10,12)]
trinid_tobago_total_genero_red <- unique(trinid_tobago_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_trinid_tobago', value=trinid_tobago_total_genero)
dbListTables(sci_ibero)

cantidades_genero_trinid_tobago_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_trinid_tobago GROUP BY year, gender")
cantidades_genero_trinid_tobago_publ <-  fetch(cantidades_genero_trinid_tobago_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_trinid_tobago_publ <- cbind(country,variable,cantidades_genero_trinid_tobago_publ)

cantidades_genero_trinid_tobago_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_trinid_tobago GROUP BY year, gender")
cantidades_genero_trinid_tobago_pers <-  fetch(cantidades_genero_trinid_tobago_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_trinid_tobago_pers <- cbind(country,variable,cantidades_genero_trinid_tobago_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_trinid_tobago_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_trinid_tobago WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_trinid_tobago_con_autor <-  fetch(cantidades_trinid_tobago_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_trinid_tobago_con_autor <- cbind(country,variable,cantidades_trinid_tobago_con_autor)




#####PAISES##########
country <- 'Uruguay'
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
uruguay_total_genero <- left_join(uruguay_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
uruguay_total_genero_red <- uruguay_total_genero[c(2,4,5,6,7,8,9,10,12)]
uruguay_total_genero_red <- unique(uruguay_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_uruguay', value=uruguay_total_genero)
dbListTables(sci_ibero)

cantidades_genero_uruguay_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_uruguay GROUP BY year, gender")
cantidades_genero_uruguay_publ <-  fetch(cantidades_genero_uruguay_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_uruguay_publ <- cbind(country,variable,cantidades_genero_uruguay_publ)

cantidades_genero_uruguay_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_uruguay GROUP BY year, gender")
cantidades_genero_uruguay_pers <-  fetch(cantidades_genero_uruguay_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_uruguay_pers <- cbind(country,variable,cantidades_genero_uruguay_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_uruguay_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_uruguay WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_uruguay_con_autor <-  fetch(cantidades_uruguay_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_uruguay_con_autor <- cbind(country,variable,cantidades_uruguay_con_autor)



#####PAISES##########
country <- 'Venezuela'
venezuela_total <- dbSendQuery(sci_ibero, "select a.year, b.country, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and b.country='Venezuela' group by a.year, b.country")
venezuela_total <-  fetch(venezuela_total, n=-1)

venezuela_total <- dbSendQuery(sci_ibero, "select a.ut, b.year, a.order, a.name, a.surname, a.country from author_address a, article b where a.ut=b.ut and country='Venezuela'")
venezuela_total <-  fetch(venezuela_total, n=-1)

###Extrae nombres y crea variables
venezuela_total$primer_nombre <- sapply(strsplit(venezuela_total$name, " "), "[", 1)
venezuela_total$segundo_nombre <- sapply(strsplit(venezuela_total$name, " "), "[", 2)


##Extrae las iniciales
venezuela_total$primera_inicial <- paste(substr(venezuela_total$primer_nombre, 1, 1),'.',sep="")
venezuela_total$segunda_inicial <- paste(substr(venezuela_total$segundo_nombre, 1, 1),'.',sep="")
venezuela_total$segunda_inicial[venezuela_total$segunda_inicial=='NA.'] <- NA

######CALCULA PROBA#####
nombres <- unique(venezuela_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]

####DATOS JUNTOS
venezuela_total_genero <- left_join(venezuela_total, nombres_prob, by = c("primer_nombre"="name"))

###UNICOS###
venezuela_total_genero_red <- venezuela_total_genero[c(2,4,5,6,7,8,9,10,12)]
venezuela_total_genero_red <- unique(venezuela_total_genero_red )

####Pega la tabla al sql
dbWriteTable(sci_ibero, name='TEMP_genero_venezuela', value=venezuela_total_genero)
dbListTables(sci_ibero)

cantidades_genero_venezuela_publ <- dbSendQuery(sci_ibero, "SELECT year, gender, COUNT(DISTINCT ut)  FROM TEMP_genero_venezuela GROUP BY year, gender")
cantidades_genero_venezuela_publ <-  fetch(cantidades_genero_venezuela_publ, n=-1)
variable <- 'cantidades_genero_publ'
cantidades_genero_venezuela_publ <- cbind(country,variable,cantidades_genero_venezuela_publ)

cantidades_genero_venezuela_pers <- dbSendQuery(sci_ibero, "SELECT year, gender, count(distinct surname, name)  FROM TEMP_genero_venezuela GROUP BY year, gender")
cantidades_genero_venezuela_pers <-  fetch(cantidades_genero_venezuela_pers, n=-1)
variable <- 'cantidades_genero_pers'
cantidades_genero_venezuela_pers <- cbind(country,variable,cantidades_genero_venezuela_pers)

####identifica la cantidad de articulos que tiene al menos un autor identificado###
cantidades_venezuela_con_autor <- dbSendQuery(sci_ibero, "SELECT COUNT(DISTINCT ut) , year FROM TEMP_genero_venezuela WHERE gender =  'male' OR gender =  'female' GROUP BY year")
cantidades_venezuela_con_autor <-  fetch(cantidades_venezuela_con_autor, n=-1)
variable <- 'cantidades_con_autor'
cantidades_venezuela_con_autor <- cbind(country,variable,cantidades_venezuela_con_autor)







##################JUNTA DATOS###################

minimo=2014
maximo=2016

cantidades_genero_publ <- rbind (cantidades_genero_argentina_publ, 
                                 cantidades_genero_barbados_publ,
                                 cantidades_genero_bolivia_publ, 
                                 cantidades_genero_brazil_publ, 
                                 cantidades_genero_chile_publ, 
                                 cantidades_genero_colombia_publ,
                                 cantidades_genero_costarica_publ,
                                 cantidades_genero_cuba_publ,
                                 cantidades_genero_ecuador_publ,
                                 cantidades_genero_elsalvador_publ,
                                 cantidades_genero_spain_publ,
                                 cantidades_genero_guatemala_publ,
                                 cantidades_genero_guyana_publ,
                                 cantidades_genero_haiti_publ,
                                 cantidades_genero_honduras_publ,
                                 cantidades_genero_jamaica_publ,
                                 cantidades_genero_mexico_publ,
                                 cantidades_genero_nicaragua_publ,
                                 cantidades_genero_panama_publ,
                                 cantidades_genero_paraguay_publ,
                                 cantidades_genero_peru_publ,
                                 cantidades_genero_portugal_publ,
                                 cantidades_genero_dominican_rep_publ,
                                 cantidades_genero_trinid_tobago_publ,
                                 cantidades_genero_uruguay_publ,
                                 cantidades_genero_venezuela_publ)

cantidades_genero_publ <- subset(cantidades_genero_publ, (year >=minimo & year <=maximo) & gender !='<NA>')




cantidades_genero_pers <- rbind (cantidades_genero_argentina_pers, 
                                 cantidades_genero_barbados_pers,
                                 cantidades_genero_bolivia_pers, 
                                 cantidades_genero_brazil_pers, 
                                 cantidades_genero_chile_pers, 
                                 cantidades_genero_colombia_pers,
                                 cantidades_genero_costarica_pers,
                                 cantidades_genero_cuba_pers,
                                 cantidades_genero_ecuador_pers,
                                 cantidades_genero_elsalvador_pers,
                                 cantidades_genero_spain_pers,
                                 cantidades_genero_guatemala_pers,
                                 cantidades_genero_guyana_pers,
                                 cantidades_genero_haiti_pers,
                                 cantidades_genero_honduras_pers,
                                 cantidades_genero_jamaica_pers,
                                 cantidades_genero_mexico_pers,
                                 cantidades_genero_nicaragua_pers,
                                 cantidades_genero_panama_pers,
                                 cantidades_genero_paraguay_pers,
                                 cantidades_genero_peru_pers,
                                 cantidades_genero_portugal_pers,
                                 cantidades_genero_dominican_rep_pers,
                                 cantidades_genero_trinid_tobago_pers,
                                 cantidades_genero_uruguay_pers,
                                 cantidades_genero_venezuela_pers
                                 )


cantidades_genero_pers <- subset(cantidades_genero_pers, (year >=minimo & year <=maximo) & gender !='<NA>')


cantidades_con_autor <- rbind(cantidades_argentina_con_autor, 
                              cantidades_barbados_con_autor,
                              cantidades_bolivia_con_autor, 
                              cantidades_brazil_con_autor, 
                              cantidades_chile_con_autor, 
                              cantidades_colombia_con_autor,
                              cantidades_costarica_con_autor,
                              cantidades_cuba_con_autor,
                              cantidades_ecuador_con_autor,
                              cantidades_elsalvador_con_autor,
                              cantidades_spain_con_autor,
                              cantidades_guatemala_con_autor,
                              cantidades_guyana_con_autor,
                              cantidades_haiti_con_autor,
                              cantidades_honduras_con_autor,
                              cantidades_jamaica_con_autor,
                              cantidades_mexico_con_autor,
                              cantidades_nicaragua_con_autor,
                              cantidades_panama_con_autor,
                              cantidades_paraguay_con_autor,
                              cantidades_peru_con_autor,
                              cantidades_portugal_con_autor,
                              cantidades_dominican_rep_con_autor,
                              cantidades_trinid_tobago_con_autor,
                              cantidades_uruguay_con_autor,
                              cantidades_venezuela_con_autor
                              )

cantidades_con_autor <- subset(cantidades_con_autor, year >=minimo & year <=maximo)

####JUNTA DATOS###

cantidades_genero_publ_female <- subset(cantidades_genero_publ, gender=='female')
cantidades_genero_publ_male <- subset(cantidades_genero_publ, gender=='male')

totales <- left_join(cantidades_por_pais, cantidades_genero_publ_female, by = c("year", "country"))
totales <- left_join(totales, cantidades_genero_publ_male, by = c("year", "country"))
names(totales)[names(totales)=="COUNT(DISTINCT ut).x"] <- "cant_genero_publ_female"
names(totales)[names(totales)=="COUNT(DISTINCT ut).y"] <- "cant_genero_publ_male"

cantidades_genero_pers_female <- subset(cantidades_genero_pers, gender=='female')
cantidades_genero_pers_male <- subset(cantidades_genero_pers, gender=='male')

totales <- left_join(totales, cantidades_genero_pers_female, by = c("year", "country"))
totales <- left_join(totales, cantidades_genero_pers_male, by = c("year", "country"))
names(totales)[names(totales)=="count(distinct surname, name).x"] <- "cant_genero_pers_female"
names(totales)[names(totales)=="count(distinct surname, name).y"] <- "cant_genero_pers_male"

totales <- left_join(totales, cantidades_con_autor, by = c("year", "country"))
names(totales)[names(totales)=="COUNT(DISTINCT ut)"] <- "cant_con_autor"

totales <- subset(totales, (year >=minimo & year <=maximo))

Totales_Genero <- totales[, c(1:3,17,6,9,12,15)]
Totales_Genero <- subset(Totales_Genero, (cant_con_autor>0))
Totales_Genero$ratio_autor_fem <- Totales_Genero$cant_genero_pers_female/(Totales_Genero$cant_genero_pers_male+Totales_Genero$cant_genero_pers_female)





#### TEST#####
write.csv(Totales_Genero,'genero.csv')
plot_ly(Totales_Genero, x = ~year, y = ~ratio_autor_fem, type = 'scatter',  color = ~country, mode = 'lines')






