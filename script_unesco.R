
library(readr)
library(dplyr)
library(data.table)


#######Levanta los archivos####
EDUN_DATA_NATIONAL <- read_csv("C:/Users/jsokil/Desktop/Archivos Educ/EDUN_DATA_NATIONAL.csv")

EDUN_LABEL <- read_csv("C:/Users/jsokil/Desktop/Archivos Educ/EDUN_LABEL.csv")
EDUN_LABEL$INDICATOR_ID <- as.factor(EDUN_LABEL$INDICATOR_ID)


####Junta ambas tablas####
lista_indicadores <- EDUN_DATA_NATIONAL %>%
  left_join(EDUN_LABEL, by = c("INDICATOR_ID"="INDICATOR_ID"))

#lista_indicadores2 <- data.frame(lista_indicadores$INDICATOR_ID, lista_indicadores$INDICATOR_LABEL_EN)
#lista_indicadores2 <- unique(lista_indicadores2)
#write.csv(lista_indicadores2, 'lista_indicadores.csv')


base_unesco <- lista_indicadores %>%
  filter (INDICATOR_ID %in% c('25051', '25052', '25053', '25055', 
  '25056', '25057', '25075', '25078', 
  '42600', '42601', '42603', '42605', '42606', '42608', '42610', '42612', '42613',
  '42613', '42614', '42615', '42617', '42619', '42620', '42621', '42622', '42624',
  '42626', '42627', '42628', '42630', '42632', '42633', '42633', '42635', '42637', 
  '42640', '42641', '42643', '42645', '42646', '42647', '42649', '42651', '42652', 
  '42654', '42654', '42656', 'E.6t8', 'E.6t8.M', '26375', '26415', '43490', 
  '43549', '26335', '43487', '43608', '43489', '43610', '26295',
  '26255', '43547', '43484', '43485', '26215', '25003', '43615', '25007', '43623', 
  '43617', '43614', '25024', '25001', '43620', '43618', '43624', '43621',
  'ASTAFF.6t8.F', '43613', '25027', '25005', 'ASTAFF.6t8.M', '43619', '43625', 
  '20082', '20052', '40028', '40012', '20053', '20022', '20023', '20083', 
  'OE.5t8.40500', 'OE.5t8.40540', 'OE.5t8.40521', 'OE.5t8.40517', 'OE.5t8.40530', 
  'OE.5t8.40510', 'OE.5t8.40520', 'OE.5t8.40515', 'OE.5t8.40505', 'OE.5t8.40522', 
  '26420', 'E.5T8.foreign.Org99000000', 'E.5T8.foreign.Org40505', '26519', '26505', 
  'E.5T8.foreign.Org40525', 'E.5T8.foreign.Org40530', '26637', '26648', 'E.5T8.foreign.Org40500', 
  '26631', '43188', '26616', 'E.5T8.foreign.Org40520', '26475', '26650', '26571', 
  'E.5T8.foreign.Org40540', 'E.5T8.foreign.Org40515', '26638')) %>%
  filter (COUNTRY_ID %in% c('ARG','BOL','BRA','CHL','PRY','URY','PER','ECU','COL','VEN',
                            'PAN','CRI','NIC','HND','SLV','GTM','MEX','CUB','PRI','DOM','ESP','PRT')) %>%
  filter (YEAR %in% c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019))


getwd()
fwrite (base_unesco, './basedatos_unesco.csv', sep = ";", dec = ",")


 


