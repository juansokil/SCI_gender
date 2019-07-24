library(DBI)
library(RMySQL)
library(Hmisc)

#Connecting to MySQL: Once the RMySQL library is installed create a database connection object.
scopus_ibero = dbConnect(MySQL(), user='scopus', password='sc0pus2698', dbname='scopus_ibero', host='mysql.ricyt.org', port = 3306)
dbListTables(scopus_ibero)


# Trae la consulta y muestra los datos
Clasificadas <- dbGetQuery(scopus_ibero, "select article_med.ut, articleXinstitution.order, articleXinstitution.address, articleXinstitution.inst_id from articleXinstitution, article_med where articleXinstitution.ut=article_med.ut and inst_id<9999")
No_Clasificadas <- dbGetQuery(scopus_ibero, "select article_med.ut, articleXinstitution.order, articleXinstitution.address from articleXinstitution, article_med where articleXinstitution.ut=article_med.ut and inst_id=9999")

dim(Clasificadas)
dim(No_Clasificadas)




#Crea corpus
#Trabaja con TM stopwords, stem, etc
vs <- VectorSource(Clasificadas$address)
corp <- Corpus(vs)
corp <- tm_map(corp, tolower)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, stripWhitespace)


#Transforma a quanteda
corpus <- corpus(corp)
ngramas <- tokens(corpus, remove_punct = TRUE, remove_url = TRUE, remove_symbols = TRUE, ngrams = 2:4, what = "word", verbose = quanteda_options("verbose"))
dfm <- dfm(ngramas)
dfm <- dfm_trim(dfm, min_count = 0.0005)  

###analizo el bag of words
colSums<-colSums(as.matrix(dfm))
boxplot(colSums)
plot(density(colSums))
barplot(table(colSums))

#Convierto a tf-itf
dfm <- dfm_weight(dfm, type = "tfidf") 
head(dfm,30)






##PREPARA TRAIN - TEST
base.train<-Clasificadas[1:round(nrow(Clasificadas)*0.80),]
table(base.train$inst_id)
base.test<-Clasificadas[(round(nrow(Clasificadas)*0.80)+1):nrow(Clasificadas),]
table(base.test$inst_id)

dfm.train<-dfm[1:round(nrow(Clasificadas)*0.80),]
dfm.test<-dfm[(round(nrow(Clasificadas)*0.80)+1):nrow(Clasificadas),]


###MODELADO
nb.classifier<-textmodel_NB(dfm.train,base.train$inst_id, prior = "uniform")
nb.classifier<-textmodel_NB(dfm.train,base.train$inst_id, prior = "docfreq")

pred<-predict(nb.classifier,dfm.test)

#generating a confusion matrix
# use pred$nb.predicted to extract the class labels
View(table(predicted=pred$nb.predicted,actual=base.test$inst_id))

##Accuracy
mean(pred$nb.predicted==base.test$inst_id)*100




















