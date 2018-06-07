# -*- coding: utf-8 -*-
"""
Created on Thu May 24 16:32:09 2018
@author: Observatorio
"""

import pandas as pd
import re

###Las expresiones regulares tienen 3 claves
###1 castellano
###2 sigla
###3 Ingles
#uba='([Uu]n[iv].*\s?de|of\s?[Bb][us].*\s?[Aa][is])|(UBA)|([Bb][us].*\s?[Aa][is].*\s?[Uu]n[iv])'
#unc='(([Uu]n[iv].*\s?[Nn]ac.*\s?de|of\s?[Cc]or)|(UNC)|([Nn]at.*\s?[Uu]n[iv].*\s?de|of\s?[Cc]or))'


instituciones_dict = [{'country': 'AR', 'inst_id': 1000, 'inst_name': 'Universidad de Buenos Aires', 'regex': '([Uu]n[iv].*\s?de|of\s?[Bb][us].*\s?[Aa][is])|(UBA)|([Bb][us].*\s?[Aa][is].*\s?[Uu]n[iv])'},
                  {'country': 'AR', 'inst_id': 1003, 'inst_name': 'Universidad Nacional de Cordoba', 'regex': '(([Uu]n[iv].*\s?[Nn]ac.*\s?de|of\s?[Cc]or)|(UNC)|([Nn]at.*\s?[Uu]n[iv].*\s?de|of\s?[Cc]or))'}]
instituciones = pd.DataFrame(instituciones_dict)

listado= pd.Series(['Universidad de Buenos Aires ',
           'Universidad de Bs Aires ', 
           'Universidad de Bs As', 
           '3b', 
           'University of Buenos Aires', 
           'Universi', 
           'UBA', 
           'University of Bs As', 
           'Unv de Buenos Aires', 
           'cosas de Buenos Aires', 
           '03c',
           'Universidad Naci de Cordoba', 
           'Bs As university', 
           'UNC', 
           'Buenos Aires University', 
           'National University of Cordo'
           ])

###Busquedas
listado.str.contains(instituciones['regex'][0])
listado.str.contains(instituciones['regex'][1])


    



