#limpio la memoria
rm( list=ls() )
gc()

#####LIBRERIAS######
library(DBI)
library(RMySQL)
library(Hmisc)
library(dplyr)
library(gender)
library(dplyr)
library(plotly)
library(igraph)
library(dplyr)
library(tidyr)
library(scales)
library(Cairo)
library(readr)






############CONSULTA PARA VER LAS CANTIDADES POR PAIS POR AÑO#################
###Levanta datos###

autorXut_reduce <- read_csv("./base/base.csv")


#######################ANALISIS EXPLORATORIO###############
###Cantidad de autores###
length(unique(autorXut_reduce$id))
####Cantidad de ut###
length(unique(autorXut_reduce$ut))




######################ARMA NODOS############################
nodos <- autorXut_reduce %>% group_by(id) %>% summarise(n = n())





#######################ARMA VERTICES #######################
byHand <- group_by(autorXut_reduce, ut) %>% summarise(combo_1 = paste(id, collapse = ","))

#### identifico el primero de los autores###
byHand$primer_autor = as.character(lapply(strsplit(as.character(byHand$combo_1), split=","), "[", 1))

#### acumulo el primero con el resto####
arreglado <- byHand %>% mutate(autores = strsplit(as.character(combo_1), ",")) %>% unnest(autores)

####Cantidad de ut CONTROL###
length(unique(arreglado$ut))

aristas_previo <- arreglado[c(3:4)]
colnames(aristas_previo) <- c("source","target")
aristas <- aristas_previo %>% group_by(source, target) %>% summarize(count=n())

grafo <- graph_from_data_frame(aristas, directed=FALSE, vertices=nodos)
g<- simplify(grafo, remove.multiple = TRUE)
#plot(g, e=TRUE, v=TRUE)



#Defino distintos layouts
lay.kk <- layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g))
#Grafo


CairoSVG(file="plotsfinal.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
set.seed(1492) 
grafo.kk <- plot.igraph(g, 
                        layout=lay.kk, 
                        vertex.size=rescale(degree(g), 1, max(degree(g)), 1, 5),
                        vertex.label.cex=0.20,
                        vertex.label.color="red", 
                        edge.width=E(g)$weight*10,
                        vertex.color="lightblue",
                        vertex.shape="circle")
dev.off()




write_graph(g, 'grafo_gephi', format = "gml")
