#!/usr/bin/python
# -*- coding: utf-8  -*-

import csv
import time
import sys
import os
import re
from ArticleModel import * 
from sqlalchemy import *
from sqlalchemy import func
import getopt
from __builtin__ import isinstance
import string
import io
import normalize


help_message = '''
command --file=[File] --dbstring=[user:pass@host/dbname]

'''

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        
        try:
            opts, args = getopt.getopt(argv[1:], "hd", ["help", "dbstring="])
        except getopt.error, msg:
            raise Usage(help_message)

        file = None
        dbstring = None
        
        # option processing
        for option, value in opts:
            if option in ("-h", "--help"):
                raise Usage(help_message)
            if option in ("-d", "--dbstring"):
                dbstring = value 
        
        if dbstring == None:
            raise Usage(help_message)
            
            
        db = create_engine('mysql://' + dbstring + '?charset=utf8', echo=False)
        metadata = Base.metadata
        metadata.bind = db
        session = create_session()
        
        
        ## Creación de los patrones__ de busqueda
        inst_patterns = session.query(InstitutionSearch).all()
        search_list = []
        
        for ip in inst_patterns:
            
            elist = ip.inst_re.split(';')
    
            #arma el string de la expresion regular
            pattern = '((.*?)'
    
            for i in range(0,len(elist)):
                pattern += elist[i] + '([A-Za-z]*?)'
                if (i != (len(elist)-1)):
                    pattern += '\\s'
                
    
            if len(ip.inst_acron)>0:
                #le suma la busqueda por acronimo
                pattern += ')|(((.*?)\\s|^)' + ip.inst_acron + '(\\s(.*?)|$))'
            else:
                pattern += ')'
            
            #agrega una expresion a la lista, junto con el id que la origina (id,re)
            search_list.append( ( ip.inst_id, re.compile(pattern, re.I)) )
            
        
        
        ## Procesamiento de todas las direcciones usando el clasificador

        addresses = session.query(AuthorAddress).filter( func.upper(AuthorAddress.country) == 'ARGENTINA').all()
        
        for address in addresses:
            
            
            if address.address is not None:
            
                normalized = normalize.normalize( address.address )
    
                identified_lst = set()
        
                for (iid,regexp) in search_list:             
                    if regexp.search(normalized):
                        identified_lst.add(iid)
                        
                        
                if len(identified_lst) > 0:
                
                    n = 0
                    for iid in identified_lst:
                        
                        ai = AuthorInstitution(address.ut, address.order, address.author_id, address.name_complete, address.country)
                        ai.address = address.address.strip()
                        ai.inst_id = iid
                        ai.inst_n = n
                
                        session.add(ai)
    
                        n = n + 1
                else:
                    
                    
                    ai = AuthorInstitution(address.ut, address.order, address.author_id, address.name_complete, address.country)
                    ai.address = address.address
                    ai.inst_id = 9999
                    ai.inst_n = 0
            
                    session.add(ai)
    
                
                session.flush()

                
                
                  
            
    except Usage, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        print >> sys.stderr, "\t for help use --help"
        return 2


if __name__ == "__main__":
    sys.exit(main())
    
   # try: 
   #     sys.exit(main())
   # except Exception as e:
   #     print "Error"
   #     print str(e)    
        
############# Codigo Main ###########################
