#!/usr/bin/python
# -*- coding: utf-8  -*-


import csv
import time
import sys
import os
import re
from ArticleModel import *
from sqlalchemy import *
import getopt
from __builtin__ import isinstance

import io

csv.field_size_limit(sys.maxsize)

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
            opts, args = getopt.getopt(argv[1:], "hfd:v", ["help", "file=", "dbstring="])
        except getopt.error, msg:
            raise Usage(help_message)

        file = None
        dbstring = None
        
        # option processing
        for option, value in opts:
            if option == "-v":
                verbose = True
            if option in ("-h", "--help"):
                raise Usage(help_message)
            if option in ("-f", "--file"):
                file = value

        if file == None: 
            raise Usage(help_message)
        
            
            
        
        with open(file,'r' """,encoding='utf8'""") as csvfile:
                        
            reader = csv.DictReader(csvfile, delimiter=',', quotechar='"')

            for row in reader:
                
                link = row['Link']
                
                #http://www.scopus.com/inward/record.url?eid=2-s2.0-80052183422&partnerID=40&md5=70d4e245236aca05e7992b3e6193a060
                eid_matcher = re.search('.+eid\=(.+?)\&.+', link)
                eid =  eid_matcher.group(1)
                
                print eid
                

    except Usage, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        print >> sys.stderr, "\t for help use --help"
        return 2


if __name__ == "__main__":
    
    try: 
        sys.exit(main())
    except Exception as e:
        print "Error"
        print str(e)    



        
