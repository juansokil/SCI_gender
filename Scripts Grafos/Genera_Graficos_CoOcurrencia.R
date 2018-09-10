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

#####CARGA EL GRAFO#####
g <- read_graph('./grafo_gephi_completo.gml', format = "gml")



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


