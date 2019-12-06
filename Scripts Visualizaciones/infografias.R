


library(grid)
library(ggplot2)
library(waffle)
library(useful)
library(extrafont)
library(igraph)
library(dplyr)
library(tibble)
library(httr)
library(jsonlite)
library(rlist)
library(RJSONIO)
library(ggflags)
library(scales)
library(tidyr)
library(bibliometrix)
#install.packages("treemapify")
library(treemapify)
#biblioshiny()#install.packages("rsdmx")
library(rsdmx)
library(tidyverse)

#https://apiportal.uis.unesco.org/query-builder#data

UNESCOurl <- "https://api.uis.unesco.org/sdmx/data/UNESCO,RD,1.0/GERD.GDP..........?startPeriod=2012&endPeriod=2017&format=sdmx-compact-2.1&locale=es&subscription-key=35140ee6652b4f6985d7225173fbef63"
indicador <- readSDMX(UNESCOurl)

indicador_df <- as.data.frame(indicador)

indicador_df <- indicador_df %>%
  select(TIME_PERIOD, REF_AREA, OBS_VALUE) %>% 
  arrange(desc(TIME_PERIOD)) %>% 
  group_by(REF_AREA) %>% top_n(1)
  

indicador_df$OBS_VALUE <- as.double(as.character(indicador_df$OBS_VALUE))
indicador_df$TIME_PERIOD <- as.double(as.character(indicador_df$TIME_PERIOD))

indicador_df <- indicador_df %>%
rename(year = TIME_PERIOD, iso=REF_AREA, valor=OBS_VALUE)





####DEFINE EL TEMA###
#LEVANTA PAISES y ASIGNA COLORES
listado <- RJSONIO::fromJSON("http://db.ricyt.org/api/comparative/AR,BO,BR,CL,CO,CR,CU,EC,SV,ES,GT,HN,JM,MX,NI,PA,PY,PE,PT,PR,DO,TT,UY,VE,AL/2017/POBLA")
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
indicators = c("GASIDSFPER","GASIDSEPER","GASTOxPBI","GAS_IMD_PPC","PBIPPC")

datos = data.frame()
datos_indicador = data.frame()
for (indicator in indicators) {
  ##Crea un data.frame vacio##
  indicator_name=indicator
  print(indicator_name)
  indicador <- RJSONIO::fromJSON(paste("http://db.ricyt.org/api/comparative/AR,BO,BR,CO,CR,CU,CL,EC,SV,GT,HN,JM,MX,NI,PA,PY,PE,PT,TT,UY,VE,AL/1990/",indicator_name,sep=""))
  
  
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
    head(datos_indicador)
    
    ###CIERRA FOR###
    ###Append de los datos de cada indicador###  
    
  }
  
  datos <- rbind(datos, datos_indicador)
  ###CIERRA FOR###
}    


colnames(datos)<- c("year","iso","valor","nombre","fila","country","indicator_name")

datos$valor <- as.numeric(as.character(datos$valor))
datos$year <- as.numeric(as.character(datos$year))


pais='AR'



######GRAFICO01######
idppc <- 
  datos %>%
  filter(iso == pais & indicator_name =='GAS_IMD_PPC' & year %in% c(2005:2017)) %>% glimpse() %>% 
  ggplot(aes(year, valor)) +
  geom_bar(stat='identity') +
  #geom_smooth(method = 'loess', se=TRUE) +
  #scale_y_continuous(limits = c(0,20000)) +
  scale_x_discrete(limits = c(2005:2017)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "bottom",
        panel.background =  element_blank(),
        plot.title = element_text(vjust = -1, hjust = 0.5, size=12),
        plot.subtitle = element_text(vjust = -2, hjust = 0.5, size=10),
  )  + 
  labs(title = "Gasto en Investigación y Desarrollo", 
       subtitle = "millones de dolares PPP",
       x="",y="")


######GRAFICO02######
idpbi <- 
  datos %>%
  filter(iso == pais & indicator_name =='GASTOxPBI' & year %in% c(2005:2017)) %>% glimpse() %>% 
  ggplot(aes(year, valor)) +
  geom_line(size=2, alpha=0.7) +
  geom_point(size=3) +
  scale_y_continuous(labels = scales::percent, limits = c(0,0.01)) +
  scale_x_discrete(limits = c(2005:2017)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "bottom",
        panel.background =  element_blank(),
        plot.title = element_text(vjust = -1, hjust = 0.5, size=12),
        plot.subtitle = element_text(vjust = -2, hjust = 0.5, size=10),
  )  + 
  labs(title = "Gasto en I+D con relación al PIB", 
       x="",y="")



################GRAFICO03##############

map.world <- map_data("world")

### CODIGOS ISO####
countrycode <-  as.data.frame(countrycode::codelist) %>% 
  as_tibble() %>% 
  select(pais = country.name.en, code = ecb )  %>% 
  filter(!is.na(code)) %>% 
  print(n = Inf)

###Levanto datos I+D####
id_mundial <- datos %>%
  filter(indicator_name =='GASTOxPBI' & year == 2017) %>% unique() %>%
  select(year, iso, valor)


id_mundial2 <- bind_rows(id_mundial,indicador_df)

paises <- id_mundial2 %>%
  arrange(desc(valor)) %>%
  top_n(10) %>%
  ggplot(aes(x=iso, y=valor)) +
  geom_bar(stat='identity') +
  coord_flip()

map.world.joined <- map.world %>% 
  left_join(countrycode, by =c("region"="pais")) 

map.world.joined2 <- map.world.joined %>% 
  left_join(id_mundial2, by =c("code"="iso"))




imdmundial <- ggplot() +
  geom_polygon(data = map.world.joined2, aes(x = long, y = lat, group = group, fill=valor*100)) +
  theme(axis.text = element_blank(), 
        axis.ticks = element_blank(), axis.title = element_blank(),
        legend.position = "none", panel.grid = element_blank(),
        panel.background = element_blank(), 
        plot.title = element_text(vjust = -1, hjust = 0.5, size=14),
        plot.subtitle = element_text(vjust = -2, hjust = 0.5, size=10)) +
  labs(title = "Gasto en I+D por paìs", x="",y="") +
scale_fill_continuous(low="lightgreen",  high="darkgreen", 
                       guide="colorbar",na.value="white")

######GRAFICO04######
sf_ultimo <- 
  datos %>%  filter(iso == pais & indicator_name =='GASIDSFPER' & year == 2017) %>%  unique() %>% glimpse() %>% 
  ggplot(aes(area=valor, fill=fila, label=paste(fila, "\n", valor*100,"%"))) +
  geom_treemap() +
  geom_treemap_text(fontface = "italic", colour = "black", place = "centre",
                    reflow = TRUE) +
  theme(legend.position = "none", panel.background =  element_blank(),
        plot.title = element_text(vjust = -1, hjust = 0.5, size=14),
        plot.subtitle = element_text(vjust = -2, hjust = 0.5, size=10)) +
  scale_fill_manual(values=c('forestgreen','cornflowerblue','lightsalmon','moccasin','tan3')) +
  labs(title = "Distribución por sector de Financiamiento", x="",y="")



######GRAFICO05######
se_ultimo <- 
  datos %>%  filter(iso == pais & indicator_name =='GASIDSEPER' & year == 2017) %>%  unique() %>% glimpse() %>% 
  ggplot(aes(area=valor, fill=fila, label=paste(fila, "\n", valor*100,"%"))) +
  geom_treemap() +
  geom_treemap_text(fontface = "italic", colour = "black", place = "centre",
                    reflow=TRUE) +
  theme(legend.position = "none", panel.background =  element_blank(),
        plot.title = element_text(vjust = -1, hjust = 0.5, size=14),
        plot.subtitle = element_text(vjust = -2, hjust = 0.5, size=10)) +
  scale_fill_manual(values=c('forestgreen','cornflowerblue','lightsalmon','moccasin')) +
  labs(title = "Distribución por sector de Ejecución", x="",y="")







#############GRAFO DE COLABORACION##################

#Cityname <- c('Buenos Aires','Brasilia','Madrid')
CountryCode <- c('AR','BR','ES','US')
lat <- c(-34.6075616,-15.7934036,40.4167047,42.71)
lon <- c(-58.437076,-47.8823172,-3.7035825,-75.11)
nodes <- data.frame(CountryCode, lat, lon)

source <- c('AR','AR','BR','AR')
target <- c('BR','ES','ES','US')
frecuency <- c(7,15,20,32)
edges <- data.frame(source, target, frecuency)

g <- graph_from_data_frame(edges, directed = FALSE, vertices = nodes)

edges_for_plot <- edges %>%
  inner_join(nodes %>% select(CountryCode, lon, lat), by = c('source' = 'CountryCode')) %>%
  rename(x = lon, y = lat) %>%
  inner_join(nodes %>% select(CountryCode, lon, lat), by = c('target' = 'CountryCode')) %>%
  rename(xend = lon, yend = lat)


maptheme <- theme(panel.grid = element_blank()) +
  theme(axis.text = element_blank()) +
  theme(axis.ticks = element_blank()) +
  theme(axis.title = element_blank()) +
  theme(legend.position = "bottom") +
  theme(panel.grid = element_blank()) +
  theme(panel.background = element_rect(fill = "#596673")) +
  theme(plot.margin = unit(c(0, 0, 0.5, 0), 'cm'))


country_shapes <- geom_polygon(aes(x = long, y = lat, group = group),
                               data = map_data('world'),
                               fill = "#CECECE", color = "#515151",
                               size = 0.15)


map <- ggplot(nodes) + country_shapes +
  geom_curve(aes(x = x, y = y, xend = xend, yend = yend),
             data = edges_for_plot, curvature = 0.33,
             alpha = 0.5) +
  geom_point(aes(x = lon, y = lat),           # draw nodes
             shape = 21, fill = 'white',
             color = 'black', stroke = 0.5, size=4) +
  scale_size_continuous(guide = FALSE, range = c(1, 6)) +    # scale for node size
  geom_text(aes(x = lon, y = lat, label = CountryCode),             # draw text labels
            hjust = 0, nudge_x = 1, nudge_y = 4,
            size = 6, color = "red", fontface = "bold")



###########WAFFLE######
waffle <- waffle(
  c('Yes=70%' = 73, 'No=27%' = 27), rows = 3, colors = c("#FD6F6F", "#93FB98"), legend_pos="bottom")




# Generate Infographic in PDF format



pdf("./Infographics_Arg.pdf", width = 8, height = 11)
###Pagina01###
grid.newpage() 
pushViewport(viewport(layout = grid.layout(nrow=11, ncol=8)))
grid.rect(gp = gpar(fill = "#E2E2E3", col = "#E2E2E3"))
grid.text("Argentina",  y = unit(1, "npc"), x = unit(0.5, "npc"), vjust = 1.1, hjust = 0.5, gp = gpar(col = "#A9A8A7", cex = 6, alpha = 0.3, vp=vplayout(1,1:8)))
grid.text("Recursos Financieros en I+D", y = unit(0.94, "npc"), check.overlap = TRUE, hjust = 0.1 , gp = gpar(col = "#E7A922", alpha = 0.8, cex = 2, vp=vplayout(1,1:8)))
print(idppc, vp = vplayout(2:4, 1:4))
print(idpbi, vp = vplayout(2:4, 5:8))
print(imdmundial, vp = vplayout(5:8, 1:5))
print(paises, vp = vplayout(5:8, 6:8))
print(sf_ultimo, vp = vplayout(9:11, 1:3))
print(se_ultimo, vp = vplayout(9:11, 6:8))

###Pagina02###
grid.newpage() 
pushViewport(viewport(layout = grid.layout(nrow=11, ncol=8)))
grid.rect(gp = gpar(fill = "#E2E2E3", col = "#E2E2E3"))
grid.text("Argentina",  y = unit(1, "npc"), x = unit(0.5, "npc"), vjust = 1.1, hjust = 0.5, gp = gpar(col = "#A9A8A7", cex = 6, alpha = 0.3, vp=vplayout(1,1:8)))
grid.text("Otros indicadores", y = unit(0.94, "npc"), check.overlap = TRUE, hjust = 0.1 , gp = gpar(col = "#E7A922", alpha = 0.8, cex = 2, vp=vplayout(1,1:8)))
print(idppc, vp = vplayout(2:4, 1:4))
print(idpbi, vp = vplayout(2:4, 5:8))
print(map, vp = vplayout(5:9, 1:8))
print(waffle, vp = vplayout(10:11, 1:8))
dev.off()


  
