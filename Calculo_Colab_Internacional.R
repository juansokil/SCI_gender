
#####LIBRERIAS
#install.packages("DBI")
library(DBI)
#install.packages("RMySQL")
library(RMySQL)
#install.packages("Hmisc")
library(Hmisc)
#install.packages("dplyr")
library(dplyr)
#install.packages("plotly")
library(plotly)
#install.packages("reshape")
library(reshape)


source('C:/Users/observatorio/Documents/SCI_genero/00-sql.r', encoding = 'latin1')




###chequear conexion###
scopus_ibero

####QUERY PARA CREAR LA TABLA INICIAL, CREA UN LISTADO DE UTS POR CADA PAIS QUE PARTICIPA ####
###create table ut_year_country as select distinct b.country, a.ut, a.year, a.pub_name from article a, address b where a.ut=b.ut; ####

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

argentina_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Argentina' group by a.year, b.area_desc")
argentina_disc_total <-  fetch(argentina_disc_total, n=-1)
argentina_disc_total <- cast(argentina_disc_total, year ~ area_desc, value='cant')
argentina_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Argentina') and a.country  <>'Argentina' group by a.year, b.area_desc")
argentina_disc_colab <-  fetch(argentina_disc_colab, n=-1)
argentina_disc_colab <- cast(argentina_disc_colab, year ~ area_desc, value='cant')
argentina <- left_join(argentina, argentina_disc_total, by = "year")
argentina <- left_join(argentina, argentina_disc_colab, by = "year")

argentina$ratio_health_total <- (argentina$`Health Sciences.x` / argentina$total)*100
argentina$ratio_life_total <- (argentina$`Life Sciences.x` / argentina$total)*100
argentina$ratio_physical_total <- (argentina$`Physical Sciences.x` / argentina$total)*100
argentina$ratio_social_total <- (argentina$`Social Sciences.x` / argentina$total)*100
argentina$ratio_colab <- (argentina$colaboracion / argentina$total)*100
argentina$ratio_health_colab <- (argentina$`Health Sciences.y` / argentina$colaboracion)*100
argentina$ratio_life_colab <- (argentina$`Life Sciences.y` / argentina$colaboracion)*100
argentina$ratio_physical_colab <- (argentina$`Physical Sciences.y` / argentina$colaboracion)*100
argentina$ratio_social_colab <- (argentina$`Social Sciences.y` / argentina$colaboracion)*100

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



brazil_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Brazil' group by a.year, b.area_desc")
brazil_disc_total <-  fetch(brazil_disc_total, n=-1)
brazil_disc_total <- cast(brazil_disc_total, year ~ area_desc, value='cant')
brazil_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Brazil') and a.country  <>'Brazil' group by a.year, b.area_desc")
brazil_disc_colab <-  fetch(brazil_disc_colab, n=-1)
brazil_disc_colab <- cast(brazil_disc_colab, year ~ area_desc, value='cant')
brazil <- left_join(brazil, brazil_disc_total, by = "year")
brazil <- left_join(brazil, brazil_disc_colab, by = "year")

brazil$ratio_health_total <- (brazil$`Health Sciences.x` / brazil$total)*100
brazil$ratio_life_total <- (brazil$`Life Sciences.x` / brazil$total)*100
brazil$ratio_physical_total <- (brazil$`Physical Sciences.x` / brazil$total)*100
brazil$ratio_social_total <- (brazil$`Social Sciences.x` / brazil$total)*100
brazil$ratio_colab <- (brazil$colaboracion / brazil$total)*100
brazil$ratio_health_colab <- (brazil$`Health Sciences.y` / brazil$colaboracion)*100
brazil$ratio_life_colab <- (brazil$`Life Sciences.y` / brazil$colaboracion)*100
brazil$ratio_physical_colab <- (brazil$`Physical Sciences.y` / brazil$colaboracion)*100
brazil$ratio_social_colab <- (brazil$`Social Sciences.y` / brazil$colaboracion)*100

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


mexico_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Mexico' group by a.year, b.area_desc")
mexico_disc_total <-  fetch(mexico_disc_total, n=-1)
mexico_disc_total <- cast(mexico_disc_total, year ~ area_desc, value='cant')
mexico_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Mexico') and a.country  <>'Mexico' group by a.year, b.area_desc")
mexico_disc_colab <-  fetch(mexico_disc_colab, n=-1)
mexico_disc_colab <- cast(mexico_disc_colab, year ~ area_desc, value='cant')
mexico <- left_join(mexico, mexico_disc_total, by = "year")
mexico <- left_join(mexico, mexico_disc_colab, by = "year")

mexico$ratio_health_total <- (mexico$`Health Sciences.x` / mexico$total)*100
mexico$ratio_life_total <- (mexico$`Life Sciences.x` / mexico$total)*100
mexico$ratio_physical_total <- (mexico$`Physical Sciences.x` / mexico$total)*100
mexico$ratio_social_total <- (mexico$`Social Sciences.x` / mexico$total)*100
mexico$ratio_colab <- (mexico$colaboracion / mexico$total)*100
mexico$ratio_health_colab <- (mexico$`Health Sciences.y` / mexico$colaboracion)*100
mexico$ratio_life_colab <- (mexico$`Life Sciences.y` / mexico$colaboracion)*100
mexico$ratio_physical_colab <- (mexico$`Physical Sciences.y` / mexico$colaboracion)*100
mexico$ratio_social_colab <- (mexico$`Social Sciences.y` / mexico$colaboracion)*100



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



spain_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Spain' group by a.year, b.area_desc")
spain_disc_total <-  fetch(spain_disc_total, n=-1)
spain_disc_total <- cast(spain_disc_total, year ~ area_desc, value='cant')
spain_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Spain') and a.country  <>'Spain' group by a.year, b.area_desc")
spain_disc_colab <-  fetch(spain_disc_colab, n=-1)
spain_disc_colab <- cast(spain_disc_colab, year ~ area_desc, value='cant')
spain <- left_join(spain, spain_disc_total, by = "year")
spain <- left_join(spain, spain_disc_colab, by = "year")

spain$ratio_health_total <- (spain$`Health Sciences.x` / spain$total)*100
spain$ratio_life_total <- (spain$`Life Sciences.x` / spain$total)*100
spain$ratio_physical_total <- (spain$`Physical Sciences.x` / spain$total)*100
spain$ratio_social_total <- (spain$`Social Sciences.x` / spain$total)*100
spain$ratio_colab <- (spain$colaboracion / spain$total)*100
spain$ratio_health_colab <- (spain$`Health Sciences.y` / spain$colaboracion)*100
spain$ratio_life_colab <- (spain$`Life Sciences.y` / spain$colaboracion)*100
spain$ratio_physical_colab <- (spain$`Physical Sciences.y` / spain$colaboracion)*100
spain$ratio_social_colab <- (spain$`Social Sciences.y` / spain$colaboracion)*100


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


portugal_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Portugal' group by a.year, b.area_desc")
portugal_disc_total <-  fetch(portugal_disc_total, n=-1)
portugal_disc_total <- cast(portugal_disc_total, year ~ area_desc, value='cant')
portugal_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Portugal') and a.country  <>'Portugal' group by a.year, b.area_desc")
portugal_disc_colab <-  fetch(portugal_disc_colab, n=-1)
portugal_disc_colab <- cast(portugal_disc_colab, year ~ area_desc, value='cant')
portugal <- left_join(portugal, portugal_disc_total, by = "year")
portugal <- left_join(portugal, portugal_disc_colab, by = "year")

portugal$ratio_health_total <- (portugal$`Health Sciences.x` / portugal$total)*100
portugal$ratio_life_total <- (portugal$`Life Sciences.x` / portugal$total)*100
portugal$ratio_physical_total <- (portugal$`Physical Sciences.x` / portugal$total)*100
portugal$ratio_social_total <- (portugal$`Social Sciences.x` / portugal$total)*100
portugal$ratio_colab <- (portugal$colaboracion / portugal$total)*100
portugal$ratio_health_colab <- (portugal$`Health Sciences.y` / portugal$colaboracion)*100
portugal$ratio_life_colab <- (portugal$`Life Sciences.y` / portugal$colaboracion)*100
portugal$ratio_physical_colab <- (portugal$`Physical Sciences.y` / portugal$colaboracion)*100
portugal$ratio_social_colab <- (portugal$`Social Sciences.y` / portugal$colaboracion)*100

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

colombia_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Colombia' group by a.year, b.area_desc")
colombia_disc_total <-  fetch(colombia_disc_total, n=-1)
colombia_disc_total <- cast(colombia_disc_total, year ~ area_desc, value='cant')
colombia_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Colombia') and a.country  <>'Colombia' group by a.year, b.area_desc")
colombia_disc_colab <-  fetch(colombia_disc_colab, n=-1)
colombia_disc_colab <- cast(colombia_disc_colab, year ~ area_desc, value='cant')
colombia <- left_join(colombia, colombia_disc_total, by = "year")
colombia <- left_join(colombia, colombia_disc_colab, by = "year")

colombia$ratio_health_total <- (colombia$`Health Sciences.x` / colombia$total)*100
colombia$ratio_life_total <- (colombia$`Life Sciences.x` / colombia$total)*100
colombia$ratio_physical_total <- (colombia$`Physical Sciences.x` / colombia$total)*100
colombia$ratio_social_total <- (colombia$`Social Sciences.x` / colombia$total)*100
colombia$ratio_colab <- (colombia$colaboracion / colombia$total)*100
colombia$ratio_health_colab <- (colombia$`Health Sciences.y` / colombia$colaboracion)*100
colombia$ratio_life_colab <- (colombia$`Life Sciences.y` / colombia$colaboracion)*100
colombia$ratio_physical_colab <- (colombia$`Physical Sciences.y` / colombia$colaboracion)*100
colombia$ratio_social_colab <- (colombia$`Social Sciences.y` / colombia$colaboracion)*100
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

chile_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Chile' group by a.year, b.area_desc")
chile_disc_total <-  fetch(chile_disc_total, n=-1)
chile_disc_total <- cast(chile_disc_total, year ~ area_desc, value='cant')
chile_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Chile') and a.country  <>'Chile' group by a.year, b.area_desc")
chile_disc_colab <-  fetch(chile_disc_colab, n=-1)
chile_disc_colab <- cast(chile_disc_colab, year ~ area_desc, value='cant')
chile <- left_join(chile, chile_disc_total, by = "year")
chile <- left_join(chile, chile_disc_colab, by = "year")

chile$ratio_health_total <- (chile$`Health Sciences.x` / chile$total)*100
chile$ratio_life_total <- (chile$`Life Sciences.x` / chile$total)*100
chile$ratio_physical_total <- (chile$`Physical Sciences.x` / chile$total)*100
chile$ratio_social_total <- (chile$`Social Sciences.x` / chile$total)*100
chile$ratio_colab <- (chile$colaboracion / chile$total)*100
chile$ratio_health_colab <- (chile$`Health Sciences.y` / chile$colaboracion)*100
chile$ratio_life_colab <- (chile$`Life Sciences.y` / chile$colaboracion)*100
chile$ratio_physical_colab <- (chile$`Physical Sciences.y` / chile$colaboracion)*100
chile$ratio_social_colab <- (chile$`Social Sciences.y` / chile$colaboracion)*100
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


bolivia_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Bolivia' group by a.year, b.area_desc")
bolivia_disc_total <-  fetch(bolivia_disc_total, n=-1)
bolivia_disc_total <- cast(bolivia_disc_total, year ~ area_desc, value='cant')
bolivia_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Bolivia') and a.country  <>'Bolivia' group by a.year, b.area_desc")
bolivia_disc_colab <-  fetch(bolivia_disc_colab, n=-1)
bolivia_disc_colab <- cast(bolivia_disc_colab, year ~ area_desc, value='cant')
bolivia <- left_join(bolivia, bolivia_disc_total, by = "year")
bolivia <- left_join(bolivia, bolivia_disc_colab, by = "year")

bolivia$ratio_health_total <- (bolivia$`Health Sciences.x` / bolivia$total)*100
bolivia$ratio_life_total <- (bolivia$`Life Sciences.x` / bolivia$total)*100
bolivia$ratio_physical_total <- (bolivia$`Physical Sciences.x` / bolivia$total)*100
bolivia$ratio_social_total <- (bolivia$`Social Sciences.x` / bolivia$total)*100
bolivia$ratio_colab <- (bolivia$colaboracion / bolivia$total)*100
bolivia$ratio_health_colab <- (bolivia$`Health Sciences.y` / bolivia$colaboracion)*100
bolivia$ratio_life_colab <- (bolivia$`Life Sciences.y` / bolivia$colaboracion)*100
bolivia$ratio_physical_colab <- (bolivia$`Physical Sciences.y` / bolivia$colaboracion)*100
bolivia$ratio_social_colab <- (bolivia$`Social Sciences.y` / bolivia$colaboracion)*100





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




barbados_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Barbados' group by a.year, b.area_desc")
barbados_disc_total <-  fetch(barbados_disc_total, n=-1)
barbados_disc_total <- cast(barbados_disc_total, year ~ area_desc, value='cant')
barbados_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Barbados') and a.country  <>'Barbados' group by a.year, b.area_desc")
barbados_disc_colab <-  fetch(barbados_disc_colab, n=-1)
barbados_disc_colab <- cast(barbados_disc_colab, year ~ area_desc, value='cant')
barbados <- left_join(barbados, barbados_disc_total, by = "year")
barbados <- left_join(barbados, barbados_disc_colab, by = "year")

barbados$ratio_health_total <- (barbados$`Health Sciences.x` / barbados$total)*100
barbados$ratio_life_total <- (barbados$`Life Sciences.x` / barbados$total)*100
barbados$ratio_physical_total <- (barbados$`Physical Sciences.x` / barbados$total)*100
barbados$ratio_social_total <- (barbados$`Social Sciences.x` / barbados$total)*100
barbados$ratio_colab <- (barbados$colaboracion / barbados$total)*100
barbados$ratio_health_colab <- (barbados$`Health Sciences.y` / barbados$colaboracion)*100
barbados$ratio_life_colab <- (barbados$`Life Sciences.y` / barbados$colaboracion)*100
barbados$ratio_physical_colab <- (barbados$`Physical Sciences.y` / barbados$colaboracion)*100
barbados$ratio_social_colab <- (barbados$`Social Sciences.y` / barbados$colaboracion)*100




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



costa_rica_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Costa Rica' group by a.year, b.area_desc")
costa_rica_disc_total <-  fetch(costa_rica_disc_total, n=-1)
costa_rica_disc_total <- cast(costa_rica_disc_total, year ~ area_desc, value='cant')
costa_rica_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Costa Rica') and a.country  <>'Costa Rica' group by a.year, b.area_desc")
costa_rica_disc_colab <-  fetch(costa_rica_disc_colab, n=-1)
costa_rica_disc_colab <- cast(costa_rica_disc_colab, year ~ area_desc, value='cant')
costa_rica <- left_join(costa_rica, costa_rica_disc_total, by = "year")
costa_rica <- left_join(costa_rica, costa_rica_disc_colab, by = "year")

costa_rica$ratio_health_total <- (costa_rica$`Health Sciences.x` / costa_rica$total)*100
costa_rica$ratio_life_total <- (costa_rica$`Life Sciences.x` / costa_rica$total)*100
costa_rica$ratio_physical_total <- (costa_rica$`Physical Sciences.x` / costa_rica$total)*100
costa_rica$ratio_social_total <- (costa_rica$`Social Sciences.x` / costa_rica$total)*100
costa_rica$ratio_colab <- (costa_rica$colaboracion / costa_rica$total)*100
costa_rica$ratio_health_colab <- (costa_rica$`Health Sciences.y` / costa_rica$colaboracion)*100
costa_rica$ratio_life_colab <- (costa_rica$`Life Sciences.y` / costa_rica$colaboracion)*100
costa_rica$ratio_physical_colab <- (costa_rica$`Physical Sciences.y` / costa_rica$colaboracion)*100
costa_rica$ratio_social_colab <- (costa_rica$`Social Sciences.y` / costa_rica$colaboracion)*100



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


cuba_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Cuba' group by a.year, b.area_desc")
cuba_disc_total <-  fetch(cuba_disc_total, n=-1)
cuba_disc_total <- cast(cuba_disc_total, year ~ area_desc, value='cant')
cuba_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Cuba') and a.country  <>'Cuba' group by a.year, b.area_desc")
cuba_disc_colab <-  fetch(cuba_disc_colab, n=-1)
cuba_disc_colab <- cast(cuba_disc_colab, year ~ area_desc, value='cant')
cuba <- left_join(cuba, cuba_disc_total, by = "year")
cuba <- left_join(cuba, cuba_disc_colab, by = "year")

cuba$ratio_health_total <- (cuba$`Health Sciences.x` / cuba$total)*100
cuba$ratio_life_total <- (cuba$`Life Sciences.x` / cuba$total)*100
cuba$ratio_physical_total <- (cuba$`Physical Sciences.x` / cuba$total)*100
cuba$ratio_social_total <- (cuba$`Social Sciences.x` / cuba$total)*100
cuba$ratio_colab <- (cuba$colaboracion / cuba$total)*100
cuba$ratio_health_colab <- (cuba$`Health Sciences.y` / cuba$colaboracion)*100
cuba$ratio_life_colab <- (cuba$`Life Sciences.y` / cuba$colaboracion)*100
cuba$ratio_physical_colab <- (cuba$`Physical Sciences.y` / cuba$colaboracion)*100
cuba$ratio_social_colab <- (cuba$`Social Sciences.y` / cuba$colaboracion)*100

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


ecuador_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Ecuador' group by a.year, b.area_desc")
ecuador_disc_total <-  fetch(ecuador_disc_total, n=-1)
ecuador_disc_total <- cast(ecuador_disc_total, year ~ area_desc, value='cant')
ecuador_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Ecuador') and a.country  <>'Ecuador' group by a.year, b.area_desc")
ecuador_disc_colab <-  fetch(ecuador_disc_colab, n=-1)
ecuador_disc_colab <- cast(ecuador_disc_colab, year ~ area_desc, value='cant')
ecuador <- left_join(ecuador, ecuador_disc_total, by = "year")
ecuador <- left_join(ecuador, ecuador_disc_colab, by = "year")

ecuador$ratio_health_total <- (ecuador$`Health Sciences.x` / ecuador$total)*100
ecuador$ratio_life_total <- (ecuador$`Life Sciences.x` / ecuador$total)*100
ecuador$ratio_physical_total <- (ecuador$`Physical Sciences.x` / ecuador$total)*100
ecuador$ratio_social_total <- (ecuador$`Social Sciences.x` / ecuador$total)*100
ecuador$ratio_colab <- (ecuador$colaboracion / ecuador$total)*100
ecuador$ratio_health_colab <- (ecuador$`Health Sciences.y` / ecuador$colaboracion)*100
ecuador$ratio_life_colab <- (ecuador$`Life Sciences.y` / ecuador$colaboracion)*100
ecuador$ratio_physical_colab <- (ecuador$`Physical Sciences.y` / ecuador$colaboracion)*100
ecuador$ratio_social_colab <- (ecuador$`Social Sciences.y` / ecuador$colaboracion)*100

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


el_salvador_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='El Salvador' group by a.year, b.area_desc")
el_salvador_disc_total <-  fetch(el_salvador_disc_total, n=-1)
el_salvador_disc_total <- cast(el_salvador_disc_total, year ~ area_desc, value='cant')
el_salvador_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='El Salvador') and a.country  <>'El Salvador' group by a.year, b.area_desc")
el_salvador_disc_colab <-  fetch(el_salvador_disc_colab, n=-1)
el_salvador_disc_colab <- cast(el_salvador_disc_colab, year ~ area_desc, value='cant')
el_salvador <- left_join(el_salvador, el_salvador_disc_total, by = "year")
el_salvador <- left_join(el_salvador, el_salvador_disc_colab, by = "year")

el_salvador$ratio_health_total <- (el_salvador$`Health Sciences.x` / el_salvador$total)*100
el_salvador$ratio_life_total <- (el_salvador$`Life Sciences.x` / el_salvador$total)*100
el_salvador$ratio_physical_total <- (el_salvador$`Physical Sciences.x` / el_salvador$total)*100
el_salvador$ratio_social_total <- (el_salvador$`Social Sciences.x` / el_salvador$total)*100
el_salvador$ratio_colab <- (el_salvador$colaboracion / el_salvador$total)*100
el_salvador$ratio_health_colab <- (el_salvador$`Health Sciences.y` / el_salvador$colaboracion)*100
el_salvador$ratio_life_colab <- (el_salvador$`Life Sciences.y` / el_salvador$colaboracion)*100
el_salvador$ratio_physical_colab <- (el_salvador$`Physical Sciences.y` / el_salvador$colaboracion)*100
el_salvador$ratio_social_colab <- (el_salvador$`Social Sciences.y` / el_salvador$colaboracion)*100


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


guatemala_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Guatemala' group by a.year, b.area_desc")
guatemala_disc_total <-  fetch(guatemala_disc_total, n=-1)
guatemala_disc_total <- cast(guatemala_disc_total, year ~ area_desc, value='cant')
guatemala_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Guatemala') and a.country  <>'Guatemala' group by a.year, b.area_desc")
guatemala_disc_colab <-  fetch(guatemala_disc_colab, n=-1)
guatemala_disc_colab <- cast(guatemala_disc_colab, year ~ area_desc, value='cant')
guatemala <- left_join(guatemala, guatemala_disc_total, by = "year")
guatemala <- left_join(guatemala, guatemala_disc_colab, by = "year")

guatemala$ratio_health_total <- (guatemala$`Health Sciences.x` / guatemala$total)*100
guatemala$ratio_life_total <- (guatemala$`Life Sciences.x` / guatemala$total)*100
guatemala$ratio_physical_total <- (guatemala$`Physical Sciences.x` / guatemala$total)*100
guatemala$ratio_social_total <- (guatemala$`Social Sciences.x` / guatemala$total)*100
guatemala$ratio_colab <- (guatemala$colaboracion / guatemala$total)*100
guatemala$ratio_health_colab <- (guatemala$`Health Sciences.y` / guatemala$colaboracion)*100
guatemala$ratio_life_colab <- (guatemala$`Life Sciences.y` / guatemala$colaboracion)*100
guatemala$ratio_physical_colab <- (guatemala$`Physical Sciences.y` / guatemala$colaboracion)*100
guatemala$ratio_social_colab <- (guatemala$`Social Sciences.y` / guatemala$colaboracion)*100



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

guyana_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Guyana' group by a.year, b.area_desc")
guyana_disc_total <-  fetch(guyana_disc_total, n=-1)
guyana_disc_total <- cast(guyana_disc_total, year ~ area_desc, value='cant')
guyana_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Guyana') and a.country  <>'Guyana' group by a.year, b.area_desc")
guyana_disc_colab <-  fetch(guyana_disc_colab, n=-1)
guyana_disc_colab <- cast(guyana_disc_colab, year ~ area_desc, value='cant')
guyana <- left_join(guyana, guyana_disc_total, by = "year")
guyana <- left_join(guyana, guyana_disc_colab, by = "year")

guyana$ratio_health_total <- (guyana$`Health Sciences.x` / guyana$total)*100
guyana$ratio_life_total <- (guyana$`Life Sciences.x` / guyana$total)*100
guyana$ratio_physical_total <- (guyana$`Physical Sciences.x` / guyana$total)*100
guyana$ratio_social_total <- (guyana$`Social Sciences.x` / guyana$total)*100
guyana$ratio_colab <- (guyana$colaboracion / guyana$total)*100
guyana$ratio_health_colab <- (guyana$`Health Sciences.y` / guyana$colaboracion)*100
guyana$ratio_life_colab <- (guyana$`Life Sciences.y` / guyana$colaboracion)*100
guyana$ratio_physical_colab <- (guyana$`Physical Sciences.y` / guyana$colaboracion)*100
guyana$ratio_social_colab <- (guyana$`Social Sciences.y` / guyana$colaboracion)*100



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


haiti_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Haiti' group by a.year, b.area_desc")
haiti_disc_total <-  fetch(haiti_disc_total, n=-1)
haiti_disc_total <- cast(haiti_disc_total, year ~ area_desc, value='cant')
haiti_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Haiti') and a.country  <>'Haiti' group by a.year, b.area_desc")
haiti_disc_colab <-  fetch(haiti_disc_colab, n=-1)
haiti_disc_colab <- cast(haiti_disc_colab, year ~ area_desc, value='cant')
haiti <- left_join(haiti, haiti_disc_total, by = "year")
haiti <- left_join(haiti, haiti_disc_colab, by = "year")

haiti$ratio_health_total <- (haiti$`Health Sciences.x` / haiti$total)*100
haiti$ratio_life_total <- (haiti$`Life Sciences.x` / haiti$total)*100
haiti$ratio_physical_total <- (haiti$`Physical Sciences.x` / haiti$total)*100
haiti$ratio_social_total <- (haiti$`Social Sciences.x` / haiti$total)*100
haiti$ratio_colab <- (haiti$colaboracion / haiti$total)*100
haiti$ratio_health_colab <- (haiti$`Health Sciences.y` / haiti$colaboracion)*100
haiti$ratio_life_colab <- (haiti$`Life Sciences.y` / haiti$colaboracion)*100
haiti$ratio_physical_colab <- (haiti$`Physical Sciences.y` / haiti$colaboracion)*100
haiti$ratio_social_colab <- (haiti$`Social Sciences.y` / haiti$colaboracion)*100



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

honduras_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Honduras' group by a.year, b.area_desc")
honduras_disc_total <-  fetch(honduras_disc_total, n=-1)
honduras_disc_total <- cast(honduras_disc_total, year ~ area_desc, value='cant')
honduras_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Honduras') and a.country  <>'Honduras' group by a.year, b.area_desc")
honduras_disc_colab <-  fetch(honduras_disc_colab, n=-1)
honduras_disc_colab <- cast(honduras_disc_colab, year ~ area_desc, value='cant')
honduras <- left_join(honduras, honduras_disc_total, by = "year")
honduras <- left_join(honduras, honduras_disc_colab, by = "year")

honduras$ratio_health_total <- (honduras$`Health Sciences.x` / honduras$total)*100
honduras$ratio_life_total <- (honduras$`Life Sciences.x` / honduras$total)*100
honduras$ratio_physical_total <- (honduras$`Physical Sciences.x` / honduras$total)*100
honduras$ratio_social_total <- (honduras$`Social Sciences.x` / honduras$total)*100
honduras$ratio_colab <- (honduras$colaboracion / honduras$total)*100
honduras$ratio_health_colab <- (honduras$`Health Sciences.y` / honduras$colaboracion)*100
honduras$ratio_life_colab <- (honduras$`Life Sciences.y` / honduras$colaboracion)*100
honduras$ratio_physical_colab <- (honduras$`Physical Sciences.y` / honduras$colaboracion)*100
honduras$ratio_social_colab <- (honduras$`Social Sciences.y` / honduras$colaboracion)*100



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


jamaica_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Jamaica' group by a.year, b.area_desc")
jamaica_disc_total <-  fetch(jamaica_disc_total, n=-1)
jamaica_disc_total <- cast(jamaica_disc_total, year ~ area_desc, value='cant')
jamaica_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Jamaica') and a.country  <>'Jamaica' group by a.year, b.area_desc")
jamaica_disc_colab <-  fetch(jamaica_disc_colab, n=-1)
jamaica_disc_colab <- cast(jamaica_disc_colab, year ~ area_desc, value='cant')
jamaica <- left_join(jamaica, jamaica_disc_total, by = "year")
jamaica <- left_join(jamaica, jamaica_disc_colab, by = "year")

jamaica$ratio_health_total <- (jamaica$`Health Sciences.x` / jamaica$total)*100
jamaica$ratio_life_total <- (jamaica$`Life Sciences.x` / jamaica$total)*100
jamaica$ratio_physical_total <- (jamaica$`Physical Sciences.x` / jamaica$total)*100
jamaica$ratio_social_total <- (jamaica$`Social Sciences.x` / jamaica$total)*100
jamaica$ratio_colab <- (jamaica$colaboracion / jamaica$total)*100
jamaica$ratio_health_colab <- (jamaica$`Health Sciences.y` / jamaica$colaboracion)*100
jamaica$ratio_life_colab <- (jamaica$`Life Sciences.y` / jamaica$colaboracion)*100
jamaica$ratio_physical_colab <- (jamaica$`Physical Sciences.y` / jamaica$colaboracion)*100
jamaica$ratio_social_colab <- (jamaica$`Social Sciences.y` / jamaica$colaboracion)*100




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


nicaragua_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Nicaragua' group by a.year, b.area_desc")
nicaragua_disc_total <-  fetch(nicaragua_disc_total, n=-1)
nicaragua_disc_total <- cast(nicaragua_disc_total, year ~ area_desc, value='cant')
nicaragua_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Nicaragua') and a.country  <>'Nicaragua' group by a.year, b.area_desc")
nicaragua_disc_colab <-  fetch(nicaragua_disc_colab, n=-1)
nicaragua_disc_colab <- cast(nicaragua_disc_colab, year ~ area_desc, value='cant')
nicaragua <- left_join(nicaragua, nicaragua_disc_total, by = "year")
nicaragua <- left_join(nicaragua, nicaragua_disc_colab, by = "year")

nicaragua$ratio_health_total <- (nicaragua$`Health Sciences.x` / nicaragua$total)*100
nicaragua$ratio_life_total <- (nicaragua$`Life Sciences.x` / nicaragua$total)*100
nicaragua$ratio_physical_total <- (nicaragua$`Physical Sciences.x` / nicaragua$total)*100
nicaragua$ratio_social_total <- (nicaragua$`Social Sciences.x` / nicaragua$total)*100
nicaragua$ratio_colab <- (nicaragua$colaboracion / nicaragua$total)*100
nicaragua$ratio_health_colab <- (nicaragua$`Health Sciences.y` / nicaragua$colaboracion)*100
nicaragua$ratio_life_colab <- (nicaragua$`Life Sciences.y` / nicaragua$colaboracion)*100
nicaragua$ratio_physical_colab <- (nicaragua$`Physical Sciences.y` / nicaragua$colaboracion)*100
nicaragua$ratio_social_colab <- (nicaragua$`Social Sciences.y` / nicaragua$colaboracion)*100



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


panama_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Panama' group by a.year, b.area_desc")
panama_disc_total <-  fetch(panama_disc_total, n=-1)
panama_disc_total <- cast(panama_disc_total, year ~ area_desc, value='cant')
panama_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Panama') and a.country  <>'Panama' group by a.year, b.area_desc")
panama_disc_colab <-  fetch(panama_disc_colab, n=-1)
panama_disc_colab <- cast(panama_disc_colab, year ~ area_desc, value='cant')
panama <- left_join(panama, panama_disc_total, by = "year")
panama <- left_join(panama, panama_disc_colab, by = "year")

panama$ratio_health_total <- (panama$`Health Sciences.x` / panama$total)*100
panama$ratio_life_total <- (panama$`Life Sciences.x` / panama$total)*100
panama$ratio_physical_total <- (panama$`Physical Sciences.x` / panama$total)*100
panama$ratio_social_total <- (panama$`Social Sciences.x` / panama$total)*100
panama$ratio_colab <- (panama$colaboracion / panama$total)*100
panama$ratio_health_colab <- (panama$`Health Sciences.y` / panama$colaboracion)*100
panama$ratio_life_colab <- (panama$`Life Sciences.y` / panama$colaboracion)*100
panama$ratio_physical_colab <- (panama$`Physical Sciences.y` / panama$colaboracion)*100
panama$ratio_social_colab <- (panama$`Social Sciences.y` / panama$colaboracion)*100



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


paraguay_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Paraguay' group by a.year, b.area_desc")
paraguay_disc_total <-  fetch(paraguay_disc_total, n=-1)
paraguay_disc_total <- cast(paraguay_disc_total, year ~ area_desc, value='cant')
paraguay_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Paraguay') and a.country  <>'Paraguay' group by a.year, b.area_desc")
paraguay_disc_colab <-  fetch(paraguay_disc_colab, n=-1)
paraguay_disc_colab <- cast(paraguay_disc_colab, year ~ area_desc, value='cant')
paraguay <- left_join(paraguay, paraguay_disc_total, by = "year")
paraguay <- left_join(paraguay, paraguay_disc_colab, by = "year")

paraguay$ratio_health_total <- (paraguay$`Health Sciences.x` / paraguay$total)*100
paraguay$ratio_life_total <- (paraguay$`Life Sciences.x` / paraguay$total)*100
paraguay$ratio_physical_total <- (paraguay$`Physical Sciences.x` / paraguay$total)*100
paraguay$ratio_social_total <- (paraguay$`Social Sciences.x` / paraguay$total)*100
paraguay$ratio_colab <- (paraguay$colaboracion / paraguay$total)*100
paraguay$ratio_health_colab <- (paraguay$`Health Sciences.y` / paraguay$colaboracion)*100
paraguay$ratio_life_colab <- (paraguay$`Life Sciences.y` / paraguay$colaboracion)*100
paraguay$ratio_physical_colab <- (paraguay$`Physical Sciences.y` / paraguay$colaboracion)*100
paraguay$ratio_social_colab <- (paraguay$`Social Sciences.y` / paraguay$colaboracion)*100

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


peru_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Peru' group by a.year, b.area_desc")
peru_disc_total <-  fetch(peru_disc_total, n=-1)
peru_disc_total <- cast(peru_disc_total, year ~ area_desc, value='cant')
peru_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Peru') and a.country  <>'Peru' group by a.year, b.area_desc")
peru_disc_colab <-  fetch(peru_disc_colab, n=-1)
peru_disc_colab <- cast(peru_disc_colab, year ~ area_desc, value='cant')
peru <- left_join(peru, peru_disc_total, by = "year")
peru <- left_join(peru, peru_disc_colab, by = "year")

peru$ratio_health_total <- (peru$`Health Sciences.x` / peru$total)*100
peru$ratio_life_total <- (peru$`Life Sciences.x` / peru$total)*100
peru$ratio_physical_total <- (peru$`Physical Sciences.x` / peru$total)*100
peru$ratio_social_total <- (peru$`Social Sciences.x` / peru$total)*100
peru$ratio_colab <- (peru$colaboracion / peru$total)*100
peru$ratio_health_colab <- (peru$`Health Sciences.y` / peru$colaboracion)*100
peru$ratio_life_colab <- (peru$`Life Sciences.y` / peru$colaboracion)*100
peru$ratio_physical_colab <- (peru$`Physical Sciences.y` / peru$colaboracion)*100
peru$ratio_social_colab <- (peru$`Social Sciences.y` / peru$colaboracion)*100

peru <- subset(peru, year >=minimo & year <=maximo)



country <- 'Puerto Rico'
puerto_rico_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Puerto Rico' group by year, country")
puerto_rico_total <-  fetch(puerto_rico_total, n=-1)
puerto_rico_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Puerto Rico') and country <>'Puerto Rico' group by year")
puerto_rico_colab <-  fetch(puerto_rico_colab, n=-1)
puerto_rico_colab <- cbind(puerto_rico_colab,country)
puerto_rico <- left_join(puerto_rico_total, puerto_rico_colab, by = c("year", "country"))
names(puerto_rico)[names(puerto_rico)=="count(distinct ut).x"] <- "total"
names(puerto_rico)[names(puerto_rico)=="count(distinct ut).y"] <- "colaboracion"

puerto_rico_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Puerto Rico' group by a.year, b.area_desc")
puerto_rico_disc_total <-  fetch(puerto_rico_disc_total, n=-1)
puerto_rico_disc_total <- cast(puerto_rico_disc_total, year ~ area_desc, value='cant')
puerto_rico_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Puerto Rico') and a.country  <>'Puerto Rico' group by a.year, b.area_desc")
puerto_rico_disc_colab <-  fetch(puerto_rico_disc_colab, n=-1)
puerto_rico_disc_colab <- cast(puerto_rico_disc_colab, year ~ area_desc, value='cant')
puerto_rico <- left_join(puerto_rico, puerto_rico_disc_total, by = "year")
puerto_rico <- left_join(puerto_rico, puerto_rico_disc_colab, by = "year")

puerto_rico$ratio_health_total <- (puerto_rico$`Health Sciences.x` / puerto_rico$total)*100
puerto_rico$ratio_life_total <- (puerto_rico$`Life Sciences.x` / puerto_rico$total)*100
puerto_rico$ratio_physical_total <- (puerto_rico$`Physical Sciences.x` / puerto_rico$total)*100
puerto_rico$ratio_social_total <- (puerto_rico$`Social Sciences.x` / puerto_rico$total)*100
puerto_rico$ratio_colab <- (puerto_rico$colaboracion / puerto_rico$total)*100
puerto_rico$ratio_health_colab <- (puerto_rico$`Health Sciences.y` / puerto_rico$colaboracion)*100
puerto_rico$ratio_life_colab <- (puerto_rico$`Life Sciences.y` / puerto_rico$colaboracion)*100
puerto_rico$ratio_physical_colab <- (puerto_rico$`Physical Sciences.y` / puerto_rico$colaboracion)*100
puerto_rico$ratio_social_colab <- (puerto_rico$`Social Sciences.y` / puerto_rico$colaboracion)*100

puerto_rico <- subset(puerto_rico, year >=minimo & year <=maximo)


country <- 'Dominican Republic'
dominican_republic_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Dominican Republic' group by year, country")
dominican_republic_total <-  fetch(dominican_republic_total, n=-1)
dominican_republic_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Dominican Republic') and country <>'Dominican Republic' group by year")
dominican_republic_colab <-  fetch(dominican_republic_colab, n=-1)
dominican_republic_colab <- cbind(dominican_republic_colab,country)
dominican_republic <- left_join(dominican_republic_total, dominican_republic_colab, by = c("year", "country"))
names(dominican_republic)[names(dominican_republic)=="count(distinct ut).x"] <- "total"
names(dominican_republic)[names(dominican_republic)=="count(distinct ut).y"] <- "colaboracion"



dominican_republic_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Dominican Republic' group by a.year, b.area_desc")
dominican_republic_disc_total <-  fetch(dominican_republic_disc_total, n=-1)
dominican_republic_disc_total <- cast(dominican_republic_disc_total, year ~ area_desc, value='cant')
dominican_republic_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Dominican Republic') and a.country  <>'Dominican Republic' group by a.year, b.area_desc")
dominican_republic_disc_colab <-  fetch(dominican_republic_disc_colab, n=-1)
dominican_republic_disc_colab <- cast(dominican_republic_disc_colab, year ~ area_desc, value='cant')
dominican_republic <- left_join(dominican_republic, dominican_republic_disc_total, by = "year")
dominican_republic <- left_join(dominican_republic, dominican_republic_disc_colab, by = "year")

dominican_republic$ratio_health_total <- (dominican_republic$`Health Sciences.x` / dominican_republic$total)*100
dominican_republic$ratio_life_total <- (dominican_republic$`Life Sciences.x` / dominican_republic$total)*100
dominican_republic$ratio_physical_total <- (dominican_republic$`Physical Sciences.x` / dominican_republic$total)*100
dominican_republic$ratio_social_total <- (dominican_republic$`Social Sciences.x` / dominican_republic$total)*100
dominican_republic$ratio_colab <- (dominican_republic$colaboracion / dominican_republic$total)*100
dominican_republic$ratio_health_colab <- (dominican_republic$`Health Sciences.y` / dominican_republic$colaboracion)*100
dominican_republic$ratio_life_colab <- (dominican_republic$`Life Sciences.y` / dominican_republic$colaboracion)*100
dominican_republic$ratio_physical_colab <- (dominican_republic$`Physical Sciences.y` / dominican_republic$colaboracion)*100
dominican_republic$ratio_social_colab <- (dominican_republic$`Social Sciences.y` / dominican_republic$colaboracion)*100


dominican_republic <- subset(dominican_republic, year >=minimo & year <=maximo)



country <- 'Trinidad and Tobago'
trinidad_and_tobago_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Trinidad and Tobago' group by year, country")
trinidad_and_tobago_total <-  fetch(trinidad_and_tobago_total, n=-1)
trinidad_and_tobago_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Trinidad and Tobago') and country <>'Trinidad and Tobago' group by year")
trinidad_and_tobago_colab <-  fetch(trinidad_and_tobago_colab, n=-1)
trinidad_and_tobago_colab <- cbind(trinidad_and_tobago_colab,country)
trinidad_and_tobago <- left_join(trinidad_and_tobago_total, trinidad_and_tobago_colab, by = c("year", "country"))
names(trinidad_and_tobago)[names(trinidad_and_tobago)=="count(distinct ut).x"] <- "total"
names(trinidad_and_tobago)[names(trinidad_and_tobago)=="count(distinct ut).y"] <- "colaboracion"


trinidad_and_tobago_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Trinidad and Tobago' group by a.year, b.area_desc")
trinidad_and_tobago_disc_total <-  fetch(trinidad_and_tobago_disc_total, n=-1)
trinidad_and_tobago_disc_total <- cast(trinidad_and_tobago_disc_total, year ~ area_desc, value='cant')
trinidad_and_tobago_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Trinidad and Tobago') and a.country  <>'Trinidad and Tobago' group by a.year, b.area_desc")
trinidad_and_tobago_disc_colab <-  fetch(trinidad_and_tobago_disc_colab, n=-1)
trinidad_and_tobago_disc_colab <- cast(trinidad_and_tobago_disc_colab, year ~ area_desc, value='cant')
trinidad_and_tobago <- left_join(trinidad_and_tobago, trinidad_and_tobago_disc_total, by = "year")
trinidad_and_tobago <- left_join(trinidad_and_tobago, trinidad_and_tobago_disc_colab, by = "year")

trinidad_and_tobago$ratio_health_total <- (trinidad_and_tobago$`Health Sciences.x` / trinidad_and_tobago$total)*100
trinidad_and_tobago$ratio_life_total <- (trinidad_and_tobago$`Life Sciences.x` / trinidad_and_tobago$total)*100
trinidad_and_tobago$ratio_physical_total <- (trinidad_and_tobago$`Physical Sciences.x` / trinidad_and_tobago$total)*100
trinidad_and_tobago$ratio_social_total <- (trinidad_and_tobago$`Social Sciences.x` / trinidad_and_tobago$total)*100
trinidad_and_tobago$ratio_colab <- (trinidad_and_tobago$colaboracion / trinidad_and_tobago$total)*100
trinidad_and_tobago$ratio_health_colab <- (trinidad_and_tobago$`Health Sciences.y` / trinidad_and_tobago$colaboracion)*100
trinidad_and_tobago$ratio_life_colab <- (trinidad_and_tobago$`Life Sciences.y` / trinidad_and_tobago$colaboracion)*100
trinidad_and_tobago$ratio_physical_colab <- (trinidad_and_tobago$`Physical Sciences.y` / trinidad_and_tobago$colaboracion)*100
trinidad_and_tobago$ratio_social_colab <- (trinidad_and_tobago$`Social Sciences.y` / trinidad_and_tobago$colaboracion)*100



trinidad_and_tobago <- subset(trinidad_and_tobago, year >=minimo & year <=maximo)


country <- 'Uruguay'
uruguay_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Uruguay' group by year, country")
uruguay_total <-  fetch(uruguay_total, n=-1)
uruguay_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Uruguay') and country <>'Uruguay' group by year")
uruguay_colab <-  fetch(uruguay_colab, n=-1)
uruguay_colab <- cbind(uruguay_colab,country)
uruguay <- left_join(uruguay_total, uruguay_colab, by = c("year", "country"))
names(uruguay)[names(uruguay)=="count(distinct ut).x"] <- "total"
names(uruguay)[names(uruguay)=="count(distinct ut).y"] <- "colaboracion"


uruguay_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Uruguay' group by a.year, b.area_desc")
uruguay_disc_total <-  fetch(uruguay_disc_total, n=-1)
uruguay_disc_total <- cast(uruguay_disc_total, year ~ area_desc, value='cant')
uruguay_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Uruguay') and a.country  <>'Uruguay' group by a.year, b.area_desc")
uruguay_disc_colab <-  fetch(uruguay_disc_colab, n=-1)
uruguay_disc_colab <- cast(uruguay_disc_colab, year ~ area_desc, value='cant')
uruguay <- left_join(uruguay, uruguay_disc_total, by = "year")
uruguay <- left_join(uruguay, uruguay_disc_colab, by = "year")

uruguay$ratio_health_total <- (uruguay$`Health Sciences.x` / uruguay$total)*100
uruguay$ratio_life_total <- (uruguay$`Life Sciences.x` / uruguay$total)*100
uruguay$ratio_physical_total <- (uruguay$`Physical Sciences.x` / uruguay$total)*100
uruguay$ratio_social_total <- (uruguay$`Social Sciences.x` / uruguay$total)*100
uruguay$ratio_colab <- (uruguay$colaboracion / uruguay$total)*100
uruguay$ratio_health_colab <- (uruguay$`Health Sciences.y` / uruguay$colaboracion)*100
uruguay$ratio_life_colab <- (uruguay$`Life Sciences.y` / uruguay$colaboracion)*100
uruguay$ratio_physical_colab <- (uruguay$`Physical Sciences.y` / uruguay$colaboracion)*100
uruguay$ratio_social_colab <- (uruguay$`Social Sciences.y` / uruguay$colaboracion)*100

uruguay <- subset(uruguay, year >=minimo & year <=maximo)


country <- 'Venezuela'
venezuela_total <- dbSendQuery(scopus_ibero, "select year, country, count(distinct ut) from ut_year_country where country='Venezuela' group by year, country")
venezuela_total <-  fetch(venezuela_total, n=-1)
venezuela_colab <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country  where ut in (select distinct ut from ut_year_country where country='Venezuela') and country <>'Venezuela' group by year")
venezuela_colab <-  fetch(venezuela_colab, n=-1)
venezuela_colab <- cbind(venezuela_colab,country)
venezuela <- left_join(venezuela_total, venezuela_colab, by = c("year", "country"))
names(venezuela)[names(venezuela)=="count(distinct ut).x"] <- "total"
names(venezuela)[names(venezuela)=="count(distinct ut).y"] <- "colaboracion"

venezuela_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Venezuela' group by a.year, b.area_desc")
venezuela_disc_total <-  fetch(venezuela_disc_total, n=-1)
venezuela_disc_total <- cast(venezuela_disc_total, year ~ area_desc, value='cant')
venezuela_disc_colab <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut in (select distinct ut from scopus_ibero.ut_year_country where country='Venezuela') and a.country  <>'Venezuela' group by a.year, b.area_desc")
venezuela_disc_colab <-  fetch(venezuela_disc_colab, n=-1)
venezuela_disc_colab <- cast(venezuela_disc_colab, year ~ area_desc, value='cant')
venezuela <- left_join(venezuela, venezuela_disc_total, by = "year")
venezuela <- left_join(venezuela, venezuela_disc_colab, by = "year")

venezuela$ratio_health_total <- (venezuela$`Health Sciences.x` / venezuela$total)*100
venezuela$ratio_life_total <- (venezuela$`Life Sciences.x` / venezuela$total)*100
venezuela$ratio_physical_total <- (venezuela$`Physical Sciences.x` / venezuela$total)*100
venezuela$ratio_social_total <- (venezuela$`Social Sciences.x` / venezuela$total)*100
venezuela$ratio_colab <- (venezuela$colaboracion / venezuela$total)*100
venezuela$ratio_health_colab <- (venezuela$`Health Sciences.y` / venezuela$colaboracion)*100
venezuela$ratio_life_colab <- (venezuela$`Life Sciences.y` / venezuela$colaboracion)*100
venezuela$ratio_physical_colab <- (venezuela$`Physical Sciences.y` / venezuela$colaboracion)*100
venezuela$ratio_social_colab <- (venezuela$`Social Sciences.y` / venezuela$colaboracion)*100

venezuela <- subset(venezuela, year >=minimo & year <=maximo)


########################JUNTAR DATOS#####################

total <- rbind(brazil,spain,argentina,mexico,portugal,chile,
               colombia,ecuador,cuba,bolivia,barbados,costa_rica,
               el_salvador, guatemala,guyana,haiti,honduras,
               jamaica,nicaragua,panama,paraguay,peru,puerto_rico, 
               dominican_republic,trinidad_and_tobago,uruguay,venezuela)

plot_ly(total, x = ~year, y = ~ratio_colab, type = 'scatter',  color = ~country, mode = 'lines')



###REGIONALES###


americalatina_total <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country where (country='Argentina'  or country='Barbados' or country='Bolivia' or country='Brazil' or country='Chile' or country='Colombia' or country='Costa Rica' or country='Cuba' or country='Ecuador' or country='El Salvador' or country='Guatemala' or country='Honduras' or country='Jamaica' or country='Mexico' or country='Nicaragua' or country='Panama' or country='Paraguay' or country='Peru' or country='Uruguay' or country='Venezuela') group by year")
americalatina_total <-  fetch(americalatina_total, n=-1)

americalatina_total_disc <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant  from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and  (a.country='Argentina'  or a.country='Barbados' or a.country='Bolivia' or a.country='Brazil' or a.country='Chile' or a.country='Colombia' or a.country='Costa Rica' or a.country='Cuba' or a.country='Ecuador' or a.country='El Salvador' or a.country='Guatemala' or a.country='Honduras' or a.country='Jamaica' or a.country='Mexico' or a.country='Nicaragua' or a.country='Panama' or a.country='Paraguay' or a.country='Peru' or a.country='Uruguay' or a.country='Venezuela') group by a.year, b.area_desc")
americalatina_total_disc <-  fetch(americalatina_total_disc, n=-1)



iberoamerica_total <- dbSendQuery(scopus_ibero, "select year, count(distinct ut) from ut_year_country where (country='Argentina' or country='Bolivia' or country='Brazil' or country='Chile' or country='Colombia' or country='Costa Rica' or country='Cuba' or country='Ecuador' or country='El Salvador' or country='Guatemala' or country='Honduras' or country='Mexico' or country='Nicaragua' or country='Panama' or country='Paraguay' or country='Peru' or country='Uruguay' or country='Venezuela' or country='Spain' or country='Portugal') group by year")
iberoamerica_total <-  fetch(iberoamerica_total, n=-1)

iberoamerica_total_disc <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant  from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and  (a.country='Argentina'  or a.country='Bolivia' or a.country='Brazil' or a.country='Chile' or a.country='Colombia' or a.country='Costa Rica' or a.country='Cuba' or a.country='Ecuador' or a.country='El Salvador' or a.country='Guatemala' or a.country='Honduras' or a.country='Mexico' or a.country='Nicaragua' or a.country='Panama' or a.country='Paraguay' or a.country='Peru' or a.country='Uruguay' or a.country='Venezuela' or a.country='Spain' or a.country='Portugal') group by a.year, b.area_desc")
iberoamerica_total_disc <-  fetch(iberoamerica_total_disc, n=-1)
View(iberoamerica_total_disc)







#setwd("~/SCI_genero")
#setwd(".")
#write.csv(total, 'colaboracion.csv')






