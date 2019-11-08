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
indicators = c("GASIDSFPER","GASIDSEPER","GASTOxPBI")

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


iso='MX'

idpbi <- datos %>%
  filter(iso == 'MX' & indicator_name =='GASTOxPBI' & year %in% c(2005:2017)) %>% glimpse() %>% 
  ggplot(aes(year, valor)) +
  geom_bar(stat='identity') +
  scale_y_continuous(labels = scales::percent, limits = c(0,0.01)) +
  scale_x_discrete(limits = c(2005:2017)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "bottom",
        panel.background =  element_blank()
        )  + 
  labs(title = "Gasto en Investigación y Desarrollo", 
       subtitle = "en millones de dolares PPP",
    caption="Esto es una prueba para ver que pasa cuando escribis mucho, bdsfsdfsdfsdfsdfsdfdsfla, \n ara ver que pasa \n cuando escribis mucho",
    x="",y="")

  sf <- datos %>%
  filter(iso == 'MX' & indicator_name =='GASIDSFPER' & year %in% c(2005:2017)) %>% glimpse() %>% 
  ggplot(aes(year, valor, group=fila, color=fila, fill=fila)) +
    geom_bar(stat='identity',position='fill') +
    scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
    scale_x_discrete(limits = c(2005:2017)) + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.position = "bottom")  
  
  se <- datos %>%
    filter(iso == 'MX' & indicator_name =='GASIDSEPER' & year %in% c(2005:2017)) %>% glimpse() %>% 
    ggplot(aes(year, valor, group=fila, color=fila, fill=fila)) +
    geom_bar(stat='identity',position='fill') +
    scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
    scale_x_discrete(limits = c(2005:2017)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.position = "bottom")   +
    ylab("Y LABEL") + xlab("X LABEL") + ggtitle("TITLE OF THE FIGURE")
  

  se_ultimo <- 
  datos %>%  filter(iso == 'MX' & indicator_name =='GASIDSEPER' & year == 2018) %>%  unique() %>% glimpse() %>% 
    ggplot(aes(fila, valor, group=factor(fila), fill=fila)) +
    geom_bar(stat='identity') +
    coord_polar()  +
    theme(legend.position = "none") +
    scale_fill_manual(values=c('yellow','red','black','orange'))
  
  
  sf_ultimo <- 
    datos %>%  filter(iso == 'MX' & indicator_name =='GASIDSFPER' & year == 2018) %>%  unique() %>% glimpse() %>% 
    ggplot(aes(fila, valor, group=factor(fila), color=fila, fill=fila)) +
    geom_bar(stat='identity') +
    coord_polar()  +
  theme(legend.position = "none",
        panel.background =  element_blank(),
        axis.title.x=element_text(size=rel(0.5), hjust = .5)
  )  
  

  
  waffle <- waffle(
    c('Yes=70%' = 73, 'No=27%' = 27), rows = 3, colors = c("#FD6F6F", "#93FB98"), legend_pos="bottom")
  
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
  
  
  
  
  
  
  # Generate Infographic in PDF format
  
  pdf("./Infographics7.pdf", width = 8, height = 11)
  grid.newpage() 
  pushViewport(viewport(layout = grid.layout(nrow=11, ncol=8)))
  grid.rect(gp = gpar(fill = "#E2E2E3", col = "#E2E2E3"))
  grid.text("Rep. Dominicana",  y = unit(1, "npc"), x = unit(0.5, "npc"), vjust = 1.1, hjust = 0.5, gp = gpar(col = "#A9A8A7", cex = 6, alpha = 0.3, vp=vplayout(1,1:8)))
  grid.text("Recursos Financieros en I+D", y = unit(0.94, "npc"), check.overlap = TRUE, hjust = 0.1 , gp = gpar(col = "#E7A922", alpha = 0.8, cex = 2, vp=vplayout(1,1:8)))
  print(idpbi, vp = vplayout(2:4, 1:8))
  print(sf_ultimo, vp = vplayout(5:7, 1:4))
  print(se_ultimo, vp = vplayout(5:7, 5:8))
  print(map, vp = vplayout(8:10, 1:8))
  print(waffle, vp = vplayout(10:11, 1:8))
  #print(map, vp = vplayout(3, 1:3))
  #print(p2, vp = vplayout(2, 1:3))
  dev.off()
  
  
  
  #grid.text("RProgramming", y = unit(0.94, "npc"), gp = gpar(fontfamily = "Impact", col = "#E7A922", cex = 6.4))
  #grid.text("BY AL-AHMADGAID B. ASAAD", vjust = 0, y = unit(0.92, "npc"), gp = gpar(fontfamily = "Impact", col = "#552683", cex = 0.8))
  #grid.text("ANALYSIS WITH PROGRAMMING", vjust = 0, y = unit(0.913, "npc"), gp = gpar(fontfamily = "Impact", col = "#552683", cex = 0.8))
  #grid.text("alstatr.blogspot.com", vjust = 0, y = unit(0.906, "npc"), gp = gpar(fontfamily = "Impact", col = "#552683", cex = 0.8))
  

  
  
  
