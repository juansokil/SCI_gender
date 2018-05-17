# -*- coding: utf-8 -*-
"""
Created on Fri Apr 20 21:04:28 2018
@author: Juan
"""

import csv
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

#VERSION 2
path = ('C:/Users/observatorio/Desktop/python/base') 
#path = ('C:/Users/observatorio/Desktop/python/base') 
files = os.listdir(path)
files
os.getcwd()

#df = pd.read_csv('C:/Users/observatorio/Desktop/python/base/savedrecs.txt', sep='\t', encoding ="latin1", lineterminator='\r', header=0, index_col=False)
#columnas = df.columns.tolist() 

df = pd.DataFrame()
for f in files:
    print(f)
    csv = pd.read_csv(f, sep='\t', encoding ="latin1", lineterminator='\n', header=0, index_col=False)
    print(csv)
    df = df.append(csv)





 #Quita duplicados
#df = df.drop_duplicates(subset=None, keep='first', inplace=False)
#df = df.dropna(subset=columnas, how='all')

#df.columns
df.shape



base_genero =  df[['C1','FU','UT','SO','DA\r']]
#base_genero =  df[['C1','FU']]

base_genero= base_genero.set_index('UT')
cantidad = base_genero.shape[0]



import re
#s = "Arge[Campi Gaona],[Miche)lle [Madrignac, Bonzi] Michelle [Cuac]Geraldine De Madrignac Bonzi, Barbara Raquel; Ines Flecha Rivas, Alma Maria]Univ "
##Encuentra todo lo que esta entre corchetes
###\[ \] ### esto indica que busque algo que arranque con corchete y termine con corchete
#re.findall(r"\[([A-Z a-z 0-9 _ ,;.]+)\]", s)
###\[ \) ### al cambiarle el corchete por parentesis me encuentra otra cosa
#re.findall(r"\[([A-Z a-z 0-9_]+)\)", s)



###AUTORES y UNIVERSIDADES
aut_univ1 = []
aut_univ2 = []
aut_univ3 = []
for i in range(cantidad):
    aut_univ1.append(re.findall(r"\[([A-Z a-z 0-9 _ ,;.]+)\]", base_genero['C1'][i]))
    aut_univ2.append(re.findall(r"\]([A-Z a-z 0-9 _ ]+)\,", base_genero['C1'][i]))
    #aut_univ3.append(re.search(r'\b [Aa]rgent[*] \b', base_genero['C1'][i]))
    aut_univ3.append(re.search(r'\bBrasil.*?\b', base_genero['C1'][i]))




#re.search(r'\bNot Ok\b',strs)


#####autores####
df1 = pd.DataFrame(aut_univ1)
df1 = df1.stack()
df1 = df1.to_frame()
df1.reset_index(level=[1], inplace=True)
df1.reset_index(level=[0], inplace=True)


df2 = pd.DataFrame(aut_univ2)
df2 = df2.stack()
df2 = df2.to_frame()
df2.reset_index(level=[1], inplace=True)
df2.reset_index(level=[0], inplace=True)


df1 = df1.rename(index=str, columns={"level_1": "NroInst", 0: "Autor", "index": "nrow"})
df2 = df2.rename(index=str, columns={"level_1": "NroInst", 0: "Institucion", "index": "nrow"})

ejercicio= pd.merge(df1, df2, on=['nrow', 'NroInst'], how='left')
ejercicio= ejercicio.set_index(['nrow', 'NroInst'])

ejercicio2 = ejercicio['Autor'].str.split(';', expand=True).stack()

ejercicio2 = ejercicio2.to_frame()
ejercicio2.reset_index(level=[2], inplace=True)
ejercicio2.reset_index(level=[1], inplace=True)
ejercicio2.reset_index(level=[0], inplace=True)
ejercicio2 = ejercicio2.rename(index=str, columns={"level_2": "Nro_autor",0: "Nombre_autor"})

##RECUPERA LOS INDICES###
ejercicio.reset_index(level=[1], inplace=True)
ejercicio.reset_index(level=[0], inplace=True)

AuthorXInstitution= pd.merge(ejercicio2, ejercicio, on=['nrow', 'NroInst'], how='left')


AuthorXInstitution['Nombre_autor']=AuthorXInstitution.Nombre_autor.str.strip()
































autores['Pais'] = autores.Pais.str.lstrip()

##flatten the list
#flattened_list = []
#for x in aut_univ1:
#    for y in x:
#        flattened_list.append(y)
 
###Grafico para ver los tipos 
#Tipo = pd.value_counts(base_genero.Tipo).to_frame().reset_index()
#ax = Tipo[['Tipo']].plot(kind='bar', legend = False)
  
####referencias####
ref = base_genero['Referencias'].str.split(';', expand=True).stack()
referencias = ref.to_frame()
referencias.reset_index(level=[1], inplace=True)
referencias.reset_index(level=[0], inplace=True)
referencias = referencias.rename(index=id, columns={"level_1": "NroReferencia", 0: "Referencia"})
referencias = referencias.set_index('id')
 


#####autores####
autor = base_genero['C1'].str.split(';', expand=True).stack()
autores = autor.to_frame()
autores.reset_index(level=[1], inplace=True)
autores.reset_index(level=[0], inplace=True)
autores = autores.rename(index=str, columns={"level_1": "NroAutor", 0: "Nombre"})
#autores = autores.set_index('id')
#Extrae todo despues de la ultima coma
autores['Pais'] = autores.Nombre.str.split(',').str[-1]
#Quito los espacios en blanco
autores['Pais'] = autores.Pais.str.strip()
 








### si quisiera sacar las cosas de un lado o del otro
autores['Pais'] = autores.Pais.str.lstrip()
autores['Apellido'] = autores.Nombre.str.lstrip('prueba: ')
autores['Apellido2'] = autores.Nombre.str.rstrip('')
autores['clave_match01'] = autores[['surname', 'name1']].apply(lambda x: ''.join(x), axis=1)

bla = autores.Nombre.str.findall(r'[Uu]niv[*]\w+')
autores['Match'] = autores.Nombre.str.match(r'[Fkn*]')

#####PATRONES#####
import re
result = re.sub('abc',  '',    input)           # Delete pattern abc
result = re.sub('abc',  'def', input)           # Replace pattern abc -> def
result = re.sub(r'\s+', ' ',   input)           # Eliminate duplicate whitespaces
result = re.sub('abc(def)ghi', r'\1', input)    # Replace a string with a part of itself

#replace
string3= 'Depart. de anatomia,University of buenos aires'

r'dogs'
bla = re.search(r'[Uu]niv[*]', )
bla = re.match(r'univ', string3)

re.match(r'From\s+', 'From amk Thu May 14 19:12:10 1998')  

bla = re.search(r'[Uu]niv[*]', string3)
bla

string3= 'Depart. de anatomia,University of buenos aires'
string3.str.findall(r'[Uu]niv[*]')

string3 = re.sub('Depart. ', 'Departamento ', string3)
string3 = re.sub('Univ\w+ ', 'Universidad ', string3)
string3 = re.sub('univ\w+ | Univ\w+', 'Universidad ', string3)


##Expresiones regulares
re.findall(r'[b]',s2)
re.findall(r'[/^stop[a-zA-Z]*/]',s3)

##Buscar lo que esta dentro de los corchetes
re.findall(r"\[(\w+)\]", s2)
 
# find all occurances of the digits
df['AU'].str.findall(r'\d')
  
# find which entries contain one specific word
s2.str.contains('Geyer')
 
##Todos los que tienen corchetes y palabras en el medio
df['C1'].str.contains('[\w+]')
 
bla = df['C1'].str.findall('[\w+]')
 
s2 = s.str.extract('([Sunesen])(\d)')

#Extrae la primera inicial
autores['name1'] = autores.name.str[:1]
#Genera el codigo de busqueda
