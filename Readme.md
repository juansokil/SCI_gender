Detalle de distintos Códigos implementados


########################### 

*SCRIPTS GENERO*

A partir de un csv descargado de Web Of Science (SCI) y alojado en MYSQL extrae el nombre de los distintos autores (nombre completo, iniciales y le asigna genero a partir de la libreria "gender" de R. Sobre esos datos calcula una serie de indicadores de genero.

1- Cantidad de publicaciones con al menos un autor identificado

2- Cantidad de publicaciones en que participan Hombres / Mujeres

3- Cantidad de autores por genero sobre el total de publicaciones

########################### 

*SCRIPTS GRAFOS*

A partir de una tabla de 2 columnas: autor y nombre de publicacion (en este caso id y ut respectivamente). Construye el input necesario (tablas de nodos y aristas) para construir un grafo de co-ocurrencias de autores en igraph(R). Finalmente lo exporta a formato svg y gephi
