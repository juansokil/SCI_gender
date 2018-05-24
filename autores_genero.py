# -*- coding: utf-8 -*-
"""
Created on Thu May 24 16:33:17 2018

@author: Observatorio
"""

### si quisiera sacar las cosas de un lado o del otro
autores['Pais'] = autores.Pais.str.lstrip()
autores['Apellido'] = autores.Nombre.str.lstrip('prueba: ')
autores['Apellido2'] = autores.Nombre.str.rstrip('')
autores['clave_match01'] = autores[['surname', 'name1']].apply(lambda x: ''.join(x), axis=1)
