
#####LIBRERIAS
library(DBI)
library(RMySQL)
library(Hmisc)
library(dplyr)
library(plotly)
library(reshape)
library(dplyr)
library(tidyr)

source('C:/Users/observatorio/Documents/SCI_genero/00-sql.r', encoding = 'latin1')

###chequear conexion###
scopus_ibero

####QUERY PARA CREAR LA TABLA INICIAL, CREA UN LISTADO DE UTS POR CADA PAIS QUE PARTICIPA ####
###create table ut_year_country as select distinct b.country, a.ut, a.year, a.pub_name from article a, address b where a.ut=b.ut; ####

minimo=2010
maximo=2017

####Primero debo crear una base ut_year_country en la base de datos####
####ESTA CONSULTA TARDA BASTANTE#########

ut_year_country <- dbSendQuery(scopus_ibero, "select b.country, a.ut, a.year, a.pub_name from article a, author_address b where a.ut=b.ut")
ut_year_country <-  fetch(ut_year_country, n=-1)
ut_year_country <- unique(ut_year_country)

dbWriteTable(scopus_ibero, name='ut_year_country', value=ut_year_country, overwrite = TRUE, row.names = FALSE)


############################################TABLAS POR PAÍS##############################

country <- 'Argentina'

argentina_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Argentina' group by year")
argentina_total <-  fetch(argentina_total, n=-1)
argentina_total <- cbind(argentina_total,country)
names(argentina_total)[names(argentina_total)=="count(distinct a.ut)"] <- "total"

argentina_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Argentina' and address like '%Univ%' group by year")
argentina_edsup <-  fetch(argentina_edsup, n=-1)
argentina_edsup <- cbind(argentina_edsup,country)
names(argentina_edsup)[names(argentina_edsup)=="count(distinct a.ut)"] <- "ed_sup"
argentina <- left_join(argentina_total, argentina_edsup, by = c("year", "country"))
argentina <- subset(argentina, year >=minimo & year <=maximo)
argentina$ratio <- (argentina$ed_sup / argentina$total)*100

argentina_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Argentina' group by a.year, b.area_desc")
argentina_disc_total <-  fetch(argentina_disc_total, n=-1)
argentina_disc_total <- cast(argentina_disc_total, year ~ area_desc, value='cant')
argentina_disc_total <- cbind(argentina_disc_total,country)

argentina <- left_join(argentina, argentina_disc_total, by = c("year", "country"))

argentina_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='Argentina' and c.address like '%Univ%' group by a.year, b.area_desc")
argentina_disc_edsup <-  fetch(argentina_disc_edsup, n=-1)
argentina_disc_edsup <- cast(argentina_disc_edsup, year ~ area_desc, value='cant')
argentina_disc_edsup <- cbind(argentina_disc_edsup,country)

argentina <- left_join(argentina, argentina_disc_edsup, by = c("year", "country"))

argentina$HealthSciences_ratio <- (argentina$`Health Sciences.y` / argentina$`Health Sciences.x`)*100
argentina$LifeSciences_ratio <- (argentina$`Life Sciences.y` / argentina$`Life Sciences.x`)*100
argentina$PhysicalSciences_ratio <- (argentina$`Physical Sciences.y` / argentina$`Physical Sciences.x`)*100
argentina$SocialSciences_ratio <- (argentina$`Social Sciences.y`/ argentina$`Social Sciences.x`)*100
argentina$HealthSciences_ratio_total <- (argentina$`Health Sciences.x` / argentina$total)*100
argentina$LifeSciences_ratio_total <- (argentina$`Life Sciences.x` / argentina$total)*100
argentina$PhysicalSciences_ratio_total <- (argentina$`Physical Sciences.x` / argentina$total)*100
argentina$SocialSciences_ratio_total <- (argentina$`Social Sciences.x`/ argentina$total)*100
argentina$HealthSciences_ratio_educ <- (argentina$`Health Sciences.y` / argentina$ed_sup)*100
argentina$LifeSciences_ratio_educ <- (argentina$`Life Sciences.y` / argentina$ed_sup)*100
argentina$PhysicalSciences_ratio_educ <- (argentina$`Physical Sciences.y` / argentina$ed_sup)*100
argentina$SocialSciences_ratio_educ <- (argentina$`Social Sciences.y`/ argentina$ed_sup)*100



country <- 'Chile'

chile_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Chile' group by year")
chile_total <-  fetch(chile_total, n=-1)
chile_total <- cbind(chile_total,country)
names(chile_total)[names(chile_total)=="count(distinct a.ut)"] <- "total"

chile_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Chile' and address like '%Univ%' group by year")
chile_edsup <-  fetch(chile_edsup, n=-1)
chile_edsup <- cbind(chile_edsup,country)
names(chile_edsup)[names(chile_edsup)=="count(distinct a.ut)"] <- "ed_sup"
chile <- left_join(chile_total, chile_edsup, by = c("year", "country"))
chile <- subset(chile, year >=minimo & year <=maximo)
chile$ratio <- (chile$ed_sup / chile$total)*100

chile_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Chile' group by a.year, b.area_desc")
chile_disc_total <-  fetch(chile_disc_total, n=-1)
chile_disc_total <- cast(chile_disc_total, year ~ area_desc, value='cant')
chile_disc_total <- cbind(chile_disc_total,country)

chile <- left_join(chile, chile_disc_total, by = c("year", "country"))

chile_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='Chile' and c.address like '%Univ%' group by a.year, b.area_desc")
chile_disc_edsup <-  fetch(chile_disc_edsup, n=-1)
chile_disc_edsup <- cast(chile_disc_edsup, year ~ area_desc, value='cant')
chile_disc_edsup <- cbind(chile_disc_edsup,country)

chile <- left_join(chile, chile_disc_edsup, by = c("year", "country"))

chile$HealthSciences_ratio <- (chile$`Health Sciences.y` / chile$`Health Sciences.x`)*100
chile$LifeSciences_ratio <- (chile$`Life Sciences.y` / chile$`Life Sciences.x`)*100
chile$PhysicalSciences_ratio <- (chile$`Physical Sciences.y` / chile$`Physical Sciences.x`)*100
chile$SocialSciences_ratio <- (chile$`Social Sciences.y`/ chile$`Social Sciences.x`)*100
chile$HealthSciences_ratio_total <- (chile$`Health Sciences.x` / chile$total)*100
chile$LifeSciences_ratio_total <- (chile$`Life Sciences.x` / chile$total)*100
chile$PhysicalSciences_ratio_total <- (chile$`Physical Sciences.x` / chile$total)*100
chile$SocialSciences_ratio_total <- (chile$`Social Sciences.x`/ chile$total)*100
chile$HealthSciences_ratio_educ <- (chile$`Health Sciences.y` / chile$ed_sup)*100
chile$LifeSciences_ratio_educ <- (chile$`Life Sciences.y` / chile$ed_sup)*100
chile$PhysicalSciences_ratio_educ <- (chile$`Physical Sciences.y` / chile$ed_sup)*100
chile$SocialSciences_ratio_educ <- (chile$`Social Sciences.y`/ chile$ed_sup)*100



country <- 'Barbados'

barbados_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Barbados' group by year")
barbados_total <-  fetch(barbados_total, n=-1)
barbados_total <- cbind(barbados_total,country)
names(barbados_total)[names(barbados_total)=="count(distinct a.ut)"] <- "total"

barbados_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Barbados' and address like '%Univ%' group by year")
barbados_edsup <-  fetch(barbados_edsup, n=-1)
barbados_edsup <- cbind(barbados_edsup,country)
names(barbados_edsup)[names(barbados_edsup)=="count(distinct a.ut)"] <- "ed_sup"
barbados <- left_join(barbados_total, barbados_edsup, by = c("year", "country"))
barbados <- subset(barbados, year >=minimo & year <=maximo)
barbados$ratio <- (barbados$ed_sup / barbados$total)*100

barbados_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Barbados' group by a.year, b.area_desc")
barbados_disc_total <-  fetch(barbados_disc_total, n=-1)
barbados_disc_total <- cast(barbados_disc_total, year ~ area_desc, value='cant')
barbados_disc_total <- cbind(barbados_disc_total,country)

barbados <- left_join(barbados, barbados_disc_total, by = c("year", "country"))

barbados_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='Barbados' and c.address like '%Univ%' group by a.year, b.area_desc")
barbados_disc_edsup <-  fetch(barbados_disc_edsup, n=-1)
barbados_disc_edsup <- cast(barbados_disc_edsup, year ~ area_desc, value='cant')
barbados_disc_edsup <- cbind(barbados_disc_edsup,country)

barbados <- left_join(barbados, barbados_disc_edsup, by = c("year", "country"))

barbados$HealthSciences_ratio <- (barbados$`Health Sciences.y` / barbados$`Health Sciences.x`)*100
barbados$LifeSciences_ratio <- (barbados$`Life Sciences.y` / barbados$`Life Sciences.x`)*100
barbados$PhysicalSciences_ratio <- (barbados$`Physical Sciences.y` / barbados$`Physical Sciences.x`)*100
barbados$SocialSciences_ratio <- (barbados$`Social Sciences.y`/ barbados$`Social Sciences.x`)*100
barbados$HealthSciences_ratio_total <- (barbados$`Health Sciences.x` / barbados$total)*100
barbados$LifeSciences_ratio_total <- (barbados$`Life Sciences.x` / barbados$total)*100
barbados$PhysicalSciences_ratio_total <- (barbados$`Physical Sciences.x` / barbados$total)*100
barbados$SocialSciences_ratio_total <- (barbados$`Social Sciences.x`/ barbados$total)*100
barbados$HealthSciences_ratio_educ <- (barbados$`Health Sciences.y` / barbados$ed_sup)*100
barbados$LifeSciences_ratio_educ <- (barbados$`Life Sciences.y` / barbados$ed_sup)*100
barbados$PhysicalSciences_ratio_educ <- (barbados$`Physical Sciences.y` / barbados$ed_sup)*100
barbados$SocialSciences_ratio_educ <- (barbados$`Social Sciences.y`/ barbados$ed_sup)*100



country <- 'Bolivia'

bolivia_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Bolivia' group by year")
bolivia_total <-  fetch(bolivia_total, n=-1)
bolivia_total <- cbind(bolivia_total,country)
names(bolivia_total)[names(bolivia_total)=="count(distinct a.ut)"] <- "total"

bolivia_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Bolivia' and address like '%Univ%' group by year")
bolivia_edsup <-  fetch(bolivia_edsup, n=-1)
bolivia_edsup <- cbind(bolivia_edsup,country)
names(bolivia_edsup)[names(bolivia_edsup)=="count(distinct a.ut)"] <- "ed_sup"
bolivia <- left_join(bolivia_total, bolivia_edsup, by = c("year", "country"))
bolivia <- subset(bolivia, year >=minimo & year <=maximo)
bolivia$ratio <- (bolivia$ed_sup / bolivia$total)*100

bolivia_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='bolivia' group by a.year, b.area_desc")
bolivia_disc_total <-  fetch(bolivia_disc_total, n=-1)
bolivia_disc_total <- cast(bolivia_disc_total, year ~ area_desc, value='cant')
bolivia_disc_total <- cbind(bolivia_disc_total,country)

bolivia <- left_join(bolivia, bolivia_disc_total, by = c("year", "country"))

bolivia_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='bolivia' and c.address like '%Univ%' group by a.year, b.area_desc")
bolivia_disc_edsup <-  fetch(bolivia_disc_edsup, n=-1)
bolivia_disc_edsup <- cast(bolivia_disc_edsup, year ~ area_desc, value='cant')
bolivia_disc_edsup <- cbind(bolivia_disc_edsup,country)

bolivia <- left_join(bolivia, bolivia_disc_edsup, by = c("year", "country"))

bolivia$HealthSciences_ratio <- (bolivia$`Health Sciences.y` / bolivia$`Health Sciences.x`)*100
bolivia$LifeSciences_ratio <- (bolivia$`Life Sciences.y` / bolivia$`Life Sciences.x`)*100
bolivia$PhysicalSciences_ratio <- (bolivia$`Physical Sciences.y` / bolivia$`Physical Sciences.x`)*100
bolivia$SocialSciences_ratio <- (bolivia$`Social Sciences.y`/ bolivia$`Social Sciences.x`)*100
bolivia$HealthSciences_ratio_total <- (bolivia$`Health Sciences.x` / bolivia$total)*100
bolivia$LifeSciences_ratio_total <- (bolivia$`Life Sciences.x` / bolivia$total)*100
bolivia$PhysicalSciences_ratio_total <- (bolivia$`Physical Sciences.x` / bolivia$total)*100
bolivia$SocialSciences_ratio_total <- (bolivia$`Social Sciences.x`/ bolivia$total)*100
bolivia$HealthSciences_ratio_educ <- (bolivia$`Health Sciences.y` / bolivia$ed_sup)*100
bolivia$LifeSciences_ratio_educ <- (bolivia$`Life Sciences.y` / bolivia$ed_sup)*100
bolivia$PhysicalSciences_ratio_educ <- (bolivia$`Physical Sciences.y` / bolivia$ed_sup)*100
bolivia$SocialSciences_ratio_educ <- (bolivia$`Social Sciences.y`/ bolivia$ed_sup)*100



country <- 'Brazil'

brazil_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Brazil' group by year")
brazil_total <-  fetch(brazil_total, n=-1)
brazil_total <- cbind(brazil_total,country)
names(brazil_total)[names(brazil_total)=="count(distinct a.ut)"] <- "total"

brazil_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Brazil' and address like '%Univ%' group by year")
brazil_edsup <-  fetch(brazil_edsup, n=-1)
brazil_edsup <- cbind(brazil_edsup,country)
names(brazil_edsup)[names(brazil_edsup)=="count(distinct a.ut)"] <- "ed_sup"
brazil <- left_join(brazil_total, brazil_edsup, by = c("year", "country"))
brazil <- subset(brazil, year >=minimo & year <=maximo)
brazil$ratio <- (brazil$ed_sup / brazil$total)*100

brazil_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='brazil' group by a.year, b.area_desc")
brazil_disc_total <-  fetch(brazil_disc_total, n=-1)
brazil_disc_total <- cast(brazil_disc_total, year ~ area_desc, value='cant')
brazil_disc_total <- cbind(brazil_disc_total,country)

brazil <- left_join(brazil, brazil_disc_total, by = c("year", "country"))

brazil_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='brazil' and c.address like '%Univ%' group by a.year, b.area_desc")
brazil_disc_edsup <-  fetch(brazil_disc_edsup, n=-1)
brazil_disc_edsup <- cast(brazil_disc_edsup, year ~ area_desc, value='cant')
brazil_disc_edsup <- cbind(brazil_disc_edsup,country)

brazil <- left_join(brazil, brazil_disc_edsup, by = c("year", "country"))

brazil$HealthSciences_ratio <- (brazil$`Health Sciences.y` / brazil$`Health Sciences.x`)*100
brazil$LifeSciences_ratio <- (brazil$`Life Sciences.y` / brazil$`Life Sciences.x`)*100
brazil$PhysicalSciences_ratio <- (brazil$`Physical Sciences.y` / brazil$`Physical Sciences.x`)*100
brazil$SocialSciences_ratio <- (brazil$`Social Sciences.y`/ brazil$`Social Sciences.x`)*100
brazil$HealthSciences_ratio_total <- (brazil$`Health Sciences.x` / brazil$total)*100
brazil$LifeSciences_ratio_total <- (brazil$`Life Sciences.x` / brazil$total)*100
brazil$PhysicalSciences_ratio_total <- (brazil$`Physical Sciences.x` / brazil$total)*100
brazil$SocialSciences_ratio_total <- (brazil$`Social Sciences.x`/ brazil$total)*100
brazil$HealthSciences_ratio_educ <- (brazil$`Health Sciences.y` / brazil$ed_sup)*100
brazil$LifeSciences_ratio_educ <- (brazil$`Life Sciences.y` / brazil$ed_sup)*100
brazil$PhysicalSciences_ratio_educ <- (brazil$`Physical Sciences.y` / brazil$ed_sup)*100
brazil$SocialSciences_ratio_educ <- (brazil$`Social Sciences.y`/ brazil$ed_sup)*100



country <- 'Chile'

chile_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Chile' group by year")
chile_total <-  fetch(chile_total, n=-1)
chile_total <- cbind(chile_total,country)
names(chile_total)[names(chile_total)=="count(distinct a.ut)"] <- "total"

chile_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Chile' and address like '%Univ%' group by year")
chile_edsup <-  fetch(chile_edsup, n=-1)
chile_edsup <- cbind(chile_edsup,country)
names(chile_edsup)[names(chile_edsup)=="count(distinct a.ut)"] <- "ed_sup"
chile <- left_join(chile_total, chile_edsup, by = c("year", "country"))
chile <- subset(chile, year >=minimo & year <=maximo)
chile$ratio <- (chile$ed_sup / chile$total)*100

chile_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='chile' group by a.year, b.area_desc")
chile_disc_total <-  fetch(chile_disc_total, n=-1)
chile_disc_total <- cast(chile_disc_total, year ~ area_desc, value='cant')
chile_disc_total <- cbind(chile_disc_total,country)

chile <- left_join(chile, chile_disc_total, by = c("year", "country"))

chile_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='chile' and c.address like '%Univ%' group by a.year, b.area_desc")
chile_disc_edsup <-  fetch(chile_disc_edsup, n=-1)
chile_disc_edsup <- cast(chile_disc_edsup, year ~ area_desc, value='cant')
chile_disc_edsup <- cbind(chile_disc_edsup,country)

chile <- left_join(chile, chile_disc_edsup, by = c("year", "country"))

chile$HealthSciences_ratio <- (chile$`Health Sciences.y` / chile$`Health Sciences.x`)*100
chile$LifeSciences_ratio <- (chile$`Life Sciences.y` / chile$`Life Sciences.x`)*100
chile$PhysicalSciences_ratio <- (chile$`Physical Sciences.y` / chile$`Physical Sciences.x`)*100
chile$SocialSciences_ratio <- (chile$`Social Sciences.y`/ chile$`Social Sciences.x`)*100
chile$HealthSciences_ratio_total <- (chile$`Health Sciences.x` / chile$total)*100
chile$LifeSciences_ratio_total <- (chile$`Life Sciences.x` / chile$total)*100
chile$PhysicalSciences_ratio_total <- (chile$`Physical Sciences.x` / chile$total)*100
chile$SocialSciences_ratio_total <- (chile$`Social Sciences.x`/ chile$total)*100
chile$HealthSciences_ratio_educ <- (chile$`Health Sciences.y` / chile$ed_sup)*100
chile$LifeSciences_ratio_educ <- (chile$`Life Sciences.y` / chile$ed_sup)*100
chile$PhysicalSciences_ratio_educ <- (chile$`Physical Sciences.y` / chile$ed_sup)*100
chile$SocialSciences_ratio_educ <- (chile$`Social Sciences.y`/ chile$ed_sup)*100



country <- 'Colombia'

colombia_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Colombia' group by year")
colombia_total <-  fetch(colombia_total, n=-1)
colombia_total <- cbind(colombia_total,country)
names(colombia_total)[names(colombia_total)=="count(distinct a.ut)"] <- "total"

colombia_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Colombia' and address like '%Univ%' group by year")
colombia_edsup <-  fetch(colombia_edsup, n=-1)
colombia_edsup <- cbind(colombia_edsup,country)
names(colombia_edsup)[names(colombia_edsup)=="count(distinct a.ut)"] <- "ed_sup"
colombia <- left_join(colombia_total, colombia_edsup, by = c("year", "country"))
colombia <- subset(colombia, year >=minimo & year <=maximo)
colombia$ratio <- (colombia$ed_sup / colombia$total)*100

colombia_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='colombia' group by a.year, b.area_desc")
colombia_disc_total <-  fetch(colombia_disc_total, n=-1)
colombia_disc_total <- cast(colombia_disc_total, year ~ area_desc, value='cant')
colombia_disc_total <- cbind(colombia_disc_total,country)

colombia <- left_join(colombia, colombia_disc_total, by = c("year", "country"))

colombia_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='colombia' and c.address like '%Univ%' group by a.year, b.area_desc")
colombia_disc_edsup <-  fetch(colombia_disc_edsup, n=-1)
colombia_disc_edsup <- cast(colombia_disc_edsup, year ~ area_desc, value='cant')
colombia_disc_edsup <- cbind(colombia_disc_edsup,country)

colombia <- left_join(colombia, colombia_disc_edsup, by = c("year", "country"))

colombia$HealthSciences_ratio <- (colombia$`Health Sciences.y` / colombia$`Health Sciences.x`)*100
colombia$LifeSciences_ratio <- (colombia$`Life Sciences.y` / colombia$`Life Sciences.x`)*100
colombia$PhysicalSciences_ratio <- (colombia$`Physical Sciences.y` / colombia$`Physical Sciences.x`)*100
colombia$SocialSciences_ratio <- (colombia$`Social Sciences.y`/ colombia$`Social Sciences.x`)*100
colombia$HealthSciences_ratio_total <- (colombia$`Health Sciences.x` / colombia$total)*100
colombia$LifeSciences_ratio_total <- (colombia$`Life Sciences.x` / colombia$total)*100
colombia$PhysicalSciences_ratio_total <- (colombia$`Physical Sciences.x` / colombia$total)*100
colombia$SocialSciences_ratio_total <- (colombia$`Social Sciences.x`/ colombia$total)*100
colombia$HealthSciences_ratio_educ <- (colombia$`Health Sciences.y` / colombia$ed_sup)*100
colombia$LifeSciences_ratio_educ <- (colombia$`Life Sciences.y` / colombia$ed_sup)*100
colombia$PhysicalSciences_ratio_educ <- (colombia$`Physical Sciences.y` / colombia$ed_sup)*100
colombia$SocialSciences_ratio_educ <- (colombia$`Social Sciences.y`/ colombia$ed_sup)*100



country <- 'Costa Rica'

costa_rica_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Costa Rica' group by year")
costa_rica_total <-  fetch(costa_rica_total, n=-1)
costa_rica_total <- cbind(costa_rica_total,country)
names(costa_rica_total)[names(costa_rica_total)=="count(distinct a.ut)"] <- "total"

costa_rica_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Costa Rica' and address like '%Univ%' group by year")
costa_rica_edsup <-  fetch(costa_rica_edsup, n=-1)
costa_rica_edsup <- cbind(costa_rica_edsup,country)
names(costa_rica_edsup)[names(costa_rica_edsup)=="count(distinct a.ut)"] <- "ed_sup"
costa_rica <- left_join(costa_rica_total, costa_rica_edsup, by = c("year", "country"))
costa_rica <- subset(costa_rica, year >=minimo & year <=maximo)
costa_rica$ratio <- (costa_rica$ed_sup / costa_rica$total)*100

costa_rica_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Costa Rica' group by a.year, b.area_desc")
costa_rica_disc_total <-  fetch(costa_rica_disc_total, n=-1)
costa_rica_disc_total <- cast(costa_rica_disc_total, year ~ area_desc, value='cant')
costa_rica_disc_total <- cbind(costa_rica_disc_total,country)

costa_rica <- left_join(costa_rica, costa_rica_disc_total, by = c("year", "country"))

costa_rica_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='Costa Rica' and c.address like '%Univ%' group by a.year, b.area_desc")
costa_rica_disc_edsup <-  fetch(costa_rica_disc_edsup, n=-1)
costa_rica_disc_edsup <- cast(costa_rica_disc_edsup, year ~ area_desc, value='cant')
costa_rica_disc_edsup <- cbind(costa_rica_disc_edsup,country)

costa_rica <- left_join(costa_rica, costa_rica_disc_edsup, by = c("year", "country"))

costa_rica$HealthSciences_ratio <- (costa_rica$`Health Sciences.y` / costa_rica$`Health Sciences.x`)*100
costa_rica$LifeSciences_ratio <- (costa_rica$`Life Sciences.y` / costa_rica$`Life Sciences.x`)*100
costa_rica$PhysicalSciences_ratio <- (costa_rica$`Physical Sciences.y` / costa_rica$`Physical Sciences.x`)*100
costa_rica$SocialSciences_ratio <- (costa_rica$`Social Sciences.y`/ costa_rica$`Social Sciences.x`)*100
costa_rica$HealthSciences_ratio_total <- (costa_rica$`Health Sciences.x` / costa_rica$total)*100
costa_rica$LifeSciences_ratio_total <- (costa_rica$`Life Sciences.x` / costa_rica$total)*100
costa_rica$PhysicalSciences_ratio_total <- (costa_rica$`Physical Sciences.x` / costa_rica$total)*100
costa_rica$SocialSciences_ratio_total <- (costa_rica$`Social Sciences.x`/ costa_rica$total)*100
costa_rica$HealthSciences_ratio_educ <- (costa_rica$`Health Sciences.y` / costa_rica$ed_sup)*100
costa_rica$LifeSciences_ratio_educ <- (costa_rica$`Life Sciences.y` / costa_rica$ed_sup)*100
costa_rica$PhysicalSciences_ratio_educ <- (costa_rica$`Physical Sciences.y` / costa_rica$ed_sup)*100
costa_rica$SocialSciences_ratio_educ <- (costa_rica$`Social Sciences.y`/ costa_rica$ed_sup)*100



country <- 'Cuba'

cuba_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Cuba' group by year")
cuba_total <-  fetch(cuba_total, n=-1)
cuba_total <- cbind(cuba_total,country)
names(cuba_total)[names(cuba_total)=="count(distinct a.ut)"] <- "total"

cuba_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Cuba' and address like '%Univ%' group by year")
cuba_edsup <-  fetch(cuba_edsup, n=-1)
cuba_edsup <- cbind(cuba_edsup,country)
names(cuba_edsup)[names(cuba_edsup)=="count(distinct a.ut)"] <- "ed_sup"
cuba <- left_join(cuba_total, cuba_edsup, by = c("year", "country"))
cuba <- subset(cuba, year >=minimo & year <=maximo)
cuba$ratio <- (cuba$ed_sup / cuba$total)*100

cuba_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='cuba' group by a.year, b.area_desc")
cuba_disc_total <-  fetch(cuba_disc_total, n=-1)
cuba_disc_total <- cast(cuba_disc_total, year ~ area_desc, value='cant')
cuba_disc_total <- cbind(cuba_disc_total,country)

cuba <- left_join(cuba, cuba_disc_total, by = c("year", "country"))

cuba_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='cuba' and c.address like '%Univ%' group by a.year, b.area_desc")
cuba_disc_edsup <-  fetch(cuba_disc_edsup, n=-1)
cuba_disc_edsup <- cast(cuba_disc_edsup, year ~ area_desc, value='cant')
cuba_disc_edsup <- cbind(cuba_disc_edsup,country)

cuba <- left_join(cuba, cuba_disc_edsup, by = c("year", "country"))

cuba$HealthSciences_ratio <- (cuba$`Health Sciences.y` / cuba$`Health Sciences.x`)*100
cuba$LifeSciences_ratio <- (cuba$`Life Sciences.y` / cuba$`Life Sciences.x`)*100
cuba$PhysicalSciences_ratio <- (cuba$`Physical Sciences.y` / cuba$`Physical Sciences.x`)*100
cuba$SocialSciences_ratio <- (cuba$`Social Sciences.y`/ cuba$`Social Sciences.x`)*100
cuba$HealthSciences_ratio_total <- (cuba$`Health Sciences.x` / cuba$total)*100
cuba$LifeSciences_ratio_total <- (cuba$`Life Sciences.x` / cuba$total)*100
cuba$PhysicalSciences_ratio_total <- (cuba$`Physical Sciences.x` / cuba$total)*100
cuba$SocialSciences_ratio_total <- (cuba$`Social Sciences.x`/ cuba$total)*100
cuba$HealthSciences_ratio_educ <- (cuba$`Health Sciences.y` / cuba$ed_sup)*100
cuba$LifeSciences_ratio_educ <- (cuba$`Life Sciences.y` / cuba$ed_sup)*100
cuba$PhysicalSciences_ratio_educ <- (cuba$`Physical Sciences.y` / cuba$ed_sup)*100
cuba$SocialSciences_ratio_educ <- (cuba$`Social Sciences.y`/ cuba$ed_sup)*100



country <- 'Ecuador'

ecuador_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Ecuador' group by year")
ecuador_total <-  fetch(ecuador_total, n=-1)
ecuador_total <- cbind(ecuador_total,country)
names(ecuador_total)[names(ecuador_total)=="count(distinct a.ut)"] <- "total"

ecuador_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Ecuador' and address like '%Univ%' group by year")
ecuador_edsup <-  fetch(ecuador_edsup, n=-1)
ecuador_edsup <- cbind(ecuador_edsup,country)
names(ecuador_edsup)[names(ecuador_edsup)=="count(distinct a.ut)"] <- "ed_sup"
ecuador <- left_join(ecuador_total, ecuador_edsup, by = c("year", "country"))
ecuador <- subset(ecuador, year >=minimo & year <=maximo)
ecuador$ratio <- (ecuador$ed_sup / ecuador$total)*100

ecuador_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='ecuador' group by a.year, b.area_desc")
ecuador_disc_total <-  fetch(ecuador_disc_total, n=-1)
ecuador_disc_total <- cast(ecuador_disc_total, year ~ area_desc, value='cant')
ecuador_disc_total <- cbind(ecuador_disc_total,country)

ecuador <- left_join(ecuador, ecuador_disc_total, by = c("year", "country"))

ecuador_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='ecuador' and c.address like '%Univ%' group by a.year, b.area_desc")
ecuador_disc_edsup <-  fetch(ecuador_disc_edsup, n=-1)
ecuador_disc_edsup <- cast(ecuador_disc_edsup, year ~ area_desc, value='cant')
ecuador_disc_edsup <- cbind(ecuador_disc_edsup,country)

ecuador <- left_join(ecuador, ecuador_disc_edsup, by = c("year", "country"))

ecuador$HealthSciences_ratio <- (ecuador$`Health Sciences.y` / ecuador$`Health Sciences.x`)*100
ecuador$LifeSciences_ratio <- (ecuador$`Life Sciences.y` / ecuador$`Life Sciences.x`)*100
ecuador$PhysicalSciences_ratio <- (ecuador$`Physical Sciences.y` / ecuador$`Physical Sciences.x`)*100
ecuador$SocialSciences_ratio <- (ecuador$`Social Sciences.y`/ ecuador$`Social Sciences.x`)*100
ecuador$HealthSciences_ratio_total <- (ecuador$`Health Sciences.x` / ecuador$total)*100
ecuador$LifeSciences_ratio_total <- (ecuador$`Life Sciences.x` / ecuador$total)*100
ecuador$PhysicalSciences_ratio_total <- (ecuador$`Physical Sciences.x` / ecuador$total)*100
ecuador$SocialSciences_ratio_total <- (ecuador$`Social Sciences.x`/ ecuador$total)*100
ecuador$HealthSciences_ratio_educ <- (ecuador$`Health Sciences.y` / ecuador$ed_sup)*100
ecuador$LifeSciences_ratio_educ <- (ecuador$`Life Sciences.y` / ecuador$ed_sup)*100
ecuador$PhysicalSciences_ratio_educ <- (ecuador$`Physical Sciences.y` / ecuador$ed_sup)*100
ecuador$SocialSciences_ratio_educ <- (ecuador$`Social Sciences.y`/ ecuador$ed_sup)*100



country <- 'El Salvador'

el_salvador_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='El Salvador' group by year")
el_salvador_total <-  fetch(el_salvador_total, n=-1)
el_salvador_total <- cbind(el_salvador_total,country)
names(el_salvador_total)[names(el_salvador_total)=="count(distinct a.ut)"] <- "total"

el_salvador_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='El Salvador' and address like '%Univ%' group by year")
el_salvador_edsup <-  fetch(el_salvador_edsup, n=-1)
el_salvador_edsup <- cbind(el_salvador_edsup,country)
names(el_salvador_edsup)[names(el_salvador_edsup)=="count(distinct a.ut)"] <- "ed_sup"
el_salvador <- left_join(el_salvador_total, el_salvador_edsup, by = c("year", "country"))
el_salvador <- subset(el_salvador, year >=minimo & year <=maximo)
el_salvador$ratio <- (el_salvador$ed_sup / el_salvador$total)*100

el_salvador_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='El Salvador' group by a.year, b.area_desc")
el_salvador_disc_total <-  fetch(el_salvador_disc_total, n=-1)
el_salvador_disc_total <- cast(el_salvador_disc_total, year ~ area_desc, value='cant')
el_salvador_disc_total <- cbind(el_salvador_disc_total,country)

el_salvador <- left_join(el_salvador, el_salvador_disc_total, by = c("year", "country"))

el_salvador_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='El Salvador' and c.address like '%Univ%' group by a.year, b.area_desc")
el_salvador_disc_edsup <-  fetch(el_salvador_disc_edsup, n=-1)
el_salvador_disc_edsup <- cast(el_salvador_disc_edsup, year ~ area_desc, value='cant')
el_salvador_disc_edsup <- cbind(el_salvador_disc_edsup,country)

el_salvador <- left_join(el_salvador, el_salvador_disc_edsup, by = c("year", "country"))

el_salvador$HealthSciences_ratio <- (el_salvador$`Health Sciences.y` / el_salvador$`Health Sciences.x`)*100
el_salvador$LifeSciences_ratio <- (el_salvador$`Life Sciences.y` / el_salvador$`Life Sciences.x`)*100
el_salvador$PhysicalSciences_ratio <- (el_salvador$`Physical Sciences.y` / el_salvador$`Physical Sciences.x`)*100
el_salvador$SocialSciences_ratio <- (el_salvador$`Social Sciences.y`/ el_salvador$`Social Sciences.x`)*100
el_salvador$HealthSciences_ratio_total <- (el_salvador$`Health Sciences.x` / el_salvador$total)*100
el_salvador$LifeSciences_ratio_total <- (el_salvador$`Life Sciences.x` / el_salvador$total)*100
el_salvador$PhysicalSciences_ratio_total <- (el_salvador$`Physical Sciences.x` / el_salvador$total)*100
el_salvador$SocialSciences_ratio_total <- (el_salvador$`Social Sciences.x`/ el_salvador$total)*100
el_salvador$HealthSciences_ratio_educ <- (el_salvador$`Health Sciences.y` / el_salvador$ed_sup)*100
el_salvador$LifeSciences_ratio_educ <- (el_salvador$`Life Sciences.y` / el_salvador$ed_sup)*100
el_salvador$PhysicalSciences_ratio_educ <- (el_salvador$`Physical Sciences.y` / el_salvador$ed_sup)*100
el_salvador$SocialSciences_ratio_educ <- (el_salvador$`Social Sciences.y`/ el_salvador$ed_sup)*100



country <- 'Spain'

spain_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Spain' group by year")
spain_total <-  fetch(spain_total, n=-1)
spain_total <- cbind(spain_total,country)
names(spain_total)[names(spain_total)=="count(distinct a.ut)"] <- "total"

spain_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Spain' and address like '%Univ%' group by year")
spain_edsup <-  fetch(spain_edsup, n=-1)
spain_edsup <- cbind(spain_edsup,country)
names(spain_edsup)[names(spain_edsup)=="count(distinct a.ut)"] <- "ed_sup"
spain <- left_join(spain_total, spain_edsup, by = c("year", "country"))
spain <- subset(spain, year >=minimo & year <=maximo)
spain$ratio <- (spain$ed_sup / spain$total)*100

spain_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='spain' group by a.year, b.area_desc")
spain_disc_total <-  fetch(spain_disc_total, n=-1)
spain_disc_total <- cast(spain_disc_total, year ~ area_desc, value='cant')
spain_disc_total <- cbind(spain_disc_total,country)

spain <- left_join(spain, spain_disc_total, by = c("year", "country"))

spain_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='spain' and c.address like '%Univ%' group by a.year, b.area_desc")
spain_disc_edsup <-  fetch(spain_disc_edsup, n=-1)
spain_disc_edsup <- cast(spain_disc_edsup, year ~ area_desc, value='cant')
spain_disc_edsup <- cbind(spain_disc_edsup,country)

spain <- left_join(spain, spain_disc_edsup, by = c("year", "country"))

spain$HealthSciences_ratio <- (spain$`Health Sciences.y` / spain$`Health Sciences.x`)*100
spain$LifeSciences_ratio <- (spain$`Life Sciences.y` / spain$`Life Sciences.x`)*100
spain$PhysicalSciences_ratio <- (spain$`Physical Sciences.y` / spain$`Physical Sciences.x`)*100
spain$SocialSciences_ratio <- (spain$`Social Sciences.y`/ spain$`Social Sciences.x`)*100
spain$HealthSciences_ratio_total <- (spain$`Health Sciences.x` / spain$total)*100
spain$LifeSciences_ratio_total <- (spain$`Life Sciences.x` / spain$total)*100
spain$PhysicalSciences_ratio_total <- (spain$`Physical Sciences.x` / spain$total)*100
spain$SocialSciences_ratio_total <- (spain$`Social Sciences.x`/ spain$total)*100
spain$HealthSciences_ratio_educ <- (spain$`Health Sciences.y` / spain$ed_sup)*100
spain$LifeSciences_ratio_educ <- (spain$`Life Sciences.y` / spain$ed_sup)*100
spain$PhysicalSciences_ratio_educ <- (spain$`Physical Sciences.y` / spain$ed_sup)*100
spain$SocialSciences_ratio_educ <- (spain$`Social Sciences.y`/ spain$ed_sup)*100



country <- 'Guatemala'

guatemala_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Guatemala' group by year")
guatemala_total <-  fetch(guatemala_total, n=-1)
guatemala_total <- cbind(guatemala_total,country)
names(guatemala_total)[names(guatemala_total)=="count(distinct a.ut)"] <- "total"

guatemala_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Guatemala' and address like '%Univ%' group by year")
guatemala_edsup <-  fetch(guatemala_edsup, n=-1)
guatemala_edsup <- cbind(guatemala_edsup,country)
names(guatemala_edsup)[names(guatemala_edsup)=="count(distinct a.ut)"] <- "ed_sup"
guatemala <- left_join(guatemala_total, guatemala_edsup, by = c("year", "country"))
guatemala <- subset(guatemala, year >=minimo & year <=maximo)
guatemala$ratio <- (guatemala$ed_sup / guatemala$total)*100

guatemala_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='guatemala' group by a.year, b.area_desc")
guatemala_disc_total <-  fetch(guatemala_disc_total, n=-1)
guatemala_disc_total <- cast(guatemala_disc_total, year ~ area_desc, value='cant')
guatemala_disc_total <- cbind(guatemala_disc_total,country)

guatemala <- left_join(guatemala, guatemala_disc_total, by = c("year", "country"))

guatemala_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='guatemala' and c.address like '%Univ%' group by a.year, b.area_desc")
guatemala_disc_edsup <-  fetch(guatemala_disc_edsup, n=-1)
guatemala_disc_edsup <- cast(guatemala_disc_edsup, year ~ area_desc, value='cant')
guatemala_disc_edsup <- cbind(guatemala_disc_edsup,country)

guatemala <- left_join(guatemala, guatemala_disc_edsup, by = c("year", "country"))

guatemala$HealthSciences_ratio <- (guatemala$`Health Sciences.y` / guatemala$`Health Sciences.x`)*100
guatemala$LifeSciences_ratio <- (guatemala$`Life Sciences.y` / guatemala$`Life Sciences.x`)*100
guatemala$PhysicalSciences_ratio <- (guatemala$`Physical Sciences.y` / guatemala$`Physical Sciences.x`)*100
guatemala$SocialSciences_ratio <- (guatemala$`Social Sciences.y`/ guatemala$`Social Sciences.x`)*100
guatemala$HealthSciences_ratio_total <- (guatemala$`Health Sciences.x` / guatemala$total)*100
guatemala$LifeSciences_ratio_total <- (guatemala$`Life Sciences.x` / guatemala$total)*100
guatemala$PhysicalSciences_ratio_total <- (guatemala$`Physical Sciences.x` / guatemala$total)*100
guatemala$SocialSciences_ratio_total <- (guatemala$`Social Sciences.x`/ guatemala$total)*100
guatemala$HealthSciences_ratio_educ <- (guatemala$`Health Sciences.y` / guatemala$ed_sup)*100
guatemala$LifeSciences_ratio_educ <- (guatemala$`Life Sciences.y` / guatemala$ed_sup)*100
guatemala$PhysicalSciences_ratio_educ <- (guatemala$`Physical Sciences.y` / guatemala$ed_sup)*100
guatemala$SocialSciences_ratio_educ <- (guatemala$`Social Sciences.y`/ guatemala$ed_sup)*100



country <- 'Honduras'

honduras_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Honduras' group by year")
honduras_total <-  fetch(honduras_total, n=-1)
honduras_total <- cbind(honduras_total,country)
names(honduras_total)[names(honduras_total)=="count(distinct a.ut)"] <- "total"

honduras_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Honduras' and address like '%Univ%' group by year")
honduras_edsup <-  fetch(honduras_edsup, n=-1)
honduras_edsup <- cbind(honduras_edsup,country)
names(honduras_edsup)[names(honduras_edsup)=="count(distinct a.ut)"] <- "ed_sup"
honduras <- left_join(honduras_total, honduras_edsup, by = c("year", "country"))
honduras <- subset(honduras, year >=minimo & year <=maximo)
honduras$ratio <- (honduras$ed_sup / honduras$total)*100

honduras_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='honduras' group by a.year, b.area_desc")
honduras_disc_total <-  fetch(honduras_disc_total, n=-1)
honduras_disc_total <- cast(honduras_disc_total, year ~ area_desc, value='cant')
honduras_disc_total <- cbind(honduras_disc_total,country)

honduras <- left_join(honduras, honduras_disc_total, by = c("year", "country"))

honduras_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='honduras' and c.address like '%Univ%' group by a.year, b.area_desc")
honduras_disc_edsup <-  fetch(honduras_disc_edsup, n=-1)
honduras_disc_edsup <- cast(honduras_disc_edsup, year ~ area_desc, value='cant')
honduras_disc_edsup <- cbind(honduras_disc_edsup,country)

honduras <- left_join(honduras, honduras_disc_edsup, by = c("year", "country"))

honduras$HealthSciences_ratio <- (honduras$`Health Sciences.y` / honduras$`Health Sciences.x`)*100
honduras$LifeSciences_ratio <- (honduras$`Life Sciences.y` / honduras$`Life Sciences.x`)*100
honduras$PhysicalSciences_ratio <- (honduras$`Physical Sciences.y` / honduras$`Physical Sciences.x`)*100
honduras$SocialSciences_ratio <- (honduras$`Social Sciences.y`/ honduras$`Social Sciences.x`)*100
honduras$HealthSciences_ratio_total <- (honduras$`Health Sciences.x` / honduras$total)*100
honduras$LifeSciences_ratio_total <- (honduras$`Life Sciences.x` / honduras$total)*100
honduras$PhysicalSciences_ratio_total <- (honduras$`Physical Sciences.x` / honduras$total)*100
honduras$SocialSciences_ratio_total <- (honduras$`Social Sciences.x`/ honduras$total)*100
honduras$HealthSciences_ratio_educ <- (honduras$`Health Sciences.y` / honduras$ed_sup)*100
honduras$LifeSciences_ratio_educ <- (honduras$`Life Sciences.y` / honduras$ed_sup)*100
honduras$PhysicalSciences_ratio_educ <- (honduras$`Physical Sciences.y` / honduras$ed_sup)*100
honduras$SocialSciences_ratio_educ <- (honduras$`Social Sciences.y`/ honduras$ed_sup)*100



country <- 'Mexico'

mexico_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Mexico' group by year")
mexico_total <-  fetch(mexico_total, n=-1)
mexico_total <- cbind(mexico_total,country)
names(mexico_total)[names(mexico_total)=="count(distinct a.ut)"] <- "total"

mexico_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Mexico' and address like '%Univ%' group by year")
mexico_edsup <-  fetch(mexico_edsup, n=-1)
mexico_edsup <- cbind(mexico_edsup,country)
names(mexico_edsup)[names(mexico_edsup)=="count(distinct a.ut)"] <- "ed_sup"
mexico <- left_join(mexico_total, mexico_edsup, by = c("year", "country"))
mexico <- subset(mexico, year >=minimo & year <=maximo)
mexico$ratio <- (mexico$ed_sup / mexico$total)*100

mexico_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='mexico' group by a.year, b.area_desc")
mexico_disc_total <-  fetch(mexico_disc_total, n=-1)
mexico_disc_total <- cast(mexico_disc_total, year ~ area_desc, value='cant')
mexico_disc_total <- cbind(mexico_disc_total,country)

mexico <- left_join(mexico, mexico_disc_total, by = c("year", "country"))

mexico_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='mexico' and c.address like '%Univ%' group by a.year, b.area_desc")
mexico_disc_edsup <-  fetch(mexico_disc_edsup, n=-1)
mexico_disc_edsup <- cast(mexico_disc_edsup, year ~ area_desc, value='cant')
mexico_disc_edsup <- cbind(mexico_disc_edsup,country)

mexico <- left_join(mexico, mexico_disc_edsup, by = c("year", "country"))

mexico$HealthSciences_ratio <- (mexico$`Health Sciences.y` / mexico$`Health Sciences.x`)*100
mexico$LifeSciences_ratio <- (mexico$`Life Sciences.y` / mexico$`Life Sciences.x`)*100
mexico$PhysicalSciences_ratio <- (mexico$`Physical Sciences.y` / mexico$`Physical Sciences.x`)*100
mexico$SocialSciences_ratio <- (mexico$`Social Sciences.y`/ mexico$`Social Sciences.x`)*100
mexico$HealthSciences_ratio_total <- (mexico$`Health Sciences.x` / mexico$total)*100
mexico$LifeSciences_ratio_total <- (mexico$`Life Sciences.x` / mexico$total)*100
mexico$PhysicalSciences_ratio_total <- (mexico$`Physical Sciences.x` / mexico$total)*100
mexico$SocialSciences_ratio_total <- (mexico$`Social Sciences.x`/ mexico$total)*100
mexico$HealthSciences_ratio_educ <- (mexico$`Health Sciences.y` / mexico$ed_sup)*100
mexico$LifeSciences_ratio_educ <- (mexico$`Life Sciences.y` / mexico$ed_sup)*100
mexico$PhysicalSciences_ratio_educ <- (mexico$`Physical Sciences.y` / mexico$ed_sup)*100
mexico$SocialSciences_ratio_educ <- (mexico$`Social Sciences.y`/ mexico$ed_sup)*100



country <- 'Nicaragua'

nicaragua_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Nicaragua' group by year")
nicaragua_total <-  fetch(nicaragua_total, n=-1)
nicaragua_total <- cbind(nicaragua_total,country)
names(nicaragua_total)[names(nicaragua_total)=="count(distinct a.ut)"] <- "total"

nicaragua_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Nicaragua' and address like '%Univ%' group by year")
nicaragua_edsup <-  fetch(nicaragua_edsup, n=-1)
nicaragua_edsup <- cbind(nicaragua_edsup,country)
names(nicaragua_edsup)[names(nicaragua_edsup)=="count(distinct a.ut)"] <- "ed_sup"
nicaragua <- left_join(nicaragua_total, nicaragua_edsup, by = c("year", "country"))
nicaragua <- subset(nicaragua, year >=minimo & year <=maximo)
nicaragua$ratio <- (nicaragua$ed_sup / nicaragua$total)*100

nicaragua_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='nicaragua' group by a.year, b.area_desc")
nicaragua_disc_total <-  fetch(nicaragua_disc_total, n=-1)
nicaragua_disc_total <- cast(nicaragua_disc_total, year ~ area_desc, value='cant')
nicaragua_disc_total <- cbind(nicaragua_disc_total,country)

nicaragua <- left_join(nicaragua, nicaragua_disc_total, by = c("year", "country"))

nicaragua_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='nicaragua' and c.address like '%Univ%' group by a.year, b.area_desc")
nicaragua_disc_edsup <-  fetch(nicaragua_disc_edsup, n=-1)
nicaragua_disc_edsup <- cast(nicaragua_disc_edsup, year ~ area_desc, value='cant')
nicaragua_disc_edsup <- cbind(nicaragua_disc_edsup,country)

nicaragua <- left_join(nicaragua, nicaragua_disc_edsup, by = c("year", "country"))

nicaragua$HealthSciences_ratio <- (nicaragua$`Health Sciences.y` / nicaragua$`Health Sciences.x`)*100
nicaragua$LifeSciences_ratio <- (nicaragua$`Life Sciences.y` / nicaragua$`Life Sciences.x`)*100
nicaragua$PhysicalSciences_ratio <- (nicaragua$`Physical Sciences.y` / nicaragua$`Physical Sciences.x`)*100
nicaragua$SocialSciences_ratio <- (nicaragua$`Social Sciences.y`/ nicaragua$`Social Sciences.x`)*100
nicaragua$HealthSciences_ratio_total <- (nicaragua$`Health Sciences.x` / nicaragua$total)*100
nicaragua$LifeSciences_ratio_total <- (nicaragua$`Life Sciences.x` / nicaragua$total)*100
nicaragua$PhysicalSciences_ratio_total <- (nicaragua$`Physical Sciences.x` / nicaragua$total)*100
nicaragua$SocialSciences_ratio_total <- (nicaragua$`Social Sciences.x`/ nicaragua$total)*100
nicaragua$HealthSciences_ratio_educ <- (nicaragua$`Health Sciences.y` / nicaragua$ed_sup)*100
nicaragua$LifeSciences_ratio_educ <- (nicaragua$`Life Sciences.y` / nicaragua$ed_sup)*100
nicaragua$PhysicalSciences_ratio_educ <- (nicaragua$`Physical Sciences.y` / nicaragua$ed_sup)*100
nicaragua$SocialSciences_ratio_educ <- (nicaragua$`Social Sciences.y`/ nicaragua$ed_sup)*100



country <- 'Panama'

panama_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Panama' group by year")
panama_total <-  fetch(panama_total, n=-1)
panama_total <- cbind(panama_total,country)
names(panama_total)[names(panama_total)=="count(distinct a.ut)"] <- "total"

panama_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Panama' and address like '%Univ%' group by year")
panama_edsup <-  fetch(panama_edsup, n=-1)
panama_edsup <- cbind(panama_edsup,country)
names(panama_edsup)[names(panama_edsup)=="count(distinct a.ut)"] <- "ed_sup"
panama <- left_join(panama_total, panama_edsup, by = c("year", "country"))
panama <- subset(panama, year >=minimo & year <=maximo)
panama$ratio <- (panama$ed_sup / panama$total)*100

panama_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='panama' group by a.year, b.area_desc")
panama_disc_total <-  fetch(panama_disc_total, n=-1)
panama_disc_total <- cast(panama_disc_total, year ~ area_desc, value='cant')
panama_disc_total <- cbind(panama_disc_total,country)

panama <- left_join(panama, panama_disc_total, by = c("year", "country"))

panama_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='panama' and c.address like '%Univ%' group by a.year, b.area_desc")
panama_disc_edsup <-  fetch(panama_disc_edsup, n=-1)
panama_disc_edsup <- cast(panama_disc_edsup, year ~ area_desc, value='cant')
panama_disc_edsup <- cbind(panama_disc_edsup,country)

panama <- left_join(panama, panama_disc_edsup, by = c("year", "country"))

panama$HealthSciences_ratio <- (panama$`Health Sciences.y` / panama$`Health Sciences.x`)*100
panama$LifeSciences_ratio <- (panama$`Life Sciences.y` / panama$`Life Sciences.x`)*100
panama$PhysicalSciences_ratio <- (panama$`Physical Sciences.y` / panama$`Physical Sciences.x`)*100
panama$SocialSciences_ratio <- (panama$`Social Sciences.y`/ panama$`Social Sciences.x`)*100
panama$HealthSciences_ratio_total <- (panama$`Health Sciences.x` / panama$total)*100
panama$LifeSciences_ratio_total <- (panama$`Life Sciences.x` / panama$total)*100
panama$PhysicalSciences_ratio_total <- (panama$`Physical Sciences.x` / panama$total)*100
panama$SocialSciences_ratio_total <- (panama$`Social Sciences.x`/ panama$total)*100
panama$HealthSciences_ratio_educ <- (panama$`Health Sciences.y` / panama$ed_sup)*100
panama$LifeSciences_ratio_educ <- (panama$`Life Sciences.y` / panama$ed_sup)*100
panama$PhysicalSciences_ratio_educ <- (panama$`Physical Sciences.y` / panama$ed_sup)*100
panama$SocialSciences_ratio_educ <- (panama$`Social Sciences.y`/ panama$ed_sup)*100



country <- 'Paraguay'

paraguay_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Paraguay' group by year")
paraguay_total <-  fetch(paraguay_total, n=-1)
paraguay_total <- cbind(paraguay_total,country)
names(paraguay_total)[names(paraguay_total)=="count(distinct a.ut)"] <- "total"

paraguay_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Paraguay' and address like '%Univ%' group by year")
paraguay_edsup <-  fetch(paraguay_edsup, n=-1)
paraguay_edsup <- cbind(paraguay_edsup,country)
names(paraguay_edsup)[names(paraguay_edsup)=="count(distinct a.ut)"] <- "ed_sup"
paraguay <- left_join(paraguay_total, paraguay_edsup, by = c("year", "country"))
paraguay <- subset(paraguay, year >=minimo & year <=maximo)
paraguay$ratio <- (paraguay$ed_sup / paraguay$total)*100

paraguay_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='paraguay' group by a.year, b.area_desc")
paraguay_disc_total <-  fetch(paraguay_disc_total, n=-1)
paraguay_disc_total <- cast(paraguay_disc_total, year ~ area_desc, value='cant')
paraguay_disc_total <- cbind(paraguay_disc_total,country)

paraguay <- left_join(paraguay, paraguay_disc_total, by = c("year", "country"))

paraguay_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='paraguay' and c.address like '%Univ%' group by a.year, b.area_desc")
paraguay_disc_edsup <-  fetch(paraguay_disc_edsup, n=-1)
paraguay_disc_edsup <- cast(paraguay_disc_edsup, year ~ area_desc, value='cant')
paraguay_disc_edsup <- cbind(paraguay_disc_edsup,country)

paraguay <- left_join(paraguay, paraguay_disc_edsup, by = c("year", "country"))

paraguay$HealthSciences_ratio <- (paraguay$`Health Sciences.y` / paraguay$`Health Sciences.x`)*100
paraguay$LifeSciences_ratio <- (paraguay$`Life Sciences.y` / paraguay$`Life Sciences.x`)*100
paraguay$PhysicalSciences_ratio <- (paraguay$`Physical Sciences.y` / paraguay$`Physical Sciences.x`)*100
paraguay$SocialSciences_ratio <- (paraguay$`Social Sciences.y`/ paraguay$`Social Sciences.x`)*100
paraguay$HealthSciences_ratio_total <- (paraguay$`Health Sciences.x` / paraguay$total)*100
paraguay$LifeSciences_ratio_total <- (paraguay$`Life Sciences.x` / paraguay$total)*100
paraguay$PhysicalSciences_ratio_total <- (paraguay$`Physical Sciences.x` / paraguay$total)*100
paraguay$SocialSciences_ratio_total <- (paraguay$`Social Sciences.x`/ paraguay$total)*100
paraguay$HealthSciences_ratio_educ <- (paraguay$`Health Sciences.y` / paraguay$ed_sup)*100
paraguay$LifeSciences_ratio_educ <- (paraguay$`Life Sciences.y` / paraguay$ed_sup)*100
paraguay$PhysicalSciences_ratio_educ <- (paraguay$`Physical Sciences.y` / paraguay$ed_sup)*100
paraguay$SocialSciences_ratio_educ <- (paraguay$`Social Sciences.y`/ paraguay$ed_sup)*100



country <- 'Peru'

peru_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Peru' group by year")
peru_total <-  fetch(peru_total, n=-1)
peru_total <- cbind(peru_total,country)
names(peru_total)[names(peru_total)=="count(distinct a.ut)"] <- "total"

peru_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Peru' and address like '%Univ%' group by year")
peru_edsup <-  fetch(peru_edsup, n=-1)
peru_edsup <- cbind(peru_edsup,country)
names(peru_edsup)[names(peru_edsup)=="count(distinct a.ut)"] <- "ed_sup"
peru <- left_join(peru_total, peru_edsup, by = c("year", "country"))
peru <- subset(peru, year >=minimo & year <=maximo)
peru$ratio <- (peru$ed_sup / peru$total)*100

peru_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='peru' group by a.year, b.area_desc")
peru_disc_total <-  fetch(peru_disc_total, n=-1)
peru_disc_total <- cast(peru_disc_total, year ~ area_desc, value='cant')
peru_disc_total <- cbind(peru_disc_total,country)

peru <- left_join(peru, peru_disc_total, by = c("year", "country"))

peru_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='peru' and c.address like '%Univ%' group by a.year, b.area_desc")
peru_disc_edsup <-  fetch(peru_disc_edsup, n=-1)
peru_disc_edsup <- cast(peru_disc_edsup, year ~ area_desc, value='cant')
peru_disc_edsup <- cbind(peru_disc_edsup,country)

peru <- left_join(peru, peru_disc_edsup, by = c("year", "country"))

peru$HealthSciences_ratio <- (peru$`Health Sciences.y` / peru$`Health Sciences.x`)*100
peru$LifeSciences_ratio <- (peru$`Life Sciences.y` / peru$`Life Sciences.x`)*100
peru$PhysicalSciences_ratio <- (peru$`Physical Sciences.y` / peru$`Physical Sciences.x`)*100
peru$SocialSciences_ratio <- (peru$`Social Sciences.y`/ peru$`Social Sciences.x`)*100
peru$HealthSciences_ratio_total <- (peru$`Health Sciences.x` / peru$total)*100
peru$LifeSciences_ratio_total <- (peru$`Life Sciences.x` / peru$total)*100
peru$PhysicalSciences_ratio_total <- (peru$`Physical Sciences.x` / peru$total)*100
peru$SocialSciences_ratio_total <- (peru$`Social Sciences.x`/ peru$total)*100
peru$HealthSciences_ratio_educ <- (peru$`Health Sciences.y` / peru$ed_sup)*100
peru$LifeSciences_ratio_educ <- (peru$`Life Sciences.y` / peru$ed_sup)*100
peru$PhysicalSciences_ratio_educ <- (peru$`Physical Sciences.y` / peru$ed_sup)*100
peru$SocialSciences_ratio_educ <- (peru$`Social Sciences.y`/ peru$ed_sup)*100



country <- 'Portugal'

portugal_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Portugal' group by year")
portugal_total <-  fetch(portugal_total, n=-1)
portugal_total <- cbind(portugal_total,country)
names(portugal_total)[names(portugal_total)=="count(distinct a.ut)"] <- "total"

portugal_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Portugal' and address like '%Univ%' group by year")
portugal_edsup <-  fetch(portugal_edsup, n=-1)
portugal_edsup <- cbind(portugal_edsup,country)
names(portugal_edsup)[names(portugal_edsup)=="count(distinct a.ut)"] <- "ed_sup"
portugal <- left_join(portugal_total, portugal_edsup, by = c("year", "country"))
portugal <- subset(portugal, year >=minimo & year <=maximo)
portugal$ratio <- (portugal$ed_sup / portugal$total)*100

portugal_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='portugal' group by a.year, b.area_desc")
portugal_disc_total <-  fetch(portugal_disc_total, n=-1)
portugal_disc_total <- cast(portugal_disc_total, year ~ area_desc, value='cant')
portugal_disc_total <- cbind(portugal_disc_total,country)

portugal <- left_join(portugal, portugal_disc_total, by = c("year", "country"))

portugal_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='portugal' and c.address like '%Univ%' group by a.year, b.area_desc")
portugal_disc_edsup <-  fetch(portugal_disc_edsup, n=-1)
portugal_disc_edsup <- cast(portugal_disc_edsup, year ~ area_desc, value='cant')
portugal_disc_edsup <- cbind(portugal_disc_edsup,country)

portugal <- left_join(portugal, portugal_disc_edsup, by = c("year", "country"))

portugal$HealthSciences_ratio <- (portugal$`Health Sciences.y` / portugal$`Health Sciences.x`)*100
portugal$LifeSciences_ratio <- (portugal$`Life Sciences.y` / portugal$`Life Sciences.x`)*100
portugal$PhysicalSciences_ratio <- (portugal$`Physical Sciences.y` / portugal$`Physical Sciences.x`)*100
portugal$SocialSciences_ratio <- (portugal$`Social Sciences.y`/ portugal$`Social Sciences.x`)*100
portugal$HealthSciences_ratio_total <- (portugal$`Health Sciences.x` / portugal$total)*100
portugal$LifeSciences_ratio_total <- (portugal$`Life Sciences.x` / portugal$total)*100
portugal$PhysicalSciences_ratio_total <- (portugal$`Physical Sciences.x` / portugal$total)*100
portugal$SocialSciences_ratio_total <- (portugal$`Social Sciences.x`/ portugal$total)*100
portugal$HealthSciences_ratio_educ <- (portugal$`Health Sciences.y` / portugal$ed_sup)*100
portugal$LifeSciences_ratio_educ <- (portugal$`Life Sciences.y` / portugal$ed_sup)*100
portugal$PhysicalSciences_ratio_educ <- (portugal$`Physical Sciences.y` / portugal$ed_sup)*100
portugal$SocialSciences_ratio_educ <- (portugal$`Social Sciences.y`/ portugal$ed_sup)*100



country <- 'Dominican Republic'

dominican_republic_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Dominican Republic' group by year")
dominican_republic_total <-  fetch(dominican_republic_total, n=-1)
dominican_republic_total <- cbind(dominican_republic_total,country)
names(dominican_republic_total)[names(dominican_republic_total)=="count(distinct a.ut)"] <- "total"

dominican_republic_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Dominican Republic' and address like '%Univ%' group by year")
dominican_republic_edsup <-  fetch(dominican_republic_edsup, n=-1)
dominican_republic_edsup <- cbind(dominican_republic_edsup,country)
names(dominican_republic_edsup)[names(dominican_republic_edsup)=="count(distinct a.ut)"] <- "ed_sup"
dominican_republic <- left_join(dominican_republic_total, dominican_republic_edsup, by = c("year", "country"))
dominican_republic <- subset(dominican_republic, year >=minimo & year <=maximo)
dominican_republic$ratio <- (dominican_republic$ed_sup / dominican_republic$total)*100

dominican_republic_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='Dominican Republic' group by a.year, b.area_desc")
dominican_republic_disc_total <-  fetch(dominican_republic_disc_total, n=-1)
dominican_republic_disc_total <- cast(dominican_republic_disc_total, year ~ area_desc, value='cant')
dominican_republic_disc_total <- cbind(dominican_republic_disc_total,country)

dominican_republic <- left_join(dominican_republic, dominican_republic_disc_total, by = c("year", "country"))

dominican_republic_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='Dominican Republic' and c.address like '%Univ%' group by a.year, b.area_desc")
dominican_republic_disc_edsup <-  fetch(dominican_republic_disc_edsup, n=-1)
dominican_republic_disc_edsup <- cast(dominican_republic_disc_edsup, year ~ area_desc, value='cant')
dominican_republic_disc_edsup <- cbind(dominican_republic_disc_edsup,country)

dominican_republic <- left_join(dominican_republic, dominican_republic_disc_edsup, by = c("year", "country"))

dominican_republic$HealthSciences_ratio <- (dominican_republic$`Health Sciences.y` / dominican_republic$`Health Sciences.x`)*100
dominican_republic$LifeSciences_ratio <- (dominican_republic$`Life Sciences.y` / dominican_republic$`Life Sciences.x`)*100
dominican_republic$PhysicalSciences_ratio <- (dominican_republic$`Physical Sciences.y` / dominican_republic$`Physical Sciences.x`)*100
dominican_republic$SocialSciences_ratio <- (dominican_republic$`Social Sciences.y`/ dominican_republic$`Social Sciences.x`)*100
dominican_republic$HealthSciences_ratio_total <- (dominican_republic$`Health Sciences.x` / dominican_republic$total)*100
dominican_republic$LifeSciences_ratio_total <- (dominican_republic$`Life Sciences.x` / dominican_republic$total)*100
dominican_republic$PhysicalSciences_ratio_total <- (dominican_republic$`Physical Sciences.x` / dominican_republic$total)*100
dominican_republic$SocialSciences_ratio_total <- (dominican_republic$`Social Sciences.x`/ dominican_republic$total)*100
dominican_republic$HealthSciences_ratio_educ <- (dominican_republic$`Health Sciences.y` / dominican_republic$ed_sup)*100
dominican_republic$LifeSciences_ratio_educ <- (dominican_republic$`Life Sciences.y` / dominican_republic$ed_sup)*100
dominican_republic$PhysicalSciences_ratio_educ <- (dominican_republic$`Physical Sciences.y` / dominican_republic$ed_sup)*100
dominican_republic$SocialSciences_ratio_educ <- (dominican_republic$`Social Sciences.y`/ dominican_republic$ed_sup)*100



country <- 'Uruguay'

uruguay_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Uruguay' group by year")
uruguay_total <-  fetch(uruguay_total, n=-1)
uruguay_total <- cbind(uruguay_total,country)
names(uruguay_total)[names(uruguay_total)=="count(distinct a.ut)"] <- "total"

uruguay_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Uruguay' and address like '%Univ%' group by year")
uruguay_edsup <-  fetch(uruguay_edsup, n=-1)
uruguay_edsup <- cbind(uruguay_edsup,country)
names(uruguay_edsup)[names(uruguay_edsup)=="count(distinct a.ut)"] <- "ed_sup"
uruguay <- left_join(uruguay_total, uruguay_edsup, by = c("year", "country"))
uruguay <- subset(uruguay, year >=minimo & year <=maximo)
uruguay$ratio <- (uruguay$ed_sup / uruguay$total)*100

uruguay_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='uruguay' group by a.year, b.area_desc")
uruguay_disc_total <-  fetch(uruguay_disc_total, n=-1)
uruguay_disc_total <- cast(uruguay_disc_total, year ~ area_desc, value='cant')
uruguay_disc_total <- cbind(uruguay_disc_total,country)

uruguay <- left_join(uruguay, uruguay_disc_total, by = c("year", "country"))

uruguay_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='uruguay' and c.address like '%Univ%' group by a.year, b.area_desc")
uruguay_disc_edsup <-  fetch(uruguay_disc_edsup, n=-1)
uruguay_disc_edsup <- cast(uruguay_disc_edsup, year ~ area_desc, value='cant')
uruguay_disc_edsup <- cbind(uruguay_disc_edsup,country)

uruguay <- left_join(uruguay, uruguay_disc_edsup, by = c("year", "country"))

uruguay$HealthSciences_ratio <- (uruguay$`Health Sciences.y` / uruguay$`Health Sciences.x`)*100
uruguay$LifeSciences_ratio <- (uruguay$`Life Sciences.y` / uruguay$`Life Sciences.x`)*100
uruguay$PhysicalSciences_ratio <- (uruguay$`Physical Sciences.y` / uruguay$`Physical Sciences.x`)*100
uruguay$SocialSciences_ratio <- (uruguay$`Social Sciences.y`/ uruguay$`Social Sciences.x`)*100
uruguay$HealthSciences_ratio_total <- (uruguay$`Health Sciences.x` / uruguay$total)*100
uruguay$LifeSciences_ratio_total <- (uruguay$`Life Sciences.x` / uruguay$total)*100
uruguay$PhysicalSciences_ratio_total <- (uruguay$`Physical Sciences.x` / uruguay$total)*100
uruguay$SocialSciences_ratio_total <- (uruguay$`Social Sciences.x`/ uruguay$total)*100
uruguay$HealthSciences_ratio_educ <- (uruguay$`Health Sciences.y` / uruguay$ed_sup)*100
uruguay$LifeSciences_ratio_educ <- (uruguay$`Life Sciences.y` / uruguay$ed_sup)*100
uruguay$PhysicalSciences_ratio_educ <- (uruguay$`Physical Sciences.y` / uruguay$ed_sup)*100
uruguay$SocialSciences_ratio_educ <- (uruguay$`Social Sciences.y`/ uruguay$ed_sup)*100



country <-'Venezuela'

venezuela_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Venezuela' group by year")
venezuela_total <-  fetch(venezuela_total, n=-1)
venezuela_total <- cbind(venezuela_total,country)
names(venezuela_total)[names(venezuela_total)=="count(distinct a.ut)"] <- "total"

venezuela_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Venezuela' and address like '%Univ%' group by year")
venezuela_edsup <-  fetch(venezuela_edsup, n=-1)
venezuela_edsup <- cbind(venezuela_edsup,country)
names(venezuela_edsup)[names(venezuela_edsup)=="count(distinct a.ut)"] <- "ed_sup"
venezuela <- left_join(venezuela_total, venezuela_edsup, by = c("year", "country"))
venezuela <- subset(venezuela, year >=minimo & year <=maximo)
venezuela$ratio <- (venezuela$ed_sup / venezuela$total)*100

venezuela_disc_total <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.country  ='venezuela' group by a.year, b.area_desc")
venezuela_disc_total <-  fetch(venezuela_disc_total, n=-1)
venezuela_disc_total <- cast(venezuela_disc_total, year ~ area_desc, value='cant')
venezuela_disc_total <- cbind(venezuela_disc_total,country)

venezuela <- left_join(venezuela, venezuela_disc_total, by = c("year", "country"))

venezuela_disc_edsup <- dbSendQuery(scopus_ibero, "select a.year, b.area_desc, count(distinct a.ut) as cant from scopus.discXrevista b, author_address c, scopus_ibero.ut_year_country a where b.name=a.pub_name and a.ut=c.ut and a.country  ='venezuela' and c.address like '%Univ%' group by a.year, b.area_desc")
venezuela_disc_edsup <-  fetch(venezuela_disc_edsup, n=-1)
venezuela_disc_edsup <- cast(venezuela_disc_edsup, year ~ area_desc, value='cant')
venezuela_disc_edsup <- cbind(venezuela_disc_edsup,country)

venezuela <- left_join(venezuela, venezuela_disc_edsup, by = c("year", "country"))

venezuela$HealthSciences_ratio <- (venezuela$`Health Sciences.y` / venezuela$`Health Sciences.x`)*100
venezuela$LifeSciences_ratio <- (venezuela$`Life Sciences.y` / venezuela$`Life Sciences.x`)*100
venezuela$PhysicalSciences_ratio <- (venezuela$`Physical Sciences.y` / venezuela$`Physical Sciences.x`)*100
venezuela$SocialSciences_ratio <- (venezuela$`Social Sciences.y`/ venezuela$`Social Sciences.x`)*100
venezuela$HealthSciences_ratio_total <- (venezuela$`Health Sciences.x` / venezuela$total)*100
venezuela$LifeSciences_ratio_total <- (venezuela$`Life Sciences.x` / venezuela$total)*100
venezuela$PhysicalSciences_ratio_total <- (venezuela$`Physical Sciences.x` / venezuela$total)*100
venezuela$SocialSciences_ratio_total <- (venezuela$`Social Sciences.x`/ venezuela$total)*100
venezuela$HealthSciences_ratio_educ <- (venezuela$`Health Sciences.y` / venezuela$ed_sup)*100
venezuela$LifeSciences_ratio_educ <- (venezuela$`Life Sciences.y` / venezuela$ed_sup)*100
venezuela$PhysicalSciences_ratio_educ <- (venezuela$`Physical Sciences.y` / venezuela$ed_sup)*100
venezuela$SocialSciences_ratio_educ <- (venezuela$`Social Sciences.y`/ venezuela$ed_sup)*100



country <- 'America Latina'

america_latina_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela')  group by year")
america_latina_total <-  fetch(america_latina_total, n=-1)
america_latina_total <- cbind(america_latina_total,country)
names(america_latina_total)[names(america_latina_total)=="count(distinct a.ut)"] <- "total"

america_latina_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela')  and address like '%Univ%' group by year")
america_latina_edsup <-  fetch(america_latina_edsup, n=-1)
america_latina_edsup <- cbind(america_latina_edsup,country)
names(america_latina_edsup)[names(america_latina_edsup)=="count(distinct a.ut)"] <- "ed_sup"
america_latina <- left_join(america_latina_total, america_latina_edsup, by = c("year", "country"))
america_latina <- subset(america_latina, year >=minimo & year <=maximo)
america_latina$ratio <- (america_latina$ed_sup / america_latina$total)*100



country <- 'Iberoamerica'

iberoamerica_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela' or country='Spain' or country='Portugal')  group by year")
iberoamerica_total <-  fetch(iberoamerica_total, n=-1)
iberoamerica_total <- cbind(iberoamerica_total,country)
names(iberoamerica_total)[names(iberoamerica_total)=="count(distinct a.ut)"] <- "total"

iberoamerica_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela' or country='Spain' or country='Portugal')  and address like '%Univ%' group by year")
iberoamerica_edsup <-  fetch(iberoamerica_edsup, n=-1)
iberoamerica_edsup <- cbind(iberoamerica_edsup,country)
names(iberoamerica_edsup)[names(iberoamerica_edsup)=="count(distinct a.ut)"] <- "ed_sup"
iberoamerica <- left_join(iberoamerica_total, iberoamerica_edsup, by = c("year", "country"))
iberoamerica <- subset(iberoamerica, year >=minimo & year <=maximo)
iberoamerica$ratio <- (iberoamerica$ed_sup / iberoamerica$total)*100


#########BASE CON TODOS LOS INDICADORES#########

total_disc <- rbind(argentina,bolivia, brazil, chile, colombia, costa_rica, cuba, ecuador, 
               el_salvador, spain, guatemala, honduras, mexico, nicaragua, panama, 
               paraguay, peru, portugal, dominican_republic, uruguay, venezuela)

setwd("~/SCI_genero")
setwd(".")
write.csv(total_disc, 'Base_Completa.csv')

#######BASE SOLO CON LOS PORCENTAJES DE PARTICIPACION#######

total <- total_disc %>% 
  select(year, total, country, ed_sup, ratio) %>% rbind(america_latina, iberoamerica)

total %>%  filter (year ==2010 | year==2017) %>%
  ggplot(aes(x = country, y = ratio, col = year, group = year)) + 
  geom_polygon(fill = NA, size = 2) + coord_polar() 


Totales01 <- total %>% 
  select(country, year, total) %>% 
  spread(year, total) %>% 
  mutate(indicador ='Total Publicaciones')

Totales02 <- total %>% 
  select(country, year, ed_sup) %>% 
  spread(year, ed_sup) %>% 
  mutate(indicador ='Publicaciones en Educ Superior')

Totales03 <- total %>% 
  select(country, year, ratio) %>% 
  spread(year, ratio) %>% 
  mutate(indicador ='Porcentaje')


Base_Final <- rbind(Totales01, Totales02, Totales03)

setwd("~/SCI_genero")
setwd(".")
write.csv(Base_Final, 'patentes_ed_superior.csv')

