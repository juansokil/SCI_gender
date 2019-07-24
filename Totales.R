

argentina_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from article a, address b where a.ut=b.ut and country='Argentina' group by year;")
argentina_total <-  fetch(argentina_total, n=-1)
View(argentina_total)

argentina_inst <- dbSendQuery(scopus_ibero, "select inst_id, inst_name, count(distinct ut) as cant from authorXinstitution group by inst_id, inst_name order by cant desc;")
argentina_inst <-  fetch(argentina_inst, n=-1)

View(argentina_inst)



chile_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from article a, address b where a.ut=b.ut and country='Chile' group by year;")
chile_total <-  fetch(chile_total, n=-1)
View(chile_total)

colombia_total <- dbSendQuery(scopus_ibero, "select year, count(distinct a.ut) from article a, address b where a.ut=b.ut and country='Colombia' group by year;")
colombia_total <-  fetch(colombia_total, n=-1)
View(colombia_total)



