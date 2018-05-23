

library(DBI)
library(RMySQL)
library(Hmisc)
library(igraph)


source('./00-sql.r', encoding = 'latin1')

###chequear conexion###
scopus_ibero


# Trae la consulta y muestra los datos
aristas <- dbGetQuery(scopus_ibero, "select Source, Target, Cant from pais_pais where Cant > 50 and Source='Argentina'")
nodos <- dbGetQuery(scopus_ibero, "select Source, sum(Cant) as total from pais_pais group by Source")




#Creo el grafo
grafo <- graph.data.frame(aristas, directed=FALSE)
g<- simplify(grafo, remove.multiple = TRUE)
plot(g)

#Defino distintos layouts

#lay.fr <- layout_with_fr(g, niter = 1000, weights = pesos)

#Grafo
CairoSVG(file="plotsfinal.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
set.seed(1492) 
grafo.kk <- plot.igraph(g, vertex.size=rescale(degree(g), 1, max(degree(g)), 1, 20),
                        vertex.label.cex=0.20,
                        #vertex.label=lista$surname,
                        vertex.label.color="black", 
                        edge.width=E(g)$weight*0.30,
                        vertex.color="lightblue",
                        vertex.shape="circle")


lay.kk <- layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g), weights = pesos)



set_vertex_attr(g, "cantidades", index = V(g), nodos$cant)

vertex_attr(g)




library(scales)

grafo.kk <- plot.igraph(g,layout=lay.kk, 
                        vertex.label.cex=0.60,
                        vertex.label.color="black", 
                        vertex.size=nodos$cant*0.005,
                        edge.width=E(g)$weight,
                        vertex.color="lightblue",
                        vertex.shape="circle")




#LISTAR#
V(g)
E(g)

#CARACTERISTICAS
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



#E(g)$arrow.size <- .2
E(g)$edge.color <- "gray80"

#Funcion de reescalar
rescale = function(x,a,b,c,d){c + (x-a)/(b-a)*(d-c)}

#Grafo inicial
install.packages("Cairo")

library(Cairo)


#Defino distintos layouts
lay.kk <- layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g), weights = pesos)
#lay.fr <- layout_with_fr(g, niter = 1000, weights = pesos)

#Grafo
CairoSVG(file="plotsfinal.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
setwd("C:/Users/observatorio/Desktop/gephi2")
set.seed(1492) 
grafo.kk <- plot.igraph(g, layout=lay.kk, vertex.size=rescale(degree(g), 1, max(degree(g)), 1, 20),
                     vertex.label.cex=0.20,
                     vertex.label=lista$surname,
                     vertex.label.color="black", 
                     edge.width=E(g)$weight*0.30,
                     vertex.color="lightblue",
                     vertex.shape="circle")
dev.off()




walktrap <- walktrap.community(g, steps = 4, weights = E(g)$weight)
modularity(walktrap)

membresias <- data.frame((sort(table(walktrap$membership), decreasing=T)))
View(membresias)

elemento1 <- membresias[1,1]
elemento2 <- membresias[2,1]
elemento3 <- membresias[3,1]
elemento4 <- membresias[4,1]
elemento5 <- membresias[5,1]
elemento6 <- membresias[6,1]
elemento7 <- membresias[7,1]

colores_walktrap <- ifelse(walktrap$membership  == elemento1, "lightblue", "white")
colores_walktrap[walktrap$membership == elemento2] <- "red"
colores_walktrap[walktrap$membership == elemento3] <- "green"
colores_walktrap[walktrap$membership == elemento4] <- "yellow"
colores_walktrap[walktrap$membership == elemento5] <- "brown"
colores_walktrap[walktrap$membership == elemento6] <- "orange"
colores_walktrap[walktrap$membership == elemento7] <- "purple"



#Grafo
CairoSVG(file="comunidades.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
setwd("C:/Users/observatorio/Desktop/gephi2")
grafo.kk <- plot.igraph(g, layout=lay.kk, vertex.size=rescale(degree(g), 1, max(degree(g)), 1, 30),
                        vertex.label.cex=0.20,
                        vertex.label=lista$surname,
                        vertex.label.color="black", 
                        edge.width=E(g)$weight*0.30,
                        vertex.color = colores_walktrap,
                        vertex.shape="circle")
dev.off()




#Subgrafo aquí excluyo todos los vertices que tienen solo 1 grado
g2 <- induced_subgraph(g, vids = degree(g)>1)











