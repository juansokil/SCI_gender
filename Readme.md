Detalle de distintos Códigos implementados


########################### 

*SCRIPTS GENERO*

A partir de un csv descargado de Web Of Science (SCI) y alojado en MYSQL extrae el nombre de los distintos autores (nombre completo, iniciales y le asigna genero a partir de la libreria "gender" de R. Sobre esos datos calcula una serie de indicadores de genero.

1- Cantidad de publicaciones con al menos un autor identificado

2- Cantidad de publicaciones en que participan Hombres / Mujeres

3- Cantidad de autores por genero sobre el total de publicaciones
<p> <img src="https://github.com/juansokil/Scripts_RICYT/blob/master/Scripts%20Genero/00-result_genero_sci.png" width="300"> </p>



########################### 

*SCRIPTS GRAFOS*

A partir de una tabla de 2 columnas: autor y nombre de publicacion (en este caso id y ut respectivamente). Construye las tablas de nodos y aristas con su peso.  
A partir de ambos dataframe construye un grafo de co-ocurrencias de autores en igraph(R), calcula metricas y posteriormente lo exporta a formato svg y gml.




