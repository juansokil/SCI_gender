


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
library(igraph)
library(scales)
library(Cairo)


setwd("~/SCI_genero")
source('./00-sql.r', encoding = 'latin1')


###########################################ARGENTINA################################
####CONSULTA PARA VER LAS CANTIDADES POR PAIS 
cantidades_total_Argentina<- dbSendQuery(scopus_ar, "select country, year, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and (country='Argentina') group by country, year")
cantidades_total_Argentina <-  fetch(cantidades_total_Argentina, n=-1)
cantidades_nano_Argentina<- dbSendQuery(scopus_ar, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_ar.author_address b where a.ut=b.ut and (b.country='Argentina') group by b.country, a.year")
cantidades_nano_Argentina <-  fetch(cantidades_nano_Argentina, n=-1)
cantidades_biotech_Argentina<- dbSendQuery(scopus_ar, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_ar.author_address b where a.ut=b.ut and (b.country='Argentina') group by b.country, a.year")
cantidades_biotech_Argentina <-  fetch(cantidades_biotech_Argentina, n=-1)
cantidades_tic_Argentina<- dbSendQuery(scopus_ar, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_ar.author_address b where a.ut=b.ut and (b.country='Argentina') group by b.country, a.year")
cantidades_tic_Argentina <-  fetch(cantidades_tic_Argentina, n=-1)

####CONSULTA PARA VER LAS CANTIDADES UNIVERSIDADES
cantidades_total_univ_Argentina<- dbSendQuery(scopus_ar, "select b.inst_id , year, count(distinct a.ut) as cant from article a, articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014) group by b.inst_id, year")
cantidades_total_univ_Argentina <-  fetch(cantidades_total_univ_Argentina, n=-1)

cantidades_nano_univ_Argentina<- dbSendQuery(scopus_ar, "select b.inst_id , a.year, count(distinct a.ut)  from scopus_ibero.article_nano a, scopus_ar.articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014) group by b.inst_id, a.year")
cantidades_nano_univ_Argentina <-  fetch(cantidades_nano_univ_Argentina, n=-1)

cantidades_biotech_univ_Argentina<- dbSendQuery(scopus_ar, "select b.inst_id , a.year, count(distinct a.ut)  from scopus_ibero.article_biotech a, scopus_ar.articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014) group by b.inst_id, a.year")
cantidades_biotech_univ_Argentina <-  fetch(cantidades_biotech_univ_Argentina, n=-1)

cantidades_tic_univ_Argentina<- dbSendQuery(scopus_ar, "select b.inst_id , a.year, count(distinct a.ut)  from scopus_ibero.article_tic a, scopus_ar.articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014) group by b.inst_id, a.year")
cantidades_tic_univ_Argentina <-  fetch(cantidades_tic_univ_Argentina, n=-1)



####REDES
redes_nano_univ_Argentina<- dbSendQuery(scopus_ar, "select distinct b.inst_id, a.ut from scopus_ibero.article_nano a, scopus_ar.articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014)")
redes_nano_univ_Argentina <-  fetch(redes_nano_univ_Argentina, n=-1)

redes_biotech_univ_Argentina<- dbSendQuery(scopus_ar, "select distinct b.inst_id, a.ut from scopus_ibero.article_biotech a, scopus_ar.articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014)")
redes_biotech_univ_Argentina <-  fetch(redes_biotech_univ_Argentina, n=-1)

redes_tic_univ_Argentina<- dbSendQuery(scopus_ar, "select distinct b.inst_id, a.ut from scopus_ibero.article_tic a, scopus_ar.articleXinstitution b where a.ut=b.ut and (inst_id=1000 or inst_id=1003 or inst_id=1014)")
redes_tic_univ_Argentina <-  fetch(redes_tic_univ_Argentina, n=-1)



###########################################Brazil################################
####CONSULTA PARA VER LAS CANTIDADES POR PAIS 
cantidades_total_Brazil<- dbSendQuery(scopus_br, "select country, year, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and (country='Brazil') group by country, year")
cantidades_total_Brazil <-  fetch(cantidades_total_Brazil, n=-1)
cantidades_nano_Brazil<- dbSendQuery(scopus_br, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_br.author_address b where a.ut=b.ut and (b.country='Brazil') group by b.country, a.year")
cantidades_nano_Brazil <-  fetch(cantidades_nano_Brazil, n=-1)
cantidades_biotech_Brazil<- dbSendQuery(scopus_br, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_br.author_address b where a.ut=b.ut and (b.country='Brazil') group by b.country, a.year")
cantidades_biotech_Brazil <-  fetch(cantidades_biotech_Brazil, n=-1)
cantidades_tic_Brazil<- dbSendQuery(scopus_br, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_br.author_address b where a.ut=b.ut and (b.country='Brazil') group by b.country, a.year")
cantidades_tic_Brazil <-  fetch(cantidades_tic_Brazil, n=-1)


####CONSULTA PARA VER LAS CANTIDADES UNIVERSIDADES
cantidades_total_univ_Brazil<- dbSendQuery(scopus_br, "select b.inst_id, year, count(distinct a.ut) as cant from article a, authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9) group by inst_id, year")
cantidades_total_univ_Brazil <-  fetch(cantidades_total_univ_Brazil, n=-1)
cantidades_nano_univ_Brazil<- dbSendQuery(scopus_br, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_br.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9) group by b.inst_id, a.year")
cantidades_nano_univ_Brazil <-  fetch(cantidades_nano_univ_Brazil, n=-1)
cantidades_biotech_univ_Brazil<- dbSendQuery(scopus_br, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_br.authorXinstitution b where a.ut=b.ut  and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9) group by b.inst_id, a.year")
cantidades_biotech_univ_Brazil <-  fetch(cantidades_biotech_univ_Brazil, n=-1)
cantidades_tic_univ_Brazil<- dbSendQuery(scopus_br, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_br.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9) group by b.inst_id, a.year")
cantidades_tic_univ_Brazil <-  fetch(cantidades_tic_univ_Brazil, n=-1)



####REDES
redes_nano_univ_Brazil<- dbSendQuery(scopus_br, "select distinct b.inst_id, a.ut from scopus_ibero.article_nano a, scopus_br.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9) ")
redes_nano_univ_Brazil <-  fetch(redes_nano_univ_Brazil, n=-1)
redes_biotech_univ_Brazil<- dbSendQuery(scopus_br, "select distinct b.inst_id, a.ut from scopus_ibero.article_biotech a, scopus_br.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9) ")
redes_biotech_univ_Brazil <-  fetch(redes_biotech_univ_Brazil, n=-1)
redes_tic_univ_Brazil<- dbSendQuery(scopus_br, "select distinct b.inst_id, a.ut from scopus_ibero.article_tic a, scopus_br.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3 or inst_id=7 or inst_id=4 or inst_id=5 or inst_id=21 or inst_id=13 or inst_id=6 or inst_id=9)")
redes_tic_univ_Brazil <-  fetch(redes_tic_univ_Brazil, n=-1)












###########################################Chile################################
####CONSULTA PARA VER LAS CANTIDADES POR PAIS 
cantidades_total_Chile<- dbSendQuery(scopus_cl, "select country, year, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and (country='Chile') group by country, year")
cantidades_total_Chile <-  fetch(cantidades_total_Chile, n=-1)
cantidades_nano_Chile<- dbSendQuery(scopus_cl, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_cl.author_address b where a.ut=b.ut and (b.country='Chile') group by b.country, a.year")
cantidades_nano_Chile <-  fetch(cantidades_nano_Chile, n=-1)
cantidades_biotech_Chile<- dbSendQuery(scopus_cl, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_cl.author_address b where a.ut=b.ut and (b.country='Chile') group by b.country, a.year")
cantidades_biotech_Chile <-  fetch(cantidades_biotech_Chile, n=-1)
cantidades_tic_Chile<- dbSendQuery(scopus_cl, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_cl.author_address b where a.ut=b.ut and (b.country='Chile') group by b.country, a.year")
cantidades_tic_Chile <-  fetch(cantidades_tic_Chile, n=-1)


####CONSULTA PARA VER LAS CANTIDADES UNIVERSIDADES
cantidades_total_univ_Chile<- dbSendQuery(scopus_cl, "select b.inst_id, year, count(distinct a.ut) as cant from article a, authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3) group by inst_id, year")
cantidades_total_univ_Chile <-  fetch(cantidades_total_univ_Chile, n=-1)
cantidades_nano_univ_Chile<- dbSendQuery(scopus_cl, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_cl.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3) group by b.inst_id, a.year")
cantidades_nano_univ_Chile <-  fetch(cantidades_nano_univ_Chile, n=-1)
cantidades_biotech_univ_Chile<- dbSendQuery(scopus_cl, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_cl.authorXinstitution b where a.ut=b.ut  and (inst_id=1 or inst_id=2 or inst_id=3) group by b.inst_id, a.year")
cantidades_biotech_univ_Chile <-  fetch(cantidades_biotech_univ_Chile, n=-1)
cantidades_tic_univ_Chile<- dbSendQuery(scopus_cl, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_cl.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3) group by b.inst_id, a.year")
cantidades_tic_univ_Chile <-  fetch(cantidades_tic_univ_Chile, n=-1)



####REDES
redes_nano_univ_Chile<- dbSendQuery(scopus_cl, "select distinct b.inst_id, a.ut from scopus_ibero.article_nano a, scopus_cl.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3) ")
redes_nano_univ_Chile <-  fetch(redes_nano_univ_Chile, n=-1)
redes_biotech_univ_Chile<- dbSendQuery(scopus_cl, "select distinct b.inst_id, a.ut from scopus_ibero.article_biotech a, scopus_cl.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3) ")
redes_biotech_univ_Chile <-  fetch(redes_biotech_univ_Chile, n=-1)
redes_tic_univ_Chile<- dbSendQuery(scopus_cl, "select distinct b.inst_id, a.ut from scopus_ibero.article_tic a, scopus_cl.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2 or inst_id=3)")
redes_tic_univ_Chile <-  fetch(redes_tic_univ_Chile, n=-1)








###########################################Colombia################################
####CONSULTA PARA VER LAS CANTIDADES POR PAIS 
cantidades_total_Colombia<- dbSendQuery(scopus_co, "select country, year, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and (country='Colombia') group by country, year")
cantidades_total_Colombia <-  fetch(cantidades_total_Colombia, n=-1)
cantidades_nano_Colombia<- dbSendQuery(scopus_co, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_co.author_address b where a.ut=b.ut and (b.country='Colombia') group by b.country, a.year")
cantidades_nano_Colombia <-  fetch(cantidades_nano_Colombia, n=-1)
cantidades_biotech_Colombia<- dbSendQuery(scopus_co, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_co.author_address b where a.ut=b.ut and (b.country='Colombia') group by b.country, a.year")
cantidades_biotech_Colombia <-  fetch(cantidades_biotech_Colombia, n=-1)
cantidades_tic_Colombia<- dbSendQuery(scopus_co, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_co.author_address b where a.ut=b.ut and (b.country='Colombia') group by b.country, a.year")
cantidades_tic_Colombia <-  fetch(cantidades_tic_Colombia, n=-1)


####CONSULTA PARA VER LAS CANTIDADES UNIVERSIDADES
cantidades_total_univ_Colombia<- dbSendQuery(scopus_co, "select b.inst_id, year, count(distinct a.ut) as cant from article a, authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2) group by inst_id, year")
cantidades_total_univ_Colombia <-  fetch(cantidades_total_univ_Colombia, n=-1)
cantidades_nano_univ_Colombia<- dbSendQuery(scopus_co, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_co.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2) group by b.inst_id, a.year")
cantidades_nano_univ_Colombia <-  fetch(cantidades_nano_univ_Colombia, n=-1)
cantidades_biotech_univ_Colombia<- dbSendQuery(scopus_co, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_co.authorXinstitution b where a.ut=b.ut  and (inst_id=1 or inst_id=2) group by b.inst_id, a.year")
cantidades_biotech_univ_Colombia <-  fetch(cantidades_biotech_univ_Colombia, n=-1)
cantidades_tic_univ_Colombia<- dbSendQuery(scopus_co, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_co.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2) group by b.inst_id, a.year")
cantidades_tic_univ_Colombia <-  fetch(cantidades_tic_univ_Colombia, n=-1)



####REDES
redes_nano_univ_Colombia<- dbSendQuery(scopus_co, "select distinct b.inst_id, a.ut from scopus_ibero.article_nano a, scopus_co.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2) ")
redes_nano_univ_Colombia <-  fetch(redes_nano_univ_Colombia, n=-1)
redes_biotech_univ_Colombia<- dbSendQuery(scopus_co, "select distinct b.inst_id, a.ut from scopus_ibero.article_biotech a, scopus_co.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2) ")
redes_biotech_univ_Colombia <-  fetch(redes_biotech_univ_Colombia, n=-1)
redes_tic_univ_Colombia<- dbSendQuery(scopus_co, "select distinct b.inst_id, a.ut from scopus_ibero.article_tic a, scopus_co.authorXinstitution b where a.ut=b.ut and (inst_id=1 or inst_id=2)")
redes_tic_univ_Colombia <-  fetch(redes_tic_univ_Colombia, n=-1)






###########################################Mexico################################
####CONSULTA PARA VER LAS CANTIDADES POR PAIS 
cantidades_total_Mexico<- dbSendQuery(scopus_mx, "select country, year, count(distinct a.ut) from article a, author_address b where a.ut=b.ut and (country='Mexico') group by country, year")
cantidades_total_Mexico <-  fetch(cantidades_total_Mexico, n=-1)
cantidades_nano_Mexico<- dbSendQuery(scopus_mx, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_mx.author_address b where a.ut=b.ut and (b.country='Mexico') group by b.country, a.year")
cantidades_nano_Mexico <-  fetch(cantidades_nano_Mexico, n=-1)
cantidades_biotech_Mexico<- dbSendQuery(scopus_mx, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_mx.author_address b where a.ut=b.ut and (b.country='Mexico') group by b.country, a.year")
cantidades_biotech_Mexico <-  fetch(cantidades_biotech_Mexico, n=-1)
cantidades_tic_Mexico<- dbSendQuery(scopus_mx, "select b.country, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_mx.author_address b where a.ut=b.ut and (b.country='Mexico') group by b.country, a.year")
cantidades_tic_Mexico <-  fetch(cantidades_tic_Mexico, n=-1)


####CONSULTA PARA VER LAS CANTIDADES UNIVERSIDADES
cantidades_total_univ_Mexico<- dbSendQuery(scopus_mx, "select b.inst_id, year, count(distinct a.ut) as cant from article a, authorXinstitution b where a.ut=b.ut and (inst_id=1001 or inst_id=1002) group by inst_id, year")
cantidades_total_univ_Mexico <-  fetch(cantidades_total_univ_Mexico, n=-1)
cantidades_nano_univ_Mexico<- dbSendQuery(scopus_mx, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_nano a, scopus_mx.authorXinstitution b where a.ut=b.ut and (inst_id=1001 or inst_id=1002) group by b.inst_id, a.year")
cantidades_nano_univ_Mexico <-  fetch(cantidades_nano_univ_Mexico, n=-1)
cantidades_biotech_univ_Mexico<- dbSendQuery(scopus_mx, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_biotech a, scopus_mx.authorXinstitution b where a.ut=b.ut  and (inst_id=1001 or inst_id=1002) group by b.inst_id, a.year")
cantidades_biotech_univ_Mexico <-  fetch(cantidades_biotech_univ_Mexico, n=-1)
cantidades_tic_univ_Mexico<- dbSendQuery(scopus_mx, "select b.inst_id, a.year, count(distinct a.ut) from scopus_ibero.article_tic a, scopus_mx.authorXinstitution b where a.ut=b.ut and (inst_id=1001 or inst_id=1002) group by b.inst_id, a.year")
cantidades_tic_univ_Mexico <-  fetch(cantidades_tic_univ_Mexico, n=-1)



####REDES
redes_nano_univ_Mexico<- dbSendQuery(scopus_mx, "select distinct b.inst_id, a.ut from scopus_ibero.article_nano a, scopus_mx.authorXinstitution b where a.ut=b.ut and (inst_id=1001 or inst_id=1002) ")
redes_nano_univ_Mexico <-  fetch(redes_nano_univ_Mexico, n=-1)
redes_biotech_univ_Mexico<- dbSendQuery(scopus_mx, "select distinct b.inst_id, a.ut from scopus_ibero.article_biotech a, scopus_mx.authorXinstitution b where a.ut=b.ut and (inst_id=1001 or inst_id=1002) ")
redes_biotech_univ_Mexico <-  fetch(redes_biotech_univ_Mexico, n=-1)
redes_tic_univ_Mexico<- dbSendQuery(scopus_mx, "select distinct b.inst_id, a.ut from scopus_ibero.article_tic a, scopus_mx.authorXinstitution b where a.ut=b.ut and (inst_id=1001 or inst_id=1002)")
redes_tic_univ_Mexico <-  fetch(redes_tic_univ_Mexico, n=-1)








#################TOTAL#############



cantidades_total_Total <- rbind(cantidades_total_Argentina, cantidades_total_Brazil, cantidades_total_Chile, cantidades_total_Colombia, cantidades_total_Mexico)
cantidades_nano_Total <- rbind(cantidades_nano_Argentina, cantidades_nano_Brazil, cantidades_nano_Chile, cantidades_nano_Colombia, cantidades_nano_Mexico)
cantidades_biotech_Total <- rbind(cantidades_biotech_Argentina, cantidades_biotech_Brazil, cantidades_biotech_Chile, cantidades_biotech_Colombia, cantidades_biotech_Mexico)
cantidades_tic_Total <- rbind(cantidades_tic_Argentina, cantidades_tic_Brazil, cantidades_tic_Chile, cantidades_tic_Colombia, cantidades_tic_Mexico)


####Crea las etiquetas####

cantidades_total_univ_Argentina$inst_name[cantidades_total_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
cantidades_total_univ_Argentina$inst_name[cantidades_total_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
cantidades_total_univ_Argentina$inst_name[cantidades_total_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
cantidades_total_univ_Argentina$country = 'AR'

cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
cantidades_total_univ_Brazil$inst_name[cantidades_total_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
cantidades_total_univ_Brazil$country = 'BR'

cantidades_total_univ_Chile$inst_name[cantidades_total_univ_Chile$inst_id==1]<- 'Univ de Chile'
cantidades_total_univ_Chile$inst_name[cantidades_total_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
cantidades_total_univ_Chile$inst_name[cantidades_total_univ_Chile$inst_id==3]<- 'Univ de Concepción'
cantidades_total_univ_Chile$country = 'CL'

cantidades_total_univ_Colombia$inst_name[cantidades_total_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
cantidades_total_univ_Colombia$inst_name[cantidades_total_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
cantidades_total_univ_Colombia$country = 'CO'

cantidades_total_univ_Mexico$inst_name[cantidades_total_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
cantidades_total_univ_Mexico$inst_name[cantidades_total_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
cantidades_total_univ_Mexico$country = 'MX'

cantidades_nano_univ_Argentina$inst_name[cantidades_nano_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
cantidades_nano_univ_Argentina$inst_name[cantidades_nano_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
cantidades_nano_univ_Argentina$inst_name[cantidades_nano_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
cantidades_nano_univ_Argentina$country = 'AR'

cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
cantidades_nano_univ_Brazil$inst_name[cantidades_nano_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
cantidades_nano_univ_Brazil$country = 'BR'

cantidades_nano_univ_Chile$inst_name[cantidades_nano_univ_Chile$inst_id==1]<- 'Univ de Chile'
cantidades_nano_univ_Chile$inst_name[cantidades_nano_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
cantidades_nano_univ_Chile$inst_name[cantidades_nano_univ_Chile$inst_id==3]<- 'Univ de Concepción'
cantidades_nano_univ_Chile$country = 'CL'

cantidades_nano_univ_Colombia$inst_name[cantidades_nano_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
cantidades_nano_univ_Colombia$inst_name[cantidades_nano_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
cantidades_nano_univ_Colombia$country = 'CO'

cantidades_nano_univ_Mexico$inst_name[cantidades_nano_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
cantidades_nano_univ_Mexico$inst_name[cantidades_nano_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
cantidades_nano_univ_Mexico$country = 'MX'

cantidades_biotech_univ_Argentina$inst_name[cantidades_biotech_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
cantidades_biotech_univ_Argentina$inst_name[cantidades_biotech_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
cantidades_biotech_univ_Argentina$inst_name[cantidades_biotech_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
cantidades_biotech_univ_Argentina$country = 'AR'

cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
cantidades_biotech_univ_Brazil$inst_name[cantidades_biotech_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
cantidades_biotech_univ_Brazil$country = 'BR'

cantidades_biotech_univ_Chile$inst_name[cantidades_biotech_univ_Chile$inst_id==1]<- 'Univ de Chile'
cantidades_biotech_univ_Chile$inst_name[cantidades_biotech_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
cantidades_biotech_univ_Chile$inst_name[cantidades_biotech_univ_Chile$inst_id==3]<- 'Univ de Concepción'
cantidades_biotech_univ_Chile$country = 'CL'

cantidades_biotech_univ_Colombia$inst_name[cantidades_biotech_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
cantidades_biotech_univ_Colombia$inst_name[cantidades_biotech_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
cantidades_biotech_univ_Colombia$country = 'CO'

cantidades_biotech_univ_Mexico$inst_name[cantidades_biotech_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
cantidades_biotech_univ_Mexico$inst_name[cantidades_biotech_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
cantidades_biotech_univ_Mexico$country = 'MX'

cantidades_tic_univ_Argentina$inst_name[cantidades_tic_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
cantidades_tic_univ_Argentina$inst_name[cantidades_tic_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
cantidades_tic_univ_Argentina$inst_name[cantidades_tic_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
cantidades_tic_univ_Argentina$country = 'AR'

cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
cantidades_tic_univ_Brazil$inst_name[cantidades_tic_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
cantidades_tic_univ_Brazil$country = 'BR'

cantidades_tic_univ_Chile$inst_name[cantidades_tic_univ_Chile$inst_id==1]<- 'Univ de Chile'
cantidades_tic_univ_Chile$inst_name[cantidades_tic_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
cantidades_tic_univ_Chile$inst_name[cantidades_tic_univ_Chile$inst_id==3]<- 'Univ de Concepción'
cantidades_tic_univ_Chile$country = 'CL'

cantidades_tic_univ_Colombia$inst_name[cantidades_tic_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
cantidades_tic_univ_Colombia$inst_name[cantidades_tic_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
cantidades_tic_univ_Colombia$country = 'CO'

cantidades_tic_univ_Mexico$inst_name[cantidades_tic_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
cantidades_tic_univ_Mexico$inst_name[cantidades_tic_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
cantidades_tic_univ_Mexico$country = 'MX'





cantidades_total_univ_Total <- rbind(cantidades_total_univ_Argentina, cantidades_total_univ_Brazil, cantidades_total_univ_Chile, cantidades_total_univ_Colombia, cantidades_total_univ_Mexico)
cantidades_nano_univ_Total <- rbind(cantidades_nano_univ_Argentina, cantidades_nano_univ_Brazil, cantidades_nano_univ_Chile, cantidades_nano_univ_Colombia,  cantidades_nano_univ_Mexico)
cantidades_biotech_univ_Total <- rbind(cantidades_biotech_univ_Argentina, cantidades_biotech_univ_Brazil, cantidades_biotech_univ_Chile, cantidades_biotech_univ_Colombia,  cantidades_biotech_univ_Mexico)
cantidades_tic_univ_Total <- rbind(cantidades_tic_univ_Argentina, cantidades_tic_univ_Brazil, cantidades_tic_univ_Chile, cantidades_tic_univ_Colombia,  cantidades_tic_univ_Mexico)



redes_nano_univ_Argentina$inst_name[redes_nano_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
redes_nano_univ_Argentina$inst_name[redes_nano_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
redes_nano_univ_Argentina$inst_name[redes_nano_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
redes_nano_univ_Argentina$country = 'AR'

redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
redes_nano_univ_Brazil$inst_name[redes_nano_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
redes_nano_univ_Brazil$country = 'BR'

redes_nano_univ_Chile$inst_name[redes_nano_univ_Chile$inst_id==1]<- 'Univ de Chile'
redes_nano_univ_Chile$inst_name[redes_nano_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
redes_nano_univ_Chile$inst_name[redes_nano_univ_Chile$inst_id==3]<- 'Univ de Concepción'
redes_nano_univ_Chile$country = 'CL'

redes_nano_univ_Colombia$inst_name[redes_nano_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
redes_nano_univ_Colombia$inst_name[redes_nano_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
redes_nano_univ_Colombia$country = 'CO'

redes_nano_univ_Mexico$inst_name[redes_nano_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
redes_nano_univ_Mexico$inst_name[redes_nano_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
redes_nano_univ_Mexico$country = 'MX'



redes_biotech_univ_Argentina$inst_name[redes_biotech_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
redes_biotech_univ_Argentina$inst_name[redes_biotech_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
redes_biotech_univ_Argentina$inst_name[redes_biotech_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
redes_biotech_univ_Argentina$country = 'AR'

redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
redes_biotech_univ_Brazil$inst_name[redes_biotech_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
redes_biotech_univ_Brazil$country = 'BR'

redes_biotech_univ_Chile$inst_name[redes_biotech_univ_Chile$inst_id==1]<- 'Univ de Chile'
redes_biotech_univ_Chile$inst_name[redes_biotech_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
redes_biotech_univ_Chile$inst_name[redes_biotech_univ_Chile$inst_id==3]<- 'Univ de Concepción'
redes_biotech_univ_Chile$country = 'CL'

redes_biotech_univ_Colombia$inst_name[redes_biotech_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
redes_biotech_univ_Colombia$inst_name[redes_biotech_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
redes_biotech_univ_Colombia$country = 'CO'

redes_biotech_univ_Mexico$inst_name[redes_biotech_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
redes_biotech_univ_Mexico$inst_name[redes_biotech_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
redes_biotech_univ_Mexico$country = 'MX'



redes_tic_univ_Argentina$inst_name[redes_tic_univ_Argentina$inst_id==1000]<- 'Univ Buenos Aires'
redes_tic_univ_Argentina$inst_name[redes_tic_univ_Argentina$inst_id==1003]<- 'Univ Nac de Córdoba'
redes_tic_univ_Argentina$inst_name[redes_tic_univ_Argentina$inst_id==1014]<- 'Univ Nac de La Plata'
redes_tic_univ_Argentina$country = 'AR'

redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==1]<- 'Univ de Sao Paulo'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==2]<- 'Univ Estad de Campinas'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==3]<- 'Univ Fed de Rio de Janeiro'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==7]<- 'Univ Estad Paulista'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==4]<- 'Univ Fed Rio Grande do Sul'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==5]<- 'Univ Fed de Minas Gerais'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==21]<- 'Univ Fed de Paraná'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==13]<- 'Univ Fed de Sao Paulo'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==6]<- 'Univ Fed de Santa Catarina'
redes_tic_univ_Brazil$inst_name[redes_tic_univ_Brazil$inst_id==9]<- 'Univ de Brasilia'
redes_tic_univ_Brazil$country = 'BR'

redes_tic_univ_Chile$inst_name[redes_tic_univ_Chile$inst_id==1]<- 'Univ de Chile'
redes_tic_univ_Chile$inst_name[redes_tic_univ_Chile$inst_id==2]<- 'Pont Univ Católica de Chile'
redes_tic_univ_Chile$inst_name[redes_tic_univ_Chile$inst_id==3]<- 'Univ de Concepción'
redes_tic_univ_Chile$country = 'CL'

redes_tic_univ_Colombia$inst_name[redes_tic_univ_Colombia$inst_id==1]<- 'Univ Nacional de Colombia'
redes_tic_univ_Colombia$inst_name[redes_tic_univ_Colombia$inst_id==2]<- 'Univ de ANtioquia'
redes_tic_univ_Colombia$country = 'CO'

redes_tic_univ_Mexico$inst_name[redes_tic_univ_Mexico$inst_id==1001]<- 'Univ Nac Autónoma de México'
redes_tic_univ_Mexico$inst_name[redes_tic_univ_Mexico$inst_id==1002]<- 'Inst Politéc Nacional'
redes_tic_univ_Mexico$country = 'MX'


redes_nano_univ_Total <-  rbind(redes_nano_univ_Argentina, redes_nano_univ_Brazil, redes_nano_univ_Chile, redes_nano_univ_Colombia, redes_nano_univ_Mexico)
redes_biotech_univ_Total <-  rbind(redes_biotech_univ_Argentina, redes_biotech_univ_Brazil, redes_biotech_univ_Chile, redes_biotech_univ_Colombia, redes_biotech_univ_Mexico)
redes_tic_univ_Total <-  rbind(redes_tic_univ_Argentina, redes_tic_univ_Brazil, redes_tic_univ_Chile, redes_tic_univ_Colombia, redes_tic_univ_Mexico)




####Pega la tabla al sql####
dbWriteTable(scopus_ibero, name='redes_nano_univ_Total', value=redes_nano_univ_Total)
dbWriteTable(scopus_ibero, name='redes_biotech_univ_Total', value=redes_biotech_univ_Total)
dbWriteTable(scopus_ibero, name='redes_tic_univ_Total', value=redes_tic_univ_Total)

#####pega la tabla 2 veces para poder hacer el join posterior
dbWriteTable(scopus_ibero, name='redes_nano_univ_Total2', value=redes_nano_univ_Total)
dbWriteTable(scopus_ibero, name='redes_biotech_univ_Total2', value=redes_biotech_univ_Total)
dbWriteTable(scopus_ibero, name='redes_tic_univ_Total2', value=redes_tic_univ_Total)

#write.csv(redes_nano_univ_Total, 'redes_nano.csv')
#write.csv(redes_biotech_univ_Total, 'redes_biotech.csv')
#write.csv(redes_tic_univ_Total, 'redes_tic.csv')




###############Nano#############################
# Trae la consulta y muestra los datos
aristas <- dbGetQuery(scopus_ibero, "select a.inst_name as Source, b.inst_name as Target, count(distinct a.ut) from redes_nano_univ_Total a, redes_nano_univ_Total b where a.ut=b.ut and a.inst_name <> b.inst_name group by a.inst_name, b.inst_name")
#nodos <- dbGetQuery(scopus_ibero, "select a.inst_name as Source, sum(distinct a.ut) as total from redes_nano_univ_Total a group by a.inst_name")

nodos <- redes_nano_univ_Total %>% 
  group_by(inst_name, inst_name) %>%                            # multiple group columns
  summarise(cantidades = n_distinct(ut))  # multiple summary columns

#Creo el grafo
grafo <- graph.data.frame(aristas, directed=FALSE)
g<- simplify(grafo, remove.multiple = TRUE)

CairoSVG(file="grafo_nano.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
lay.kk <- layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g))
grafo.nano <- plot.igraph(g,layout=lay.kk, 
                        vertex.label.cex=0.60,
                        vertex.label.color="black", 
                        vertex.size=nodos$cantidades*0.01,
                        edge.width=E(g)$weight,
                        vertex.color="orange",
                        vertex.shape="circle")
dev.off()


###############Biotech#############################
# Trae la consulta y muestra los datos
aristas <- dbGetQuery(scopus_ibero, "select a.inst_name as Source, b.inst_name as Target, count(distinct a.ut) from redes_biotech_univ_Total a, redes_biotech_univ_Total b where a.ut=b.ut and a.inst_name <> b.inst_name group by a.inst_name, b.inst_name")
#nodos <- dbGetQuery(scopus_ibero, "select a.inst_name as Source, sum(distinct a.ut) as total from redes_biotech_univ_Total a group by a.inst_name")

nodos <- redes_biotech_univ_Total %>% 
  group_by(inst_name, inst_name) %>%                            # multiple group columns
  summarise(cantidades = n_distinct(ut))  # multiple summary columns

#Creo el grafo
grafo <- graph.data.frame(aristas, directed=FALSE)
g<- simplify(grafo, remove.multiple = TRUE)

CairoSVG(file="grafo_biotech.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
lay.kk <- layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g))
grafo.biotech <- plot.igraph(g,layout=lay.kk, 
                          vertex.label.cex=0.60,
                          vertex.label.color="black", 
                          vertex.size=nodos$cantidades*0.01,
                          edge.width=E(g)$weight,
                          vertex.color="green",
                          vertex.shape="circle")
dev.off()



###############TIC#############################
# Trae la consulta y muestra los datos
aristas <- dbGetQuery(scopus_ibero, "select a.inst_name as Source, b.inst_name as Target, count(distinct a.ut) from redes_tic_univ_Total a, redes_tic_univ_Total b where a.ut=b.ut and a.inst_name <> b.inst_name group by a.inst_name, b.inst_name")
#nodos <- dbGetQuery(scopus_ibero, "select a.inst_name as Source, sum(distinct a.ut) as total from redes_tic_univ_Total a group by a.inst_name")

nodos <- redes_tic_univ_Total %>% 
  group_by(inst_name, inst_name) %>%                            # multiple group columns
  summarise(cantidades = n_distinct(ut))  # multiple summary columns

#Creo el grafo
grafo <- graph.data.frame(aristas, directed=FALSE)
g<- simplify(grafo, remove.multiple = TRUE)

CairoSVG(file="grafo_tic.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
lay.kk <- layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g))
grafo.tic <- plot.igraph(g,layout=lay.kk, 
                             vertex.label.cex=0.60,
                             vertex.label.color="black", 
                             vertex.size=nodos$cantidades*0.01,
                             edge.width=E(g)$weight,
                             vertex.color="lightblue",
                             vertex.shape="circle")
dev.off()




##############analiza grafo###################


#LISTAR#
V(g)
E(g)

#CARACTERISTICAS
is.simple(g)
is.connected(g, mode="weak")
diameter(g)

#Densidad del grafo
graph.density(g)

#Red de mundo pequeño
power.law.fit(degree(g))

#Grados - Tamaño de vertices
grados<-degree(g)

# pesos de las aristas
pesos <- E(g)$weight



assortativity.degree(g)
transitivity(g, type ="local")
transitivity(g, type ="global")

barplot(sort(degree(g), decreasing = T))





walktrap <- walktrap.community(g, steps = 4, weights = E(g)$weight)
modularity(walktrap)

membresias <- data.frame((sort(table(walktrap$membership), decreasing=T)))
View(membresias)

elemento1 <- membresias[1,1]
elemento2 <- membresias[2,1]
elemento3 <- membresias[3,1]
elemento4 <- membresias[4,1]
elemento5 <- membresias[5,1]
elemento6 <- membresias[6,1]
elemento7 <- membresias[7,1]

colores_walktrap <- ifelse(walktrap$membership  == elemento1, "lightblue", "white")
colores_walktrap[walktrap$membership == elemento2] <- "red"
colores_walktrap[walktrap$membership == elemento3] <- "green"
colores_walktrap[walktrap$membership == elemento4] <- "yellow"
colores_walktrap[walktrap$membership == elemento5] <- "brown"
colores_walktrap[walktrap$membership == elemento6] <- "orange"
colores_walktrap[walktrap$membership == elemento7] <- "purple"


#Subgrafo aquí excluyo todos los vertices que tienen solo 1 grado
g2 <- induced_subgraph(g, vids = degree(g)>1)


