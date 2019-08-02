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
import itertools 
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
            if option in ("-d", "--dbstring"):
                dbstring = value

        if file == None: 
            raise Usage(help_message)
        
        if dbstring == None:
            raise Usage(help_message)
            
            
        db = create_engine('mysql://' + dbstring + '?charset=utf8', echo=False)
        metadata = Base.metadata
        metadata.bind = db
        session = create_session()
            
        
        
        with open(file,'r' """,encoding='utf8'""") as csvfile:
                        
            reader = csv.DictReader(csvfile, delimiter=',', quotechar='"')

            for row in reader:
                
                title = unicode(row['Title'], errors='replace') 
                abstract = unicode(row['Abstract'], errors='replace') 
                year = row['Year'] 
                authors = row['Authors'] 
                authorsid = row['Author(s) ID']
                authorsAndaffiliations = row['Authors with affiliations']
                affiliations = row['Affiliations']
                email = unicode(row['Correspondence Address'], errors='replace')
                ####ACA ME ESTABA DANDO UN ERROR CON EL LARGO DE LOS CAMPOS, PERO EN REALIDAD ERAN ESPACIOS VACIOS###
                source = unicode(row['Source title'][0:255] , errors='ignore') 
#                volume = unicode(row['Volume'] , errors='ignore') 
#                issue =  unicode(row['Issue'] , errors='ignore') 
                issn = row['ISSN']
                lang = unicode(row['Language of Original Document'], errors='ignore') 
#                keywords = unicode(row['Index Keywords'], errors='replace') 
                doctype = unicode(row['Document Type'])
                link = row['Link']
                #http://www.scopus.com/inward/record.url?eid=2-s2.0-80052183422&partnerID=40&md5=70d4e245236aca05e7992b3e6193a060
                eid_matcher = re.search('.+eid\=(.+?)\&.+', link)
                eid =  eid_matcher.group(1)
                
                print eid
                
                article = Article(eid)
                article.title = title
                article.title = title
                article.abstract = abstract
                article.year = year
                article.pub_name = source
                article.pub_issn = issn
                #article.volume = volume
                article.doctype = doctype
                #article.number = issue[:10]
                article.link = link
                article.language = lang
                #article.email = email
                
                orderes = []
                autores = []
                orderes_id = []
                autores_id = []                


                order = 1
                for author_str in authors.split(','):
                    #author = Author(order, author_str.strip())
                    autores.append(author_str)
                    orderes.append(order)
                    #article.authors.append(author)
                    order = order + 1
                
                order_id = 1
                for author_id_str in authorsid.split(';'):
                    autores_id.append(author_id_str)
                    orderes_id.append(order_id)
                    order_id = order_id + 1

                # iterates over 3 lists and excutes  
                # 2 times as len(value)= 2 which is the 
                # minimum among all the three  
                for (order, name, author_id) in zip(orderes, autores, autores_id): 
                   #print (order, name, author_id)
                   authors_id = Author(order, name, author_id)
                   #print (authors_id)
                   article.authors.append(authors_id)


                order = 1
                for aa_str in authorsAndaffiliations.split(';'):
                    
                    aa_parts = aa_str.split(',')
                    
                    if len(aa_parts) > 1:
                        author_address = AuthorAddress(order,  aa_parts[1].strip(), aa_parts[0].strip() )
                        
                        if len(aa_parts) > 2:
                            author_address.address = ','.join(aa_parts[2:]).strip()
                        
                        if len(aa_parts) > 3:
                        
                            author_address.level1 = aa_parts[2].strip()
                            author_address.level2 = aa_parts[3].strip()
                            
                            if len(aa_parts) > 4:
                                author_address.level3 = aa_parts[4].strip()
                        
                        author_address.country = aa_parts[len(aa_parts)-1].strip() 
                    
                        article.authoraddresses.append( author_address )
                        
                    order = order + 1
                    
                    
                order = 1
                for af_str in affiliations.split(';'):
                    
                    af_parts = af_str.split(',')
                    
                    if len(af_parts) > 1:
                        address = Address(order)
                        
                        address.address = af_str                        
                        address.level1 = af_parts[0].strip()
                        address.level2 = af_parts[1].strip()

                        if len(af_parts) > 2:
                            address.level3 = af_parts[2].strip()
                        
                        address.country = af_parts[len(af_parts)-1].strip() 
                    
                        article.addresses.append( address )
                    order = order + 1
                 
                #contact= Contact(article.email)
                #article.email.append(contact)   
                    
#                order = 1
#                for keyword_str in keywords.split(';'):
#                    
#                    if keyword_str.strip() != '':
#                        keyword = Keyword(order, keyword_str.strip() )
#                        article.keywords.append( keyword )
#                        
#                    order = order + 1
        
                if session.query(Article).filter(Article.ut == article.ut).first() == None:
                    session.add(article)
                    session.flush()
                else:
                    print 'Duplicado: ' + article.ut

        
            

      
        

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



        
