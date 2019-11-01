

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

#install.packages("ggthemes")
library(ggthemes)

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
indicators = c("GASIDSFPER")

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

MX <-  datos %>% filter(iso == 'MX' & indicator_name =='GASIDSFPER' & year %in% c(2005:2017))
View(MX)

  datos %>%
  filter(iso == 'MX' & indicator_name =='GASIDSFPER' & year %in% c(2005:2017)) %>% glimpse() %>% 
  ggplot(aes(year, valor, group=fila, color=fila, fill=fila)) +
    geom_bar() +
    #geom_bar(stat='identity') +
    scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
    scale_x_discrete(limits = c(2005:2017)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
  





install.packages('maps')
install.packages('geosphere')






#install.packages(c("waffle", "extrafont"))
install.packages("useful")

library(grid)
library(ggplot2)
library(waffle)
library(useful)
library(extrafont)
library(igraph)
library(dplyr)


loadfonts(device = "win")
extrafont::font_import (path="C:/fonts/", prompt = FALSE)
fonts()[grep("Awesome", fonts())]
## [1] "FontAwesome"



install.packages("RJSONIO")
library(RJSONIO)

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



#assert_that(nrow(edges_for_plot) == nrow(edges))



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
             alpha = 0.5, size=4) +
  scale_size_continuous(guide = FALSE, range = c(0.25, 2)) + # scale for edge widths
  geom_point(aes(x = lon, y = lat),           # draw nodes
             shape = 21, fill = 'white',
             color = 'black', stroke = 0.5, size=4) +
  scale_size_continuous(guide = FALSE, range = c(1, 6)) +    # scale for node size
  geom_text(aes(x = lon, y = lat, label = CountryCode),             # draw text labels
            hjust = 0, nudge_x = 1, nudge_y = 4,
            size = 6, color = "red", fontface = "bold")
map

y1 <- round(rnorm(n = 36, mean = 7, sd = 2)) # Simulate data from normal distribution
y2 <- round(rnorm(n = 36, mean = 21, sd = 6))
y3 <- round(rnorm(n = 36, mean = 50, sd = 8))
x <- rep(LETTERS[1:12], 3)
grp <- rep(c("Grp 1", "Grp 2", "Grp 3"), each = 12)
dat <- data.frame(grp, x, y1, y2, y3)



kobe_theme <- function() {
  theme(
    plot.background = element_rect(fill = "#E2E2E3", colour = "#E2E2E3"),
    panel.background = element_rect(fill = "#E2E2E3"),
    panel.background = element_rect(fill = "white"),
    axis.text = element_text(colour = "#E7A922", family = "Impact"),
    plot.title = element_text(colour = "#552683", face = "bold", size = 18, vjust = 1, family = "Impact"),
    axis.title = element_text(colour = "#552683", face = "bold", size = 13, family = "Impact"),
    panel.grid.major.x = element_line(colour = "#E7A922"),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.text = element_text(family = "Impact", colour = "white"),
    strip.background = element_rect(fill = "#E7A922"),
    axis.ticks = element_line(colour = "#E7A922")
  )
}


kobe_theme2 <- function() {
  theme(
    legend.position = "bottom", legend.title = element_text(family = "Impact", colour = "#552683", size = 10),
    legend.background = element_rect(fill = "#E2E2E3"),
    legend.key = element_rect(fill = "#E2E2E3", colour = "#E2E2E3"),
    legend.text = element_text(family = "Impact", colour = "#E7A922", size = 10),
    plot.background = element_rect(fill = "#E2E2E3", colour = "#E2E2E3"),
    panel.background = element_rect(fill = "#E2E2E3"),
    panel.background = element_rect(fill = "white"),
    axis.text = element_text(colour = "#E7A922", family = "Impact"),
    plot.title = element_text(colour = "#552683", face = "bold", size = 18, vjust = 1, family = "Impact"),
    axis.title = element_text(colour = "#552683", face = "bold", size = 13, family = "Impact"),
    panel.grid.major.y = element_line(colour = "#E7A922"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    strip.text = element_text(family = "Impact", colour = "white"),
    strip.background = element_rect(fill = "#E7A922"),
    axis.ticks = element_line(colour = "#E7A922")
  )
}


x_id <- rep(12:1, 3) # use this index for reordering the x ticks


p1 <- ggplot(data = dat, aes(x = x, y = y1)) + geom_bar(stat = "identity", fill = "#552683") +
  coord_flip() + ylab("Y LABEL") + xlab("X LABEL") + facet_grid(. ~ grp) +
  ggtitle("TITLE OF THE FIGURE")

p2 <- waffle(
  c('Yes=70%' = 73, 'No=27%' = 27), rows = 5, colors = c("#FD6F6F", "#93FB98"),
  title = 'Responses', legend_pos="bottom")
p2

p3 <- ggplot(data = dat, aes(x = reorder(x, rep(1:12, 3)), y = y3, group = factor(grp))) +
  geom_bar(stat = "identity", fill = "#552683") + coord_polar() + facet_grid(. ~ grp) +
  ylab("Y LABEL") + xlab("X LABEL") + ggtitle("TITLE OF THE FIGURE")



# Generate Infographic in PDF format

pdf("Infographics1.pdf", width = 10, height = 20)
grid.newpage() 
pushViewport(viewport(layout = grid.layout(4, 3)))
grid.rect(gp = gpar(fill = "#E2E2E3", col = "#E2E2E3"))
#grid.text("INFOGRAPHIC", y = unit(1, "npc"), x = unit(0.5, "npc"), vjust = 1, hjust = .5, gp = gpar(fontfamily = "Impact", col = "#A9A8A7", cex = 12, alpha = 0.3))
#grid.text("RProgramming", y = unit(0.94, "npc"), gp = gpar(fontfamily = "Impact", col = "#E7A922", cex = 6.4))
#grid.text("BY AL-AHMADGAID B. ASAAD", vjust = 0, y = unit(0.92, "npc"), gp = gpar(fontfamily = "Impact", col = "#552683", cex = 0.8))
#grid.text("ANALYSIS WITH PROGRAMMING", vjust = 0, y = unit(0.913, "npc"), gp = gpar(fontfamily = "Impact", col = "#552683", cex = 0.8))
#grid.text("alstatr.blogspot.com", vjust = 0, y = unit(0.906, "npc"), gp = gpar(fontfamily = "Impact", col = "#552683", cex = 0.8))
#print(p3, vp = vplayout(4, 1:3))
print(p3, vp = vplayout(4, 1:3))
print(p2, vp = vplayout(2, 1:3))
print(map, vp = vplayout(3, 1:3))
#print(p2, vp = vplayout(2, 1:3))
dev.off()


