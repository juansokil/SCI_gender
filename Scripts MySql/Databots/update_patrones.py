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

def deacute(c):
    if c == u'Á':
        c = u'A'
    elif c == u'É':
        c = u'E'
    elif c == u'Í':
        c = u'I'
    elif c == u'Ó':
        c = u'O'
    elif c == u'Ú':
        c = u'Ú'
    elif c == u'Ñ':
        c = u'N'
    return c


def clean(word):
    retword = ''
    word = word.upper()
    for c in word:
        c = deacute(c)
        if c.isalpha():
            retword = retword + c

    return retword



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
        
        for ip in inst_patterns:

            print ip.inst_name

            pattern = ''
            words = ip.inst_name.split(' ')

            for word in words:
                word = clean(word)
        
                #if len(word)>=3 and word != 'DEL' and word != 'LAS' and word!='LOS':
                #    pattern += word[0:3] + ';'
                if len(word)>=5:
                    pattern += word[0:5] + ';'
                if len(word) ==4:
                    pattern += word[0:4] + ';'               
                if len(word) ==3 and (word != 'DEL' and word != 'LAS' and word != 'LOS'):
                    pattern += word[0:3] + ';'
            ip.inst_re = pattern[:-1]
            
        session.flush()

    except Usage, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        print >> sys.stderr, "\t for help use --help"
        return 2


if __name__ == "__main__":
    sys.exit(main())
    

