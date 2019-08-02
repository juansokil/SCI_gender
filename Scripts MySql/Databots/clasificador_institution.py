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
command  --dbstring=[user:pass@host/dbname]

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
            

            #print str(ip.inst_id) + "  ---- " + pattern
            #agrega una expresion a la lista, junto con el id que la origina (id,re)
            search_list.append( ( ip.inst_id, re.compile(pattern, re.I)) )
            
        
        
        ## Procesamiento de todas las direcciones usando el clasificador

        addresses = session.query(Address).filter( func.upper(Address.country) == 'ARGENTINA').all()
        
        #addresses = (session.query(Address, Article).filter( func.upper(Address.country) == 'ARGENTINA').filter(Article.year == 2017).all())
        
        
        
        for address in addresses:
            
            #Prueba - Imprimir cada uno #
            print(address)
            normalized = normalize.normalize( address.address )
            
            #print normalized
	    
            identified_lst = set()
    
            for (iid,regexp) in search_list:             
                if regexp.search(normalized):
                    identified_lst.add(iid)
                    
                    
            if len(identified_lst) > 0:
            
                #print identified_lst
                n = 0
                for iid in identified_lst:
                    
                    ai = ArticleInstitution(address.ut, address.order)
                    ai.address = address.address.strip()
                    ai.inst_id = iid
                    ai.inst_n = n
            
                    session.add(ai)

                    n = n + 1
            else:
                
                #print "SIN MATCH: " + normalized   
                ai = ArticleInstitution(address.ut, address.order)
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
