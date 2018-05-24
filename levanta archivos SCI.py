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
path = ('.') 
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
    #aut_univ3.append(re.findall(r'\bArgentina', base_genero['C1'][i]))
    aut_univ3.append(re.findall(r'\bBrasil', base_genero['C1'][i]))


re.findall(r'\d{1,5}','gfgfdAAA1234ZZZuijjk')

re.findall(r'\sBrasil','gfgfd BrasilAAA1234ZZZuijjArgentinak')
re.findall(r'\bArgentina','gfgfd BrasilAAA1234ZZZuijj Argentinak')


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



