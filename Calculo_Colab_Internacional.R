
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

minimo=2010
maximo=2016

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
argentina <- subset(argentina, year >=minimo & year <=maximo)


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
brazil <- subset(brazil, year >=minimo & year <=maximo)


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
mexico <- subset(mexico, year >=minimo & year <=maximo)


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
spain <- subset(spain, year >=minimo & year <=maximo)

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
portugal <- subset(portugal, year >=minimo & year <=maximo)

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
colombia <- subset(colombia, year >=minimo & year <=maximo)

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
chile <- subset(chile, year >=minimo & year <=maximo)

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
bolivia <- subset(bolivia, year >=minimo & year <=maximo)

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
barbados <- subset(barbados, year >=minimo & year <=maximo)

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
costa_rica <- subset(costa_rica, year >=minimo & year <=maximo)

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
cuba <- subset(cuba, year >=minimo & year <=maximo)

country <- 'Ecuador'
ecuador_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Ecuador' group by year, country")
ecuador_total <-  fetch(ecuador_total, n=-1)
ecuador_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Ecuador') and country <>'Ecuador' group by year")
ecuador_colab <-  fetch(ecuador_colab, n=-1)
ecuador_colab <- cbind(ecuador_colab,country)
ecuador <- left_join(ecuador_total, ecuador_colab, by = c("year", "country"))
names(ecuador)[names(ecuador)=="count(distinct ut).x"] <- "total"
names(ecuador)[names(ecuador)=="count(distinct ut).y"] <- "colaboracion"
ecuador$ratio <- (ecuador$colaboracion / ecuador$total)*100
ecuador <- subset(ecuador, year >=minimo & year <=maximo)

country <- 'El Salvador'
el_salvador_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='El Salvador' group by year, country")
el_salvador_total <-  fetch(el_salvador_total, n=-1)
el_salvador_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='El Salvador') and country <>'El Salvador' group by year")
el_salvador_colab <-  fetch(el_salvador_colab, n=-1)
el_salvador_colab <- cbind(el_salvador_colab,country)
el_salvador <- left_join(el_salvador_total, el_salvador_colab, by = c("year", "country"))
names(el_salvador)[names(el_salvador)=="count(distinct ut).x"] <- "total"
names(el_salvador)[names(el_salvador)=="count(distinct ut).y"] <- "colaboracion"
el_salvador$ratio <- (el_salvador$colaboracion / el_salvador$total)*100
el_salvador <- subset(el_salvador, year >=minimo & year <=maximo)

country <- 'Guatemala'
guatemala_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Guatemala' group by year, country")
guatemala_total <-  fetch(guatemala_total, n=-1)
guatemala_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Guatemala') and country <>'Guatemala' group by year")
guatemala_colab <-  fetch(guatemala_colab, n=-1)
guatemala_colab <- cbind(guatemala_colab,country)
guatemala <- left_join(guatemala_total, guatemala_colab, by = c("year", "country"))
names(guatemala)[names(guatemala)=="count(distinct ut).x"] <- "total"
names(guatemala)[names(guatemala)=="count(distinct ut).y"] <- "colaboracion"
guatemala$ratio <- (guatemala$colaboracion / guatemala$total)*100
guatemala <- subset(guatemala, year >=minimo & year <=maximo)

country <- 'Guyana'
guyana_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Guyana' group by year, country")
guyana_total <-  fetch(guyana_total, n=-1)
guyana_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Guyana') and country <>'Guyana' group by year")
guyana_colab <-  fetch(guyana_colab, n=-1)
guyana_colab <- cbind(guyana_colab,country)
guyana <- left_join(guyana_total, guyana_colab, by = c("year", "country"))
names(guyana)[names(guyana)=="count(distinct ut).x"] <- "total"
names(guyana)[names(guyana)=="count(distinct ut).y"] <- "colaboracion"
guyana$ratio <- (guyana$colaboracion / guyana$total)*100
guyana <- subset(guyana, year >=minimo & year <=maximo)


country <- 'Haiti'
haiti_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Haiti' group by year, country")
haiti_total <-  fetch(haiti_total, n=-1)
haiti_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Haiti') and country <>'Haiti' group by year")
haiti_colab <-  fetch(haiti_colab, n=-1)
haiti_colab <- cbind(haiti_colab,country)
haiti <- left_join(haiti_total, haiti_colab, by = c("year", "country"))
names(haiti)[names(haiti)=="count(distinct ut).x"] <- "total"
names(haiti)[names(haiti)=="count(distinct ut).y"] <- "colaboracion"
haiti$ratio <- (haiti$colaboracion / haiti$total)*100
haiti <- subset(haiti, year >=minimo & year <=maximo)

country <- 'Honduras'
honduras_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Honduras' group by year, country")
honduras_total <-  fetch(honduras_total, n=-1)
honduras_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Honduras') and country <>'Honduras' group by year")
honduras_colab <-  fetch(honduras_colab, n=-1)
honduras_colab <- cbind(honduras_colab,country)
honduras <- left_join(honduras_total, honduras_colab, by = c("year", "country"))
names(honduras)[names(honduras)=="count(distinct ut).x"] <- "total"
names(honduras)[names(honduras)=="count(distinct ut).y"] <- "colaboracion"
honduras$ratio <- (honduras$colaboracion / honduras$total)*100
honduras <- subset(honduras, year >=minimo & year <=maximo)

country <- 'Jamaica'
jamaica_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Jamaica' group by year, country")
jamaica_total <-  fetch(jamaica_total, n=-1)
jamaica_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Jamaica') and country <>'Jamaica' group by year")
jamaica_colab <-  fetch(jamaica_colab, n=-1)
jamaica_colab <- cbind(jamaica_colab,country)
jamaica <- left_join(jamaica_total, jamaica_colab, by = c("year", "country"))
names(jamaica)[names(jamaica)=="count(distinct ut).x"] <- "total"
names(jamaica)[names(jamaica)=="count(distinct ut).y"] <- "colaboracion"
jamaica$ratio <- (jamaica$colaboracion / jamaica$total)*100
jamaica <- subset(jamaica, year >=minimo & year <=maximo)


country <- 'Nicaragua'
nicaragua_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Nicaragua' group by year, country")
nicaragua_total <-  fetch(nicaragua_total, n=-1)
nicaragua_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Nicaragua') and country <>'Nicaragua' group by year")
nicaragua_colab <-  fetch(nicaragua_colab, n=-1)
nicaragua_colab <- cbind(nicaragua_colab,country)
nicaragua <- left_join(nicaragua_total, nicaragua_colab, by = c("year", "country"))
names(nicaragua)[names(nicaragua)=="count(distinct ut).x"] <- "total"
names(nicaragua)[names(nicaragua)=="count(distinct ut).y"] <- "colaboracion"
nicaragua$ratio <- (nicaragua$colaboracion / nicaragua$total)*100
nicaragua <- subset(nicaragua, year >=minimo & year <=maximo)


country <- 'Panama'
panama_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Panama' group by year, country")
panama_total <-  fetch(panama_total, n=-1)
panama_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Panama') and country <>'Panama' group by year")
panama_colab <-  fetch(panama_colab, n=-1)
panama_colab <- cbind(panama_colab,country)
panama <- left_join(panama_total, panama_colab, by = c("year", "country"))
names(panama)[names(panama)=="count(distinct ut).x"] <- "total"
names(panama)[names(panama)=="count(distinct ut).y"] <- "colaboracion"
panama$ratio <- (panama$colaboracion / panama$total)*100
panama <- subset(panama, year >=minimo & year <=maximo)



country <- 'Paraguay'
paraguay_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Paraguay' group by year, country")
paraguay_total <-  fetch(paraguay_total, n=-1)
paraguay_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Paraguay') and country <>'Paraguay' group by year")
paraguay_colab <-  fetch(paraguay_colab, n=-1)
paraguay_colab <- cbind(paraguay_colab,country)
paraguay <- left_join(paraguay_total, paraguay_colab, by = c("year", "country"))
names(paraguay)[names(paraguay)=="count(distinct ut).x"] <- "total"
names(paraguay)[names(paraguay)=="count(distinct ut).y"] <- "colaboracion"
paraguay$ratio <- (paraguay$colaboracion / paraguay$total)*100
paraguay <- subset(paraguay, year >=minimo & year <=maximo)


country <- 'Peru'
peru_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Peru' group by year, country")
peru_total <-  fetch(peru_total, n=-1)
peru_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Peru') and country <>'Peru' group by year")
peru_colab <-  fetch(peru_colab, n=-1)
peru_colab <- cbind(peru_colab,country)
peru <- left_join(peru_total, peru_colab, by = c("year", "country"))
names(peru)[names(peru)=="count(distinct ut).x"] <- "total"
names(peru)[names(peru)=="count(distinct ut).y"] <- "colaboracion"
peru$ratio <- (peru$colaboracion / peru$total)*100
peru <- subset(peru, year >=minimo & year <=maximo)


####FALTAN UN PAR DE PAISES####

total <- rbind(brazil,spain,argentina,mexico,portugal,chile,
               colombia,ecuador,cuba,bolivia,barbados,costa_rica,
               el_salvador, guatemala,guyana,haiti,honduras,
               jamaica,nicaragua,panama,paraguay,peru)

plot_ly(total, x = ~year, y = ~ratio, type = 'scatter',  color = ~country, mode = 'lines')


#setwd(".")
#write.csv(total, 'colaboracion.csv')

