#limpio la memoria
rm( list=ls() )
gc()

#####LIBRERIAS######
library(Hmisc)
library(dplyr)
library(gender)
library(dplyr)
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

#Grafo
CairoSVG(file="plotsfinal.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
set.seed(1492) 
grafo.kk <- plot.igraph(g, 
                        layout=layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g)), 
                        vertex.size=rescale(degree(g), 1, max(degree(g)), 1, 5), vertex.label.cex=0.20,vertex.label.color="red",vertex.color="lightblue", vertex.shape="circle",
                        edge.width=E(g)$weight*10)
dev.off()


####Agrega el atributo grado###
g <- set_vertex_attr(g, "Grado", value = degree(g))
####Agrega intermediacion####
g <- set_vertex_attr(g, "Intermediacion", value = betweenness(g, directed = FALSE))


#####GUARDA EL GRAFO#####
write_graph(g, 'grafo_gephi', format = "gml")


#####CARACTERISTICAS ADICIONALES DEL GRAFO######
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



####CREA UN NUEVO DATASET####

str(vertex.attributes(g))

###EXTRAE A UN NUEVO DATASET###
id <-  vertex_attr(g, "id")
dato_interm <- as.numeric(vertex_attr(g, "Intermediacion"))
dato_grado <- as.numeric(vertex_attr(g, "Grado"))
dato_gender <- vertex_attr(g, "gender")
dato_country <- vertex_attr(g, "country")
dato_discprincipal <- vertex_attr(g, "discprincipal")
grafo_final <- as.data.frame(cbind(id, dato_gender, dato_country, dato_discprincipal,  dato_grado, dato_interm))

###TRANSFORMA DE FACTOR A NUMERIC###
grafo_final$dato_grado2 <- as.numeric(as.character(grafo_final$dato_grado))
grafo_final$dato_interm2 <- as.numeric(as.character(grafo_final$dato_interm))

###CALCULA TOTALES POR GENERO####
total_grado_gender <- grafo_final %>% group_by(dato_gender) %>% summarize(Mean = mean(dato_grado2, na.rm=TRUE))
total_inter_gender <- grafo_final %>% group_by(dato_gender) %>% summarize(Mean = mean(dato_interm2, na.rm=TRUE))

##SI QUISIERA HACER UN FILTRO POR UNA CATEGORIA##
##disc_grado_eng <- grafo_final %>% filter(dato_discprincipal == "ENG") %>% group_by(dato_gender) %>% summarize(Mean = mean(dato_grado2, na.rm=TRUE))
##disc_inter_eng <- grafo_final %>% filter(dato_discprincipal == "ENG")  %>% group_by(dato_gender) %>% summarize(Mean = mean(dato_interm2, na.rm=TRUE))




#####CARGA EL GRAFO#####
g <- read_graph('./grafo_gephi_completo.gml', format = "gml")

##########################PODA DEL GRAFO######################
####Minimum Spanning Tree###
min_spanning_tree <- mst(g, weights = E(g)$weight)
####Maximum Spanning Tree###
max_spanning_tree <- mst(g, weights = 1/E(g)$weight)


















#####################NUEVA VERSION######################################
grafo1 <- read_delim("C:/Users/Juan/Desktop/grafo.csv", ";", escape_double = FALSE, trim_ws = TRUE)

######################ARMA NODOS############################
nodos <- grafo1 %>% group_by(asjc_code, asjc_desc) %>% summarise(n = n())

######################ARMA ARISTAS##########################
aristas_01 <- unique(grafo1 %>% group_by(asjc_code))
aristas_02 <- aristas_01 %>% group_by(id) %>% summarise(combo_1 = paste(asjc_code, collapse = ","))
aristas_03 <- grafo1 %>% left_join(aristas_02, on='id')
aristas_04 <- aristas_03 %>% mutate(codigos = strsplit(as.character(combo_1), ",")) %>% unnest(codigos)

aristas_previo <- aristas_04[c(2,4)]
colnames(aristas_previo) <- c("source","target")
###ACA ES IMPORTANTE QUE EL SUMMARIZE SE LLAME WEIGHT PARA QUE ME GENERE UN GRAFICO CON PESOS EN LAS ARISTAS
aristas <- aristas_previo %>% group_by(source, target) %>% summarize(weight=n())


grafo <- graph_from_data_frame(aristas, directed=FALSE, vertices=nodos)
is_weighted(grafo)
g<- simplify(grafo, remove.multiple = TRUE)

####VER LOS ATRIBUTOS#####
str(vertex.attributes(g))
str(edge.attributes(g))

####Agrega el atributo grado###
g <- set_vertex_attr(g, "Degree", value = degree(g))
####Agrega intermediacion####
g <- set_vertex_attr(g, "Intermediacion", value = betweenness(g, directed = FALSE))


####Clusterizaciones ####
rw <- cluster_walktrap(g, weights = E(g)$weight, steps = 2,
                 merges = TRUE, modularity = TRUE, membership = TRUE)
fg <- fastgreedy.community(as.undirected(g))


############Grafo###################

layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1] 
# Remove layouts that do not apply to our graph.
layouts <- layouts[!grepl("bipartite|merge|norm|sugiyama|tree", layouts)]
par(mfrow=c(4,4), mar=c(1,1,1,1))
set.seed(1991) 
for (layout in layouts) {
  print(layout)
  l <- do.call(layout, list(g)) 
  plot(min_spanning_tree, edge.arrow.mode=0, layout=l, main=layout, 
       vertex.size=degree(g)*1.2, vertex.label.cex=0.5,vertex.label.color="black",
       vertex.color=fg$membership, vertex.shape="circle",
       edge.width=E(g)$weight/15) }


par(mfrow=c(1,1))
#set.seed(1991) 
#grafo.kk <- plot.igraph(g, 
#                        layout=layout_nicely, 
#                        vertex.size=degree(g), vertex.label.cex=0.5,vertex.label.color="black",vertex.color=fg$membership, vertex.shape="circle",
#                        edge.width=E(g)$weight/1000)







