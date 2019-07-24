library(DBI)
library(RMySQL)
library(dplyr)
library(ggplot2)
library(Cairo)
library(igraph)
library(scales)

source('C:/Users/observatorio/Documents/SCI_genero/00-sql.r', encoding = 'latin1')




###chequear conexion###
scopus_ibero

query01 <- dbSendQuery(scopus_ibero, "select abstract from article limit 5000;")
query01 <-  fetch(query01, n=-1)


query01 <- query01 %>% 
  filter ( abstract != '[No abstract available]')

dim(query01)


############LEMMATIZACION######
x <- udpipe_annotate(udmodel_english, x = query01$abstract, trace = TRUE)
x <- as.data.frame(x)

####ARMAR GRAFOS#####
cooc <- cooccurrence(x = subset(x, upos %in% c("NOUN", "ADJ")), 
                     term = "lemma", 
                     group = c("doc_id", "paragraph_id", "sentence_id"))


wordnetwork <- head(cooc, 50)
wordnetwork <- graph_from_data_frame(wordnetwork)
g<- simplify(wordnetwork, remove.multiple = TRUE)

ggraph(g, layout  = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "purple", alpha=0.5) +
  geom_node_text(aes(label = name), col = "black", size = 5) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Co-ocurrencias en la misma oración", subtitle = "Sustantivos y Adjetivos")


CairoSVG(file="plotsfinal.svg", width=11, height=8.5, family="Helvetica", pointsize=11)
set.seed(1492)
                        grafo.kk <- plot.igraph(g, layout=layout.kamada.kawai(g, maxiter = 50 * vcount(g), kkconst = vcount(g)), 
                        vertex.size=rescale(degree(g), 1, max(degree(g)), 1, 5), vertex.label.cex=0.20,vertex.label.color="red",vertex.color="lightblue", vertex.shape="circle",
                        edge.width=E(g)$weight*10)
dev.off()

