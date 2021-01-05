################LIBRERIAS########################
library(readr)
library(dplyr)
library(countrycode)
library(MazamaSpatialUtils)
library(highcharter)
library(tidyverse)



########################################################
########################################################
###################PARAMETROS###########################
########################################################
########################################################
########################################################



año_minimo = 2009
año_maximo = 2018


########################################################
########################################################
########################################################
##################BASE RICYT############################
########################################################
########################################################
########################################################



#LEVANTA PAISES y ASIGNA COLORES
listado <- RJSONIO::fromJSON("http://app.ricyt.org/api/comparative/AR,BO,BR,CL,CO,CR,CU,EC,SV,ES,GT,HN,JM,MX,NI,PA,PY,PE,PT,PR,DO,TT,UY,VE,AL/2010/POBLA")
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


#############Esto se hae una vez sola ###########

###Listado de indicadores#################
indicators = c("GAS_IMD_PPC","GASTOxPBI","GASIDSFPER","GASIDSEPER",
               "CPERSOPF","CPERSOEJC","CINVPEA", "INVESTPFSEPER", 
               "PERSOPFGEN","PERSOEJCGEN","PERSOPFGENPER","PERSOEJCGENPER","CINVBPFF",
               "ES_ESTUDTOTAL","PCTESTUDXCINE","ES_GRADUADOS","PCTEGRADXCINE",
               "CSCOPUS","SCOPUSxH","PATPCT","CPATSOL")





datos = data.frame()
datos_indicador = data.frame()
for (indicator in indicators) {
  ##Crea un data.frame vacio##
  indicator_name=indicator
  print(indicator_name)
  indicador <- RJSONIO::fromJSON(paste("http://app.ricyt.org/api/comparative/AR,BO,BR,CO,CR,CU,CL,EC,SV,GT,HN,JM,MX,NI,PA,PY,PE,PT,TT,UY,VE,AL,ES,PT,IB/1990/",indicator_name,sep=""))
  
  
  ###Comienza el for###
  for (i in 1:(length(indicador$metadata$countries))){
    for (j in 1:(length(indicador$indicators[[1]]$countries[[i]]$rows)))
    {
      ###Normal IF, si las 3 columnas tienen valores las appendea###  
      if (ncol(cbind(indicador$indicators[[1]]$countries[[i]]$rows[[j]]$values, indicador$indicators[[1]]$countries[[i]]$rows[[j]]$name_es, indicador$indicators[[1]]$countries[[i]]$name_es))==3) 
      {
        pais <- cbind(
          indicador$metadata$countries[[i]]$country_id,
          indicador$indicators[[1]]$countries[[i]]$rows[[j]]$values,
          indicador$indicators[[1]]$name_es[[1]],
          indicador$indicators[[1]]$countries[[i]]$rows[[j]]$name_es,
          indicador$indicators[[1]]$countries[[i]]$name_es,
          indicator_name)
        pais <-  rownames_to_column(as.data.frame(pais) , var = "rowname")
        
        ###Append de los datos de cada pais###  
        datos_indicador <- rbind(datos_indicador, pais)
      }#CIERRA EL IF#
    }#CIERRA EL FOR DE LAS FILAS###
    
    ###CIERRA FOR###
    ###Append de los datos de cada indicador###  
  }
  
  datos <- rbind(datos, datos_indicador)
  ###CIERRA FOR###
}    


colnames(datos)<- c("year","iso","valor","nombre","fila","country","indicator_name")

datos$year <- as.numeric(datos$year)
datos$valor <- as.numeric(datos$valor)


datos <- datos %>%
  filter(year >=paste0(a?o_minimo) & year <=paste0(a?o_maximo))


datos <- datos %>% 
  mutate(
    valor = case_when(indicator_name %in% c('GASTOxPBI') ~ valor*100 , TRUE ~ valor)
  )


ultimo_anio_datos <- datos %>% 
  group_by(iso, indicator_name) %>% 
  mutate(year=max(year)) %>% 
  select(iso,indicator_name, year) %>% 
  unique()  %>%
  mutate(ultimo_anio=1)   



datos <- datos %>% left_join(ultimo_anio_datos, by=c('iso'='iso',"indicator_name"="indicator_name","year"="year")) %>% unique()


###Control####
datos %>% filter(iso=='MX' & indicator_name =='GASTOxPBI')





datos_normales <- datos %>% filter(!indicator_name %in% c('GAS_IMD_PPC','GASTOxPBI','CPERSOPF','CPERSOEJC','CINVPEA','PERSOPFGEN','PERSOEJCGEN','PERSOPFGENPER','ES_ESTUDTOTAL','ES_GRADUADOS','CSCOPUS','SCOPUSxH','SCOPUSPBI','PATPCT','CPATSOL')) %>% unique() %>% arrange(indicator_name, year, iso)  
datos_completados1 <- datos %>% filter(indicator_name %in% c('GAS_IMD_PPC')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados2 <- datos %>% filter(indicator_name %in% c('GASTOxPBI')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados3 <- datos %>% filter(indicator_name %in% c('CPERSOPF') & fila=='Investigadores') %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados4 <- datos %>% filter(indicator_name %in% c('CPERSOEJC') & fila=='Investigadores') %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados5 <- datos %>% filter(indicator_name %in% c('CINVPEA')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados6 <- datos %>% filter(indicator_name %in% c('PERSOPFGEN') & fila=='Investigadores Femeninos') %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
###AHORA AL ACTUALIZAR QUEDA ESTE QUE ES EL CORRECTO
datos_completados7 <- datos %>% filter(indicator_name %in% c('PERSOEJCGEN') & fila=='Investigadores Femeninos') %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados8 <- datos %>% filter(indicator_name %in% c('PERSOPFGENPER') & fila=='Investigadoras') %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)

datos_completados9 <- datos %>% filter(indicator_name %in% c('ES_ESTUDTOTAL')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados10 <- datos %>% filter(indicator_name %in% c('ES_GRADUADOS')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)


datos_completados11 <- datos %>% filter(indicator_name %in% c('CSCOPUS')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados12 <- datos %>% filter(indicator_name %in% c('SCOPUSxH')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)


datos_completados13 <- datos %>% filter(indicator_name %in% c('PATPCT')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)
datos_completados14 <- datos %>% filter(indicator_name %in% c('CPATSOL')) %>% unique() %>%  complete(year, nesting(iso,  indicator_name, fila), fill = list(count_number = 0)) %>% arrange(iso, year,  indicator_name)



datos <- rbind(datos_normales, datos_completados1, datos_completados2, datos_completados3, datos_completados4, datos_completados5, datos_completados6, datos_completados7, datos_completados8, datos_completados9, datos_completados10, datos_completados11, datos_completados12, datos_completados13, datos_completados14)  %>% unique()




###Le pega los paises a los que cree a mano###
datos <- datos %>% mutate(country = case_when(iso =='AR' ~ 'Argentina' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='BO' ~ 'Bolivia' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='BR' ~ 'Brasil' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='CL' ~ 'Chile' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='CO' ~ 'Colombia' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='PY' ~ 'Paraguay' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='PT' ~ 'Portugal' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='HN' ~ 'Honduras' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='PE' ~ 'Perú' , TRUE ~ country))
datos <- datos %>% mutate(country = case_when(iso =='MX' ~ 'México' , TRUE ~ country))


datos <- datos %>% mutate(iso = case_when(country =='América Latina y el Caribe' ~ '' , TRUE ~ iso))
datos <- datos %>% mutate(iso = case_when(country =='Iberoamérica' ~ '' , TRUE ~ iso))
datos <- datos %>% mutate(iso = case_when(country =='América Latina' ~ '' , TRUE ~ iso))




########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
##################BASE UNESCO###########################
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################

#De momento dieron de baja la api asi que solamente se puede usar el csv completo que ponen en su pagina#
#Cuando vuelvan a hacer la api habria que modificar esto para levartar los datos directo#

SCI_DATA_NATIONAL <- read_csv("C:/Users/Juan/Desktop/RICYT/unesco/SCI/SCI_DATA_NATIONAL.csv")

####Estas son las variables que utilizamos####
#ExpGDP.Tot Gasto % del PIB
#FRESP_TFTE	Researchers (FTE) - % Female
#RESDEN_LF_TFTE	Researchers per thousand labour force (FTE)
#FRESP_THC	Researchers (HC) - % Female
#RESDEN_LF_THC	Researchers per thousand labour force (HC)

data_unesco <- SCI_DATA_NATIONAL %>%
  filter(INDICATOR_ID %in% c('ExpGDP.Tot','FResP.TFTE', 'ResDen.Lf.TFTE', 'FResP.THC', 'ResDen.Lf.THC'))  %>%
  unique()    %>%
  select(-c(MAGNITUDE, QUALIFIER)) %>%
  rename('indicator_name'='INDICATOR_ID', 'valor'='VALUE', 'year'='YEAR')


data_unesco$indicator_name <- str_replace(data_unesco$indicator_name, "ExpGDP.Tot", "GASTOxPBI")
data_unesco$indicator_name <- str_replace(data_unesco$indicator_name, "ResDen.Lf.THC", "CINVPEA")
data_unesco$indicator_name <- str_replace(data_unesco$indicator_name, "ResDen.Lf.TFTE", "CINVPEA_EJC")
data_unesco$indicator_name <- str_replace(data_unesco$indicator_name, "FResP.THC", "PERSOPFGENPER")
data_unesco$indicator_name <- str_replace(data_unesco$indicator_name, "FResP.TFTE", "PERSOEJCGENPER")
data_unesco$nombre <- ''
data_unesco$fila <- ''
data_unesco$country <- ''
data_unesco$'iso' <- iso3ToIso2(data_unesco$COUNTRY_ID)


unesco_completa <- data_unesco %>% select(year, iso, valor, nombre, fila,country,indicator_name) %>%
  filter (!iso %in% c('AR','BO','BR','CO','CR','CU','CL','EC','SV','GT','HN','JM','MX','NI','PA','PY','PE','PT','TT','UY','VE','AL','ES','PT'))


ultimo_anio_unesco <- unesco_completa %>% 
  group_by(iso, indicator_name) %>% 
  mutate(year=max(year)) %>% 
  select(iso,indicator_name, year) %>% 
  unique()  %>%
  mutate(ultimo_anio=1)   


unesco_completa <- unesco_completa %>% left_join(ultimo_anio_unesco, by =c('iso'='iso','indicator_name'='indicator_name','year'='year')) %>%
  filter(ultimo_anio==1) %>%
  select(year, iso, valor, nombre, fila,country,indicator_name, ultimo_anio)


unesco_completa <- unesco_completa %>% 
  mutate(
    valor = case_when(indicator_name %in% c('PERSOPFGENPER','PERSOEJCGENPER') ~ valor/100 , TRUE ~ valor),
    fila = case_when(indicator_name %in% c('PERSOPFGENPER','PERSOEJCGENPER','PERSOPFGENPER') ~ 'Investigadoras' , TRUE ~ fila)
  )

unesco_completa$valor <- round(unesco_completa$valor,2)






###############JUNTA AMBAS BASES Y GUARDA EL TXT######################



base_total <- rbind(datos,unesco_completa)
base_total <- base_total %>%
  filter(year >=paste0(a?o_minimo) & year <=paste0(a?o_maximo))



#ultimo_anio <- base_total %>% 
#  group_by(iso, indicator_name) %>% 
#  mutate(year=max(year)) %>% 
#  select(iso,indicator_name, year) %>% 
#  unique()  %>%
#  mutate(ultimo_anio=1)
  

#base_total <- base_total %>% left_join(ultimo_anio, by=c('iso'='iso',"indicator_name"="indicator_name","year"="year")) %>% unique()



base_total$country <- str_replace(base_total$country, "?", "a")
base_total$country <- str_replace(base_total$country, "?", "e")
base_total$country <- str_replace(base_total$country, "?", "i")
base_total$country <- str_replace(base_total$country, "?", "o")
base_total$country <- str_replace(base_total$country, "?", "u")
base_total$country <- str_replace(base_total$country, "?", "n")

base_total$fila <- str_replace(base_total$fila, "?", "a")
base_total$fila <- str_replace(base_total$fila, "?", "e")
base_total$fila <- str_replace(base_total$fila, "?", "i")
base_total$fila <- str_replace(base_total$fila, "?", "o")
base_total$fila <- str_replace(base_total$fila, "?", "u")
base_total$fila <- str_replace(base_total$fila, "?", "n")


base_total %>% filter(iso=='PY' & indicator_name =='CPATSOL')
base_total %>% filter(iso=='PY' & indicator_name =='PERSOPFGENPER')



####Save full database####
write.table(base_total, file = "C:/Users/Juan/Desktop/RICYT/base_indicadores.csv", sep = "\t", qmethod = "double", na = "")
####Load full database####
#base_total <- read.table("C:/Users/Juan/Desktop/RICYT/base_indicadores.csv", header = TRUE, sep = "\t", row.names = 1)



