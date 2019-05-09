
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



############EMPIEZA A ARMAR LOS CUADROS#################


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



country <- 'Bolivia'

bolivia_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Bolivia' group by year")
bolivia_total <-  fetch(bolivia_total, n=-1)
bolivia_total <- cbind(bolivia_total,country)
names(bolivia_total)[names(bolivia_total)=="count(distinct a.ut)"] <- "total"

bolivia_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Bolivia' and (address like '%Univ%' or address like '%univ%' or address like '%UMSA%' or address like '%Herb%' or address like '%herb%') group by year")
bolivia_edsup <-  fetch(bolivia_edsup, n=-1)
bolivia_edsup <- cbind(bolivia_edsup,country)
names(bolivia_edsup)[names(bolivia_edsup)=="count(distinct a.ut)"] <- "ed_sup"
bolivia <- left_join(bolivia_total, bolivia_edsup, by = c("year", "country"))
bolivia <- subset(bolivia, year >=minimo & year <=maximo)
bolivia$ratio <- (bolivia$ed_sup / bolivia$total)*100

####select *  from author_address a, article b where a.ut=b.ut and country='Bolivia' and (address NOT like '%Univ%' and address NOT like '%univ%' and address NOT like '%UMSA%' and address NOT like '%Herb%')###


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





country <- 'Costa Rica'

costa_rica_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Costa Rica' group by year")
costa_rica_total <-  fetch(costa_rica_total, n=-1)
costa_rica_total <- cbind(costa_rica_total,country)
names(costa_rica_total)[names(costa_rica_total)=="count(distinct a.ut)"] <- "total"

costa_rica_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Costa Rica' and (address like '%Univ%' OR address like '%UCR%' OR address like '%ULACIT%' or address like '%Instituto Tecnol%' or address like '%INCAE%') group by year")
costa_rica_edsup <-  fetch(costa_rica_edsup, n=-1)
costa_rica_edsup <- cbind(costa_rica_edsup,country)
names(costa_rica_edsup)[names(costa_rica_edsup)=="count(distinct a.ut)"] <- "ed_sup"
costa_rica <- left_join(costa_rica_total, costa_rica_edsup, by = c("year", "country"))
costa_rica <- subset(costa_rica, year >=minimo & year <=maximo)
costa_rica$ratio <- (costa_rica$ed_sup / costa_rica$total)*100

###select * from author_address a, article b where a.ut=b.ut and country='Costa Rica' and (address NOT like '%Univ%' and address NOT like '%Univ%' AND address NOT like '%UCR%' and address NOT like '%ULACIT%')###



country <- 'Cuba'

cuba_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Cuba' group by year")
cuba_total <-  fetch(cuba_total, n=-1)
cuba_total <- cbind(cuba_total,country)
names(cuba_total)[names(cuba_total)=="count(distinct a.ut)"] <- "total"

cuba_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Cuba' and (address like '%Univ%' or address like '%ENSAP%' or address like '%Escuela Nacional de Sa%' or address like '%escuela nacional%') group by year")
cuba_edsup <-  fetch(cuba_edsup, n=-1)
cuba_edsup <- cbind(cuba_edsup,country)
names(cuba_edsup)[names(cuba_edsup)=="count(distinct a.ut)"] <- "ed_sup"
cuba <- left_join(cuba_total, cuba_edsup, by = c("year", "country"))
cuba <- subset(cuba, year >=minimo & year <=maximo)
cuba$ratio <- (cuba$ed_sup / cuba$total)*100


country <- 'Ecuador'

ecuador_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Ecuador' group by year")
ecuador_total <-  fetch(ecuador_total, n=-1)
ecuador_total <- cbind(ecuador_total,country)
names(ecuador_total)[names(ecuador_total)=="count(distinct a.ut)"] <- "total"

ecuador_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Ecuador' and (address like '%Univ%' or address like '%Escuela Sup%' or address like '%Escuela Polit%') group by year")
ecuador_edsup <-  fetch(ecuador_edsup, n=-1)
ecuador_edsup <- cbind(ecuador_edsup,country)
names(ecuador_edsup)[names(ecuador_edsup)=="count(distinct a.ut)"] <- "ed_sup"
ecuador <- left_join(ecuador_total, ecuador_edsup, by = c("year", "country"))
ecuador <- subset(ecuador, year >=minimo & year <=maximo)
ecuador$ratio <- (ecuador$ed_sup / ecuador$total)*100




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



country <- 'Guatemala'

guatemala_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Guatemala' group by year")
guatemala_total <-  fetch(guatemala_total, n=-1)
guatemala_total <- cbind(guatemala_total,country)
names(guatemala_total)[names(guatemala_total)=="count(distinct a.ut)"] <- "total"

guatemala_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Guatemala' and (address like '%Univ%' or address like '%Escuela%' group by year")
guatemala_edsup <-  fetch(guatemala_edsup, n=-1)
guatemala_edsup <- cbind(guatemala_edsup,country)
names(guatemala_edsup)[names(guatemala_edsup)=="count(distinct a.ut)"] <- "ed_sup"
guatemala <- left_join(guatemala_total, guatemala_edsup, by = c("year", "country"))
guatemala <- subset(guatemala, year >=minimo & year <=maximo)
guatemala$ratio <- (guatemala$ed_sup / guatemala$total)*100

country <- 'Honduras'

honduras_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Honduras' group by year")
honduras_total <-  fetch(honduras_total, n=-1)
honduras_total <- cbind(honduras_total,country)
names(honduras_total)[names(honduras_total)=="count(distinct a.ut)"] <- "total"

honduras_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Honduras' and (address like '%Univ%' OR address like '%Escuela%') group by year")
honduras_edsup <-  fetch(honduras_edsup, n=-1)
honduras_edsup <- cbind(honduras_edsup,country)
names(honduras_edsup)[names(honduras_edsup)=="count(distinct a.ut)"] <- "ed_sup"
honduras <- left_join(honduras_total, honduras_edsup, by = c("year", "country"))
honduras <- subset(honduras, year >=minimo & year <=maximo)
honduras$ratio <- (honduras$ed_sup / honduras$total)*100



country <- 'Mexico'

mexico_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Mexico' group by year")
mexico_total <-  fetch(mexico_total, n=-1)
mexico_total <- cbind(mexico_total,country)
names(mexico_total)[names(mexico_total)=="count(distinct a.ut)"] <- "total"

mexico_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Mexico' and (address like '%Univ%'  or address like '%IPN%'   or address like '%Instituto Politécnico%'  or address like '%Instituto Polit%' or address like '%Inst. Polit%'  or address like '%Tecnológico de%'   or address like '%Tecnologico de%' or address like '%Inst. Tecnol%' or address like '%Instituto Tecn%' or address like '%Escuela%' or address like '%UNAM%'or address like '%CINVESTAV%' or address like '%ITESM%'  or address like '%Institute de%' or address like '%Institute of Technology%') group by year")
mexico_edsup <-  fetch(mexico_edsup, n=-1)
mexico_edsup <- cbind(mexico_edsup,country)
names(mexico_edsup)[names(mexico_edsup)=="count(distinct a.ut)"] <- "ed_sup"
mexico <- left_join(mexico_total, mexico_edsup, by = c("year", "country"))
mexico <- subset(mexico, year >=minimo & year <=maximo)
mexico$ratio <- (mexico$ed_sup / mexico$total)*100


country <- 'Nicaragua'

nicaragua_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Nicaragua' group by year")
nicaragua_total <-  fetch(nicaragua_total, n=-1)
nicaragua_total <- cbind(nicaragua_total,country)
names(nicaragua_total)[names(nicaragua_total)=="count(distinct a.ut)"] <- "total"

nicaragua_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Nicaragua' and (address like '%Univ%' or address like '%INCAE%' or address like '%univ%') group by year")
nicaragua_edsup <-  fetch(nicaragua_edsup, n=-1)
nicaragua_edsup <- cbind(nicaragua_edsup,country)
names(nicaragua_edsup)[names(nicaragua_edsup)=="count(distinct a.ut)"] <- "ed_sup"
nicaragua <- left_join(nicaragua_total, nicaragua_edsup, by = c("year", "country"))
nicaragua <- subset(nicaragua, year >=minimo & year <=maximo)
nicaragua$ratio <- (nicaragua$ed_sup / nicaragua$total)*100




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

country <- 'Peru'

peru_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Peru' group by year")
peru_total <-  fetch(peru_total, n=-1)
peru_total <- cbind(peru_total,country)
names(peru_total)[names(peru_total)=="count(distinct a.ut)"] <- "total"

peru_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Peru' and (address like '%Univ%' or address like '%CIP%') group by year")
peru_edsup <-  fetch(peru_edsup, n=-1)
peru_edsup <- cbind(peru_edsup,country)
names(peru_edsup)[names(peru_edsup)=="count(distinct a.ut)"] <- "ed_sup"
peru <- left_join(peru_total, peru_edsup, by = c("year", "country"))
peru <- subset(peru, year >=minimo & year <=maximo)
peru$ratio <- (peru$ed_sup / peru$total)*100

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




country <- 'Dominican Republic'

dominican_republic_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Dominican Republic' group by year")
dominican_republic_total <-  fetch(dominican_republic_total, n=-1)
dominican_republic_total <- cbind(dominican_republic_total,country)
names(dominican_republic_total)[names(dominican_republic_total)=="count(distinct a.ut)"] <- "total"

dominican_republic_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Dominican Republic' and (address like '%Univ%' OR address like '%UNIBE%' OR address like '%INTEC%'OR address like '%Instituto Tecn%' OR address like '%Colegio%' OR address like '%instituto tecn%') group by year")
dominican_republic_edsup <-  fetch(dominican_republic_edsup, n=-1)
dominican_republic_edsup <- cbind(dominican_republic_edsup,country)
names(dominican_republic_edsup)[names(dominican_republic_edsup)=="count(distinct a.ut)"] <- "ed_sup"
dominican_republic <- left_join(dominican_republic_total, dominican_republic_edsup, by = c("year", "country"))
dominican_republic <- subset(dominican_republic, year >=minimo & year <=maximo)
dominican_republic$ratio <- (dominican_republic$ed_sup / dominican_republic$total)*100




country <- 'Uruguay'

uruguay_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and country='Uruguay' group by year")
uruguay_total <-  fetch(uruguay_total, n=-1)
uruguay_total <- cbind(uruguay_total,country)
names(uruguay_total)[names(uruguay_total)=="count(distinct a.ut)"] <- "total"

uruguay_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and country='Uruguay' and (address like '%Univ%' or address like '%UDELAR%' or address like '%UdeLAR%' or address like '%Facultad %') group by year")
uruguay_edsup <-  fetch(uruguay_edsup, n=-1)
uruguay_edsup <- cbind(uruguay_edsup,country)
names(uruguay_edsup)[names(uruguay_edsup)=="count(distinct a.ut)"] <- "ed_sup"
uruguay <- left_join(uruguay_total, uruguay_edsup, by = c("year", "country"))
uruguay <- subset(uruguay, year >=minimo & year <=maximo)
uruguay$ratio <- (uruguay$ed_sup / uruguay$total)*100



country <- 'Venezuela'

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

  country <- 'America Latina'
  
  america_latina_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut  and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela')  group by year")
  america_latina_total <-  fetch(america_latina_total, n=-1)
  america_latina_total <- cbind(america_latina_total,country)
  names(america_latina_total)[names(america_latina_total)=="count(distinct a.ut)"] <- "total"
  
  america_latina_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela')  and (address like '%Univ%' or address like '%Escuela%' or address like '%Instituto Tecn%') group by year")
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

iberoamerica_edsup <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from author_address a, article b where a.ut=b.ut and (country='Argentina' or country='Bolivia'  or country='Brazil'  or country='Chile'  or country='Colombia'  or country='Costa Rica'  or country='Cuba'  or country='Ecuador'  or country='El Salvador'  or country='Guatemala'  or country='Honduras'  or country='Mexico'  or country='Nicaragua'  or country='Panama'  or country='Paraguay'  or country='Peru'  or country='Dominican Republic'  or country='Uruguay'  or country='Venezuela' or country='Spain' or country='Portugal')  and  (address like '%Univ%' or address like '%Escuela%' or address like '%Instituto Tecn%') group by year")
iberoamerica_edsup <-  fetch(iberoamerica_edsup, n=-1)
iberoamerica_edsup <- cbind(iberoamerica_edsup,country)
names(iberoamerica_edsup)[names(iberoamerica_edsup)=="count(distinct a.ut)"] <- "ed_sup"
iberoamerica <- left_join(iberoamerica_total, iberoamerica_edsup, by = c("year", "country"))
iberoamerica <- subset(iberoamerica, year >=minimo & year <=maximo)
iberoamerica$ratio <- (iberoamerica$ed_sup / iberoamerica$total)*100

total <- rbind(argentina,bolivia, brazil, chile, colombia, costa_rica, cuba, ecuador, el_salvador, spain, guatemala, honduras, mexico, nicaragua, panama, paraguay, peru, portugal, dominican_republic, uruguay, venezuela, america_latina, iberoamerica)


########################JUNTAR DATOS#####################

plot_ly(total, x = ~year, y = ~ratio, type = 'scatter',  color = ~country, mode = 'lines')

###REGIONALES###
  
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
write.csv(Base_Final, 'Base_Final.csv')







