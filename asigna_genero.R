#install.packages("rPython")

#####LIBRERIAS
#install.packages("DBI")
library(DBI)
#install.packages("RMySQL")
library(RMySQL)
#install.packages("Hmisc")
library(Hmisc)
##install.packages("gender")
library(gender)


setwd("~/SCI_genero")
source('./00-sql.r', encoding = 'latin1')

###chequear conexion###
sci_ibero


country <- 'Argentina'
argentina_total <- dbSendQuery(sci_ibero, "select a.ut, a.order, a.name, a.surname, a.country from author_address a where country='Argentina'")
argentina_total <-  fetch(argentina_total, n=-1)



###Extrae nombres y crea variables
argentina_total$primer_nombre <- sapply(strsplit(argentina_total$surname, " "), "[", 1)
argentina_total$segundo_nombre <- sapply(strsplit(argentina_total$surname, " "), "[", 2)

######CALCULA PROBA#####
nombres <- unique(argentina_total$primer_nombre)
nombres_prob <- gender(nombres)
nombres_prob <- nombres_prob[c(1,3,4)]


####Pega la tabla al sql
dbWriteTable(sci_ibero, name='nombres_prob', value=nombres_prob)
dbListTables(sci_ibero)


