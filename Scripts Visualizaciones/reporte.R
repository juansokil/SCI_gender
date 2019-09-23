
######BIBLIOTECAS#############
library(httr)
library(jsonlite)
library(rlist)
library(RJSONIO)
library(tibble)
library(dplyr)
library(stringr)
library(ggplot2)

##################################################################


#LEVANTA PAISES y ASIGNA COLORES
listado <- RJSONIO::fromJSON("http://app.ricyt.org/api/comparative/AR,BO,BR,CL,CO,CR,CU,EC,SV,ES,GT,HN,JM,MX,NI,PA,PY,PE,PT,PR,DO,TT,UY,VE,AL/2017/POBLA")

pais <- c()
i=1
for (i in 1:25){
  pais[i] <- listado$metadata$countries[[i]]$name_es
}
pais <- as.data.frame(pais)



prefijo <- c()
i=1
for (i in 1:25){
  prefijo[i] <- listado$metadata$countries[[i]]$country_id
}
prefijo <- as.data.frame(prefijo)
listado <- cbind(pais,prefijo)





##################################################################

###Listado de indicadores###
indicators = c(
  "GAS_IMD_PPC","GASIDSFPER","GASIDSEPER","CIDTC","GASIDTIPER","GASIDDISCPER","GASIDOSPER","CREDITOSTOTAL",
               "CPERSOPF","INVESTPFSEPER","INVESTPFDISCPER")

datos = data.frame()

for (indicator in indicators) {
  ##Crea un data.frame vacio##
  datos_indicador = data.frame()

  ##Crea un data.frame vacio##    
  indicator_name=indicator
  print(indicator_name)
  indicador <- RJSONIO::fromJSON(paste("http://dev.ricyt.org/api/comparative/AR,BO,BR,CO,CR,CU,CL,EC,SV,GT,HN,JM,MX,NI,PA,PY,PE,PT,TT,UY,VE,AL/1990/",indicator_name,sep=""))
  
  ###Comienza el for###
  for (i in 1:(length(indicador$metadata$countries))){
    if (ncol(cbind(indicador$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador$indicators[[1]]$countries[[i]]$name_es))==3) 
    {
      pais <- cbind(
        indicador$metadata$countries[[i]]$country_id,
        indicador$indicators[[1]]$countries[[i]]$rows[[1]]$values,
                    indicador$indicators[[1]]$name_es[[1]],
          indicador$indicators[[1]]$countries[[i]]$rows[[1]]$name_es,
          indicador$indicators[[1]]$countries[[i]]$name_es,
          indicator_name)
      pais <-  rownames_to_column(as.data.frame(pais) , var = "rowname")

  ###Append de los datos de cada pais###  
    datos_indicador <- rbind(datos_indicador, pais)}
  }
  
  ###Append de los datos de cada indicador###  
  datos <- rbind(datos, datos_indicador)
  }
  

colnames(datos)<- c("year","iso","valor","nombre","fila","country","indicator_name")


glimpse(datos)
View(datos)

ee <- datos %>%
  group_by (year, nombre)  %>%
  arrange ( nombre) %>%
  filter (year >=2005 & year <= 2017)  %>%
  summarize(respuestas=n())


ggplot(ee, aes(year, respuestas)) + 
  #  geom_point(shape=12, size=5, fill='red')  + 
  geom_bar(stat='identity')  + 
  facet_wrap(~nombre)


