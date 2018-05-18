
#####LIBRERIAS
install.packages("DBI")
library(DBI)
install.packages("RMySQL")
library(RMySQL)
install.packages("Hmisc")
library(Hmisc)
install.packages("dplyr")
library(dplyr)
install.packages("plotly")
library(plotly)

###Ejecuto un par de querys e identifico la que no funciona, le indico el id y tiro el kill
scopus_ibero = dbConnect(MySQL(), user='scopus', password='sc0pus2698', dbname='scopus_ibero', host='mysql.ricyt.org')
#dbListTables(scopus)
#dbGetQuery(scopus, "show processlist")
#dbGetQuery(scopus, "kill 3484878")

####QUERY PARA CREAR LA TABLA INICIAL, CREA UN LISTADO DE UTS POR CADA PAIS QUE PARTICIPA ####
###create table ut_year_country as select distinct b.country, a.ut, a.year from article a, address b where a.ut=b.ut; ####


country <- 'Argentina'
argentina_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Argentina' group by year, country")
argentina_total <-  fetch(argentina_total, n=-1)
argentina_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Argentina') and country <>'Argentina' group by year")
argentina_colab <-  fetch(argentina_colab, n=-1)
argentina_colab <- cbind(argentina_colab,country)
argentina <- left_join(argentina_total, argentina_colab, by = c("year", "country"))
names(argentina)[names(argentina)=="count(distinct ut).x"] <- "total"
names(argentina)[names(argentina)=="count(distinct ut).y"] <- "colaboracion"
argentina$ratio <- (argentina$colaboracion / argentina$total)*100
plot_ly(argentina, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')

country <- 'Brazil'
brazil_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Brazil' group by year, country")
brazil_total <-  fetch(brazil_total, n=-1)
brazil_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Brazil') and country <>'Brazil' group by year")
brazil_colab <-  fetch(brazil_colab, n=-1)
brazil_colab <- cbind(brazil_colab,country)
brazil <- left_join(brazil_total, brazil_colab, by = c("year", "country"))
names(brazil)[names(brazil)=="count(distinct ut).x"] <- "total"
names(brazil)[names(brazil)=="count(distinct ut).y"] <- "colaboracion"
brazil$ratio <- (brazil$colaboracion / brazil$total)*100
plot_ly(brazil, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')


country <- 'Mexico'
mexico_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Mexico' group by year, country")
mexico_total <-  fetch(mexico_total, n=-1)
mexico_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Mexico') and country <>'Mexico' group by year")
mexico_colab <-  fetch(mexico_colab, n=-1)
mexico_colab <- cbind(mexico_colab,country)
mexico <- left_join(mexico_total, mexico_colab, by = c("year", "country"))
names(mexico)[names(mexico)=="count(distinct ut).x"] <- "total"
names(mexico)[names(mexico)=="count(distinct ut).y"] <- "colaboracion"
mexico$ratio <- (mexico$colaboracion / mexico$total)*100
plot_ly(mexico, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')




country <- 'Spain'
spain_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Spain' group by year, country")
spain_total <-  fetch(spain_total, n=-1)
spain_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Spain') and country <>'Spain' group by year")
spain_colab <-  fetch(spain_colab, n=-1)
spain_colab <- cbind(spain_colab,country)
spain <- left_join(spain_total, spain_colab, by = c("year", "country"))
names(spain)[names(spain)=="count(distinct ut).x"] <- "total"
names(spain)[names(spain)=="count(distinct ut).y"] <- "colaboracion"
spain$ratio <- (spain$colaboracion / spain$total)*100
plot_ly(spain, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')



country <- 'Portugal'
portugal_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Portugal' group by year, country")
portugal_total <-  fetch(portugal_total, n=-1)
portugal_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Portugal') and country <>'Portugal' group by year")
portugal_colab <-  fetch(portugal_colab, n=-1)
portugal_colab <- cbind(portugal_colab,country)
portugal <- left_join(portugal_total, portugal_colab, by = c("year", "country"))
names(portugal)[names(portugal)=="count(distinct ut).x"] <- "total"
names(portugal)[names(portugal)=="count(distinct ut).y"] <- "colaboracion"
portugal$ratio <- (portugal$colaboracion / portugal$total)*100
plot_ly(portugal, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')



country <- 'Colombia'
colombia_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Colombia' group by year, country")
colombia_total <-  fetch(colombia_total, n=-1)
colombia_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Colombia') and country <>'Colombia' group by year")
colombia_colab <-  fetch(colombia_colab, n=-1)
colombia_colab <- cbind(colombia_colab,country)
colombia <- left_join(colombia_total, colombia_colab, by = c("year", "country"))
names(colombia)[names(colombia)=="count(distinct ut).x"] <- "total"
names(colombia)[names(colombia)=="count(distinct ut).y"] <- "colaboracion"
colombia$ratio <- (colombia$colaboracion / colombia$total)*100
plot_ly(colombia, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')



country <- 'Chile'
chile_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Chile' group by year, country")
chile_total <-  fetch(chile_total, n=-1)
chile_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Chile') and country <>'Chile' group by year")
chile_colab <-  fetch(chile_colab, n=-1)
chile_colab <- cbind(chile_colab,country)
chile <- left_join(chile_total, chile_colab, by = c("year", "country"))
names(chile)[names(chile)=="count(distinct ut).x"] <- "total"
names(chile)[names(chile)=="count(distinct ut).y"] <- "colaboracion"
chile$ratio <- (chile$colaboracion / chile$total)*100
plot_ly(chile, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')



country <- 'Bolivia'
bolivia_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Bolivia' group by year, country")
bolivia_total <-  fetch(bolivia_total, n=-1)
bolivia_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Bolivia') and country <>'Bolivia' group by year")
bolivia_colab <-  fetch(bolivia_colab, n=-1)
bolivia_colab <- cbind(bolivia_colab,country)
bolivia <- left_join(bolivia_total, bolivia_colab, by = c("year", "country"))
names(bolivia)[names(bolivia)=="count(distinct ut).x"] <- "total"
names(bolivia)[names(bolivia)=="count(distinct ut).y"] <- "colaboracion"
bolivia$ratio <- (bolivia$colaboracion / bolivia$total)*100
plot_ly(bolivia, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')

country <- 'Barbados'
barbados_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Barbados' group by year, country")
barbados_total <-  fetch(barbados_total, n=-1)
barbados_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Barbados') and country <>'Barbados' group by year")
barbados_colab <-  fetch(barbados_colab, n=-1)
barbados_colab <- cbind(barbados_colab,country)
barbados <- left_join(barbados_total, barbados_colab, by = c("year", "country"))
names(barbados)[names(barbados)=="count(distinct ut).x"] <- "total"
names(barbados)[names(barbados)=="count(distinct ut).y"] <- "colaboracion"
barbados$ratio <- (barbados$colaboracion / barbados$total)*100
plot_ly(barbados, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')


country <- 'Costa Rica'
costa_rica_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Costa Rica' group by year, country")
costa_rica_total <-  fetch(costa_rica_total, n=-1)
costa_rica_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Costa Rica') and country <>'Costa Rica' group by year")
costa_rica_colab <-  fetch(costa_rica_colab, n=-1)
costa_rica_colab <- cbind(costa_rica_colab,country)
costa_rica <- left_join(costa_rica_total, costa_rica_colab, by = c("year", "country"))
names(costa_rica)[names(costa_rica)=="count(distinct ut).x"] <- "total"
names(costa_rica)[names(costa_rica)=="count(distinct ut).y"] <- "colaboracion"
costa_rica$ratio <- (costa_rica$colaboracion / costa_rica$total)*100
plot_ly(costa_rica, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')



country <- 'Cuba'
cuba_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Cuba' group by year, country")
cuba_total <-  fetch(cuba_total, n=-1)
cuba_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Cuba') and country <>'Cuba' group by year")
cuba_colab <-  fetch(cuba_colab, n=-1)
cuba_colab <- cbind(cuba_colab,country)
cuba <- left_join(cuba_total, cuba_colab, by = c("year", "country"))
names(cuba)[names(cuba)=="count(distinct ut).x"] <- "total"
names(cuba)[names(cuba)=="count(distinct ut).y"] <- "colaboracion"
cuba$ratio <- (cuba$colaboracion / cuba$total)*100
plot_ly(cuba, x = ~year, y = ~ratio, type = 'scatter', mode = 'lines')




setwd("O:/CAEU/CAEU1/Cosas/RICYT/Relevamientos/Relevamiento 2018")
write.csv(base, 'total.csv')

