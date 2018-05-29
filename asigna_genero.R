##install.packages("gender")
library(gender)

gender(names, years = c(1932, 2012), method = c("ssa", "ipums", "napp",
                                                "kantrowitz", "genderize", "demo"), countries = c("United States", "Canada",
                                                                                                  "United Kingdom", "Denmark", "Iceland", "Norway", "Sweden"))


Prob <- gender(c("Pablo","Martin",
                 "Andrea",
                 "Andreas",
         "Madison", 
         "Juana",
         "Juan",
         "Rene",
         "Jose",
         "Maria",
         "Walter"), years = c(2000, 2010))

View(Prob)