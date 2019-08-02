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

            reader = csv.DictReader(csvfile, delimiter='\t', quotechar='"')

            for row in reader:

                title = unicode(row['TI'], errors='replace')
                abstract = unicode(row['AB'], errors='replace')
                year = row['PY']
                authors = row['AF']
                authorsAndaffiliations = row['C1']
                #affiliations = row['Affiliations']
                source = unicode(row['SO'] , errors='ignore')
                volume = unicode(row['VL'] , errors='ignore')
                issue =  unicode(row['IS'] , errors='ignore')
                issn = row['SN']
                lang = unicode(row['LA'], errors='ignore')
                #keywords = unicode(row[''], errors='replace')
                doctype = unicode(row['DT'])
                link = row['UT']

                #http://www.scopus.com/inward/record.url?eid=2-s2.0-80052183422&partnerID=40&md5=70d4e245236aca05e7992b3e6193a060
                #eid_matcher = re.search('.+eid\=(.+?)\&.+', link)
                #eid =  eid_matcher.group(1)
                eid = link

                print eid

                article = Article(eid)

                article.title = title
                article.abstract = abstract
                article.year = year
                article.pub_name = source
                article.pub_issn = issn
                article.volume = volume
                article.doctype = doctype
                article.number = issue[:10]
                article.link = link
                article.language = lang


                order = 1
                for author_str in authors.split(';'):
                    author = Author(order, author_str.strip() )
                    article.authors.append( author )
                    order = order + 1



#[Rull, Juan] Consejo Nacl Invest Cient & Tecn, PROIMI Biotecnol, LIEMEN Div Control Biol Plagas, San Miguel De Tucuman, Argentina; [Lasa, Rodrigo; Rodriguez, Christian; Ortega, Rafael; Elisabeth Velazquez, Olinda; Aluja, Martin] Congregac El Haya AC, Inst Ecol, Xalapa 91070, Veracruz, Mexico

                order = 1
                for (aa_str,trash) in re.findall("(\[.+?\]\s?.+?)($|;)", authorsAndaffiliations):

                    aa_matcher = re.search("\s*(\[.+\])\s*(.+)", aa_str)

                    authors =  aa_matcher.group(1)

                    aff =  aa_matcher.group(2)
                    aff_parts = aff.split(',')

                    aff_level1 = ""
                    aff_level2 = ""
                    aff_level3 = ""

                    aff_country = ""

                    if len(aff_parts) > 1:

                        aff_level1 = aff_parts[0].strip()
                        aff_level2 = aff_parts[1].strip()

                        if len(aff_parts) > 2:
                            aff_level3 = aff_parts[2].strip()

                        aff_country = aff_parts[len(aff_parts)-1].strip()


                    for author in authors.split(';'):
			author = author.replace('[','').replace(']','')
                        author_parts = author.split(',')
                        surname = author_parts[0].strip()
                        if len(author_parts) > 1:
                            name = author_parts[1].strip()
                        else:
                            name = ""

                        author_address = AuthorAddress(order,  surname, name )
                        author_address.address = aff
                        author_address.level1 = aff_level1
                        author_address.level2 = aff_level2
                        author_address.level3 = aff_level3
                        author_address.country = aff_country

                        article.authoraddresses.append( author_address )

                        order = order + 1


                # order = 1
                # for af_str in affiliations.split(';'):
                #
                #     af_parts = af_str.split(',')
                #
                #     if len(af_parts) > 1:
                #         address = Address(order)
                #
                #         address.address = af_str
                #         address.level1 = af_parts[0].strip()
                #         address.level2 = af_parts[1].strip()
                #
                #         if len(af_parts) > 2:
                #             address.level3 = af_parts[2].strip()
                #
                #         address.country = af_parts[len(af_parts)-1].strip()
                #
                #         article.addresses.append( address )
                #     order = order + 1
                #
                #
                # order = 1
                # for keyword_str in keywords.split(';'):
                #
                #     if keyword_str.strip() != '':
                #         keyword = Keyword(order, keyword_str.strip() )
                #         article.keywords.append( keyword )
                #
                #     order = order + 1


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
