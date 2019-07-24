install.packages("readstata13")

library(foreign)


library(haven)
pubusemicrofile <- read_dta("C:/Users/observatorio/Desktop/pubusemicrofile.dta")
View(pubusemicrofile)


View(table(pubusemicrofile$Q3_cob, pubusemicrofile$gender))

dim(pubusemicrofile)