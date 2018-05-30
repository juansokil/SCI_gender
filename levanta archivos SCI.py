
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 20 21:04:28 2018
@author: Juan
"""
import csv
import os
import pandas as pd
import re

#VERSION 2
path = ('.') 
files = os.listdir(path)
files
os.getcwd()

####Levanta datos
df = pd.DataFrame()
for f in files:
    print(f)
    csv = pd.read_csv(f, sep='\t', encoding ="latin1", lineterminator='\n', header=0, index_col=False)
    print(csv)
    df = df.append(csv)


#df.columns
df.shape
df= df.dropna(subset=['C1'])
df.shape


base_genero =  df[['C1','FU','UT','SO','PY','TI','SO','WC','SC']]
base_genero.shape

#Recupera el UT
ut =  df[['UT','PY','TI','SO','WC','SC']]
ut.reset_index(level=[0], inplace=True)
ut = ut.rename(index=str, columns={"index": "nrow"})


###pasa a index
base_genero= base_genero.set_index('UT')
cantidad = base_genero.shape[0]


###AUTORES y UNIVERSIDADES
aut_univ1 = []
aut_univ2 = []
nrow = []
for i in range(cantidad):
    ####CAPTURA TODO LO QUE ESTA ENTRE CORCHETES
    ####EN ESTE CASO ME SIRVE PORQUE LOS AUTORES ESTAN ENTRE LOS CORCHETES
    aut_univ1.append(re.findall(r"\[[A-Z a-z 0-9 _ ,;.&'-]+\]", base_genero['C1'][i]))
    #### EN ESTE CASO CAPTA TODO LO QUE ESTA DESPUES DEL CORCHETE DE CIERRE - ACA CAPTARIA 
    ####TODA LA DIRECCION 
    aut_univ2.append(re.findall(r"\][A-Z a-z 0-9 _ ,;.&'-]+", base_genero['C1'][i]))
    nrow.append(i)

nrow = pd.DataFrame(nrow)
nrow.columns = ['nrow']



identificador= pd.merge(ut, nrow, on=['nrow'], how='left')


#####autores####
df1 = pd.DataFrame(aut_univ1)
df1 = df1.stack()
df1 = df1.to_frame()
df1.reset_index(level=[1], inplace=True)
df1.reset_index(level=[0], inplace=True)

df1 = df1.rename(index=str, columns={"level_1": "NroInst", 0: "Autor", "index": "nrow"})

df1['Autor']=df1['Autor'].str.replace('[','')
df1['Autor']=df1['Autor'].str.replace(']','')

######Instituciones
df2 = pd.DataFrame(aut_univ2)
df2 = df2.stack()
df2 = df2.to_frame()
df2.reset_index(level=[1], inplace=True)
df2.reset_index(level=[0], inplace=True)

df2 = df2.rename(index=str, columns={"level_1": "NroInst", 0: "Direccion", "index": "nrow"})

df2['Direccion']=df2['Direccion'].str.replace('[','')
df2['Direccion']=df2['Direccion'].str.replace(']','')




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
AuthorXInstitution= pd.merge(AuthorXInstitution, identificador, on=['nrow'], how='left')

####SEPARA####
AuthorXInstitution['Nombre'] = AuthorXInstitution['Nombre_autor'].str.rsplit(',').str[-1] 
AuthorXInstitution['Apellido'] = AuthorXInstitution['Nombre_autor'].str.rsplit(',').str[0] 


AuthorXInstitution['Institucion'] = AuthorXInstitution['Direccion'].str.rsplit(',').str[0] 
AuthorXInstitution['Pais'] = AuthorXInstitution['Direccion'].str.rsplit(',').str[-1] 


AuthorXInstitution['Pais'] = AuthorXInstitution['Pais'].str.replace(';','')

AuthorXInstitution['Pais'] = AuthorXInstitution['Pais'].str.replace('\d+','')

###En el caso de USA tiene que eliminar el codigo postal  2 letras seguidas de digitos y finalmente esta el país
AuthorXInstitution['Pais'] = AuthorXInstitution['Pais'].str.replace('[A-Z].*[0-9]','')
###En el caso de USA ttambien pasa que no ponen el codigo postal sino el estado
###asi que me fijo todo lo que diga cualquier letra, espacio, usa y lo reemplazo por USA
AuthorXInstitution['Pais'] = AuthorXInstitution['Pais'].str.replace('[A-Z].*[USA]','USA')

###quita los espacios###
AuthorXInstitution['Pais'] = AuthorXInstitution['Pais'].str.strip()
AuthorXInstitution['Institucion'] = AuthorXInstitution['Institucion'].str.strip()
AuthorXInstitution['Nombre'] = AuthorXInstitution['Nombre'].str.strip()
AuthorXInstitution['Apellido'] = AuthorXInstitution['Apellido'].str.strip()


AuthorXInstitution=AuthorXInstitution.drop_duplicates()



AuthorXInstitution.to_csv('Author.csv')


#####DEJA LA BASE PREPARADA PARA TRABAJAR CON EXPRESIONES REGULARES######
##################CONTROLES#####################
listado_nombres=AuthorXInstitution['Nombre'].unique()
listado_nombres = pd.DataFrame(listado_nombres)



listado_paises=AuthorXInstitution['Pais'].unique()
listado_paises = pd.DataFrame(listado_paises)

#control_ut=AuthorXInstitution['UT'].unique()
#control_ut = pd.DataFrame(control_ut)


#control_ut
#cantidad






