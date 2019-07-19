library(DBI)
library(RMySQL)

scopus_ibero = dbConnect(MySQL(), user='scopus', password='r1cyt2698', dbname='scopus_ibero', host='mysql2.ricyt.org')


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

ggraph(wordnetwork, layout  = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "purple", alpha=0.5) +
  geom_node_text(aes(label = name), col = "black", size = 5) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Co-ocurrencias en la misma oración", subtitle = "Sustantivos y Adjetivos")
