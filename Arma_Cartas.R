#install.packages("pdftools")
#install.packages("readxl")
#install.packages("here")

library(here)
library(pdftools)
library(readxl)

getwd()


contactos <- read_excel(here("contactos_cartas.xlsx"))
          

for(i in  1:24) {
  print(i)
  print(contactos$Nombre[i])
  pdf_subset('cartas.pdf',pages = i, output = here(paste(contactos$Pais[i],"-",contactos$Nombre[i],".pdf")))
}




