# -*- coding: utf-8 -*-
"""
Created on Thu May 24 16:32:09 2018

@author: Observatorio
"""

import pandas as pd



###http://www.mpi.nl/corpus/html/trova/ch01s04.html

###busca un numero y una letra

### BUSCA UBA
pd.Series(['Universidad de Buenos Aires ',
           'Universidad de Bs Aires ', 
           'Univ Bs As', 
           'Unv de Buenos Aires', 
           '3b', 
           '03c']).str.contains('[Uu]n[iv].*[Bb][us].*[Aa][is]')

pd.Series(['Universidad de Buenos Aires ',
           'Universidad de Bs Aires ', 
           'Univ Bs As', 
           'Unv de Buenos Aires', 
           '3b', 
           '03c']).str.contains('[Uu]n[iv]/W*[Bb][us].*[Aa][is]')

uba1 = r'[Uu]n[iv].*[Bb][us].*[Aa][is]'
uba2 = r'UBA'
uba1 = r'[Uu]n[iv].*[Bb][us].*[Aa][is]'


AuthorXInstitution['UBA1']= AuthorXInstitution['Institucion'].str.contains(uba1)
AuthorXInstitution['UBA2']= AuthorXInstitution['Institucion'].str.contains(uba2)


cordoba=r'[Uu]n[iv].*[Nn][ac].*[Cc][oó][r]'
AuthorXInstitution['UNC'] = AuthorXInstitution['Institucion'].str.contains(cordoba)



columns = ['institucion_id','institucion_desc', 'regex']

keywords = pd.DataFrame(columns=columns)
keywords












#####PATRONES#####
import re
result = re.sub('abc',  '',    input)           # Delete pattern abc
result = re.sub('abc',  'def', input)           # Replace pattern abc -> def
result = re.sub(r'\s+', ' ',   input)           # Eliminate duplicate whitespaces
result = re.sub('abc(def)ghi', r'\1', input)    # Replace a string with a part of itself

