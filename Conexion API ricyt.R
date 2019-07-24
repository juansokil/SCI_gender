
library(httr)
library(jsonlite)
library(rlist)
library(data.table)
#install.packages("RJSONIO")
library(RJSONIO)
library(tibble)

#LEVANTA PAISES
#listado <- RJSONIO::fromJSON("http://dev.ricyt.org/api/comparative/AR,BB,BO,BR,CL,CO,CR,CU,EC,SV,ES,GT,GY,HT,HN,JM,MX,NI,PA,PY,PE,PT,PR,DO,TT,UY,VE/2015/POBLA")
#pais <- c()
#i=1
#for (i in 1:27){
  #pais[i] <- listado$metadata$countries[[i]]$name_es
  #}
#pais <- as.data.frame(pais)

###ARMA LA SERIE
#base=2012
#final=2014
#serie <- c()
#i=1
#for (i in 1:(final-base+1))
#  serie[i] <- i+base
#serie <- as.data.frame(serie)

pais01 <- data.frame(year = c(1990:2015), "country" = as.character(c("Argentina")))
pais02 <- data.frame(year = c(1990:2015), "country"= as.character(c("Bolivia")))
pais03 <- data.frame(year = c(1990:2015), "country" = as.character(c("Brasil")))
pais04 <- data.frame(year = c(1990:2015), "country"= as.character(c("Chile")))
pais05 <- data.frame(year = c(1990:2015), "country"= as.character(c("Colombia")))
pais06 <- data.frame(year = c(1990:2015), "country"= as.character(c("Costa Rica")))
pais07 <- data.frame(year = c(1990:2015), "country"= as.character(c("Cuba")))
pais08 <- data.frame(year = c(1990:2015), "country"= as.character(c("Ecuador")))
pais09 <- data.frame(year = c(1990:2015), "country"= as.character(c("El Salvador")))
pais10 <- data.frame(year = c(1990:2015), "country"= as.character(c("España")))
pais11 <- data.frame(year = c(1990:2015), "country"= as.character(c("Guatemala")))
pais12 <- data.frame(year = c(1990:2015), "country"= as.character(c("Honduras")))
pais13 <- data.frame(year = c(1990:2015), "country"= as.character(c("Jamaica")))
pais14 <- data.frame(year = c(1990:2015), "country"= as.character(c("México")))
pais15 <- data.frame(year = c(1990:2015), "country"= as.character(c("Nicaragua")))
pais16 <- data.frame(year = c(1990:2015), "country"= as.character(c("Panamá")))
pais17 <- data.frame(year = c(1990:2015), "country"= as.character(c("Paraguay")))
pais18 <- data.frame(year = c(1990:2015), "country"= as.character(c("Perú")))
pais19 <- data.frame(year = c(1990:2015), "country"= as.character(c("Portugal")))
pais20 <- data.frame(year = c(1990:2015), "country"= as.character(c("Puerto Rico")))
pais21 <- data.frame(year = c(1990:2015), "country"= as.character(c("Dominicana")))
pais22 <- data.frame(year = c(1990:2015), "country"= as.character(c("Trinidad y Tobago")))
pais23 <- data.frame(year = c(1990:2015), "country"= as.character(c("Uruguay")))
pais24 <- data.frame(year = c(1990:2015), "country"= as.character(c("Venezuela")))

estructura <- rbind(pais01, pais02, pais03, pais04, pais05, pais06, pais07, pais08, pais09, pais10, 
                    pais11, pais12, pais13, pais14, pais15, pais16, pais17, pais18, pais19, pais20, 
                    pais21, pais22, pais23, pais24)


indicador01_name="Gasto PBI"
indicador01 <- RJSONIO::fromJSON("http://dev.ricyt.org/api/comparative/AR,UY,CL,CO,BR,ES,PT,PY,GT,EC,MX,BO/2000/GASTOxPBI")
indicador02_name="Investigadores PF"
indicador02 <- RJSONIO::fromJSON("http://dev.ricyt.org/api/comparative/AR,UY,CL,CO,BR,ES,PT,PY,GT,EC,MX,BO,SV/2000/CINVPEA")
indicador02_name="Cantidad de Estudiantes"
indicador02 <- RJSONIO::fromJSON("http://dev.ricyt.org/api/comparative/AR,UY,CL,CO,BR,ES,PT,PY,GT,EC,MX,BO,VE,SV/2000/ES_ESTUDTOTAL")
indicador03_name="Gasto_PPC"
indicador03 <- RJSONIO::fromJSON("http://dev.ricyt.org/api/comparative/AR,UY,CL,CO,BR,ES,PT,PY,GT,EC,MX,BO,VE,SV/2000/GAS_IMD_PPC")





#####INDICADOR 01######################
indicador01_completo = data.frame()
#Levanta paises y datos
for (i in 1:(length(indicador01$metadata$countries))){
  assign(paste('pais',i, sep = ""), as.data.frame(cbind(indicador01$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador01$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador01$indicators[[1]]$countries[[i]]$name_es)))
  indicador01_completo <- rbind(indicador01_completo,assign(paste('pais',i, sep = ""), as.data.frame(cbind(indicador01$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador01$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador01$indicators[[1]]$countries[[i]]$name_es))))
}

indicador01_completo <-  rownames_to_column(as.data.frame(indicador01_completo) , var = "rowname")
indicador01_completo$rowname <- substr(indicador01_completo$rowname, 1, 4)

indicador01_completo$rowname <- as.numeric(as.character(indicador01_completo$rowname))
#indicador01_completo$V1 <- as.numeric(as.character(indicador01_completo$V1))
colnames(indicador01_completo)<- c("year",indicador01_name,"medida","country")

View(indicador01_completo)


#####INDICADOR 02######################
indicador02_completo = data.frame()
#Levanta paises y datos
for (i in 1:(length(indicador02$metadata$countries))){
  assign(paste('pais',i, sep = ""), as.data.frame(cbind(indicador02$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador02$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador02$indicators[[1]]$countries[[i]]$name_es)))
  indicador02_completo <- rbind(indicador02_completo,assign(paste('pais',i, sep = ""), as.data.frame(cbind(indicador02$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador02$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador02$indicators[[1]]$countries[[i]]$name_es))))
}

indicador02_completo <-  rownames_to_column(as.data.frame(indicador02_completo) , var = "rowname")
indicador02_completo$rowname <- substr(indicador02_completo$rowname, 1, 4)


indicador02_completo$rowname <- as.numeric(as.character(indicador02_completo$rowname))
#indicador02_completo$V1 <- as.numeric(as.character(indicador02_completo$V2))
colnames(indicador02_completo)<- c("year",indicador02_name,"medida","country")

View(indicador02_completo)


#####INDICADOR 03######################
indicador03_completo = data.frame()
#Levanta paises y datos
for (i in 1:(length(indicador03$metadata$countries))){
  assign(paste('pais',i, sep = ""), as.data.frame(cbind(indicador03$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador03$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador03$indicators[[1]]$countries[[i]]$name_es)))
  indicador03_completo <- rbind(indicador03_completo,assign(paste('pais',i, sep = ""), as.data.frame(cbind(indicador03$indicators[[1]]$countries[[i]]$rows[[1]]$values, indicador03$indicators[[1]]$countries[[i]]$rows[[1]]$name_es, indicador03$indicators[[1]]$countries[[i]]$name_es))))
}

indicador03_completo <-  rownames_to_column(as.data.frame(indicador03_completo) , var = "rowname")
indicador03_completo$rowname <- substr(indicador03_completo$rowname, 1, 4)

indicador03_completo$rowname <- as.numeric(as.character(indicador03_completo$rowname))
#indicador03_completo$V1 <- as.numeric(as.character(indicador03_completo$V2))
colnames(indicador03_completo)<- c("year",indicador03_name,"medida","country")

View(indicador03_completo)




###############JUNTA DATOS######################

library(dplyr)
df1 <- left_join(estructura, indicador01_completo, by = c("year", "country"))
df2 <- left_join(df1, indicador02_completo, by = c("year", "country"))
df3 <- left_join(df2, indicador03_completo, by = c("year", "country"))

#Filtro las columnas
df3 <- df3[,c(1,2,3,5,7)] 
#Dejo solo los que tienen datos completos
df3 <- df3[rowSums(!is.na(df3)) == length(df3),]

View(df3)

######GRAFICOS#############


#Grafico Bivariado
library(plotly)

## Axes
format_percent <- list(zeroline = TRUE, showline = FALSE, mirror = "ticks", zerolinecolor = toRGB("black"), zerolinewidth = 4,  ticklen = 5, range = c(0, 0.015), tickformat = ".2%")
format_year <- list(zeroline = TRUE, showline = FALSE, mirror = "ticks", zerolinecolor = toRGB("black"), zerolinewidth = 4,  ticklen = 5, range = c(2010, 2015))
format_quantity <- list(zeroline = TRUE, showline = FALSE, mirror = "ticks", zerolinecolor = toRGB("black"), zerolinewidth = 4,  ticklen = 5)




p1 <- plot_ly(data = df3, x = ~year, y = ~`Cantidad de Estudiantes`,  color = ~country, type = 'scatter', mode = 'lines', marker = list(size = 8)) %>%
  layout(title = "Cantidad de Estudiantes",
         xaxis = format_year,
         yaxis = format_quantity)


p1





library(shiny)
###SHINY


## Axes
ax <- list(zeroline = TRUE, showline = FALSE, mirror = "ticks", zerolinecolor = toRGB("black"), zerolinewidth = 4,  ticklen = 5, range = c(0, 0.015), tickformat = ".2%")
ay <- list(zeroline = TRUE, showline = FALSE, mirror = "ticks", zerolinecolor = toRGB("black"), zerolinewidth = 4,  ticklen = 5, range = c(0, 10))




ui <- fluidPage(
  titlePanel("Grafico de 3 variables"),
  #plotlyOutput("plot"),
  plotOutput("plot"),
  verbatimTextOutput("event"),
  fluidRow(column(4, offset = 4, sliderInput("year", "year", min = 2010, max = max(df3$year), value = 2000, animate = TRUE),
                  tableOutput("values")               
  ))
)



shinyServer <- function(input, output, session) {
  yearData <- reactive({
      a <- subset(df3, year == input$year)
      return(a)
      })
  #output$plot <- renderPlotly({
  #  plot_ly(yearData(), x = ~`Gasto PBI`, y = ~`Investigadores PF`,  color=~country, type = 'scatter', size=~(Gasto_PPC), sizes = c(10, 100))%>%
  #    layout(xaxis = ax, yaxis = ay, legend = list(orientation = 'h'))
  #})
  
  output$plot <- renderPlot({
  ggplot(yearData(), aes(x = `Gasto PBI`, y = `Investigadores PF`)) +
    geom_point(aes(size = Gasto_PPC, colour = country, alpha=.02)) + 
    scale_size(range = c(1,15)) 
  })
  
  
}







shinyApp(ui, shinyServer)

##https://plot.ly/r/bubble-charts/






