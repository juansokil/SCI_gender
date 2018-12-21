

#####LIBRERIAS
library(DBI)
library(RMySQL)
library(Hmisc)
library(dplyr)
library(plotly)
library(reshape)
library(tidyr)

source('C:/Users/observatorio/Documents/SCI_genero/00-sql.r', encoding = 'latin1')




year <- dbSendQuery(pat_wipo, "select country, count(distinct pat_number) as cant from aplicant where usonly='0' group by country")
year <-  fetch(year, n=-1)
year <- year %>% mutate(year = 2017, origen ='TOTAL')

year <- dbSendQuery(pat_wipo_2017, "select country, count(distinct pat_number) as cant from aplicant where usonly='0' and name LIKE '%UNIV%' group by country")
year <-  fetch(year, n=-1)
year_univ <- year %>% mutate(year = 2017, origen ='UNIV')

total <- rbind(year, year_univ)

Totales <- 
  total %>% 
  spread(year, cant) 

setwd("~/SCI_genero")
setwd(".")
write.csv(Totales, 'Base_Final.csv')
