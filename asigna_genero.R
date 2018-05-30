

#####LIBRERIAS
#install.packages("DBI")
library(DBI)
#install.packages("RMySQL")
library(RMySQL)
#install.packages("Hmisc")
library(Hmisc)
##install.packages("gender")
library(gender)

source('./00-sql.r', encoding = 'latin1')

###chequear conexion###


Author <- read_csv("~/SCI_genero/Author.csv")


nombres <- unique(Author$Nombre)

#gender(names, years = c(1932, 2012), method = c("ssa", "ipums", "napp","kantrowitz", "genderize", "demo"), countries = c("United States", "Canada","United Kingdom", "Denmark", "Iceland", "Norway", "Sweden"))

Prob <- gender(nombres)
View(Prob)