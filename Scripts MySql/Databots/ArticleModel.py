from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import *
from sqlalchemy.orm import *
import sys

Base = declarative_base()


class AuthorInstitution(Base):

	__tablename__ = 'authorXinstitution'

	#{ Columns
	ut = Column(String(32), ForeignKey('article.ut'), primary_key=True)
	order = Column(Integer, primary_key=True, autoincrement=False)
	address = Column( UnicodeText(collation='utf8_bin') )
	inst_id = Column(Integer)
	inst_name = Column( UnicodeText(collation='utf8_bin') )
	inst_n = Column(Integer,  primary_key=True, autoincrement=False)
	author_id = Column(String(32), primary_key=False, autoincrement=False)
	name_complete = Column( UnicodeText(255, collation='utf8_bin') )
	country = Column( Unicode(255, collation='utf8_bin') )
	#}

	def __init__(self, ut, order, author_id, name_complete, country):
		self.ut = ut
		self.order = order
		self.author_id = author_id
		self.name_complete = name_complete
		self.country = country



class InstitutionSearch(Base):

	__tablename__ = 'institution_search'

	#{ Columns
	record_id = Column(Integer, primary_key=True)
	inst_id = Column(Integer)
	inst_type = Column( UnicodeText(1,collation='utf8_bin') )
	inst_name = Column( UnicodeText(collation='utf8_bin') )
	inst_acron = Column( UnicodeText(50,collation='utf8_bin') )
	inst_re = Column( UnicodeText(255,collation='utf8_bin') )
	#}



class ArticleInstitution(Base):

	__tablename__ = 'articleXinstitution'

	#{ Columns
	ut = Column(String(32), ForeignKey('article.ut'), primary_key=True)
	order = Column(Integer, primary_key=True, autoincrement=False)
	address = Column( UnicodeText(collation='utf8_bin') )
	inst_id = Column(Integer)
	inst_name = Column( UnicodeText(collation='utf8_bin') )
	inst_n = Column(Integer,  primary_key=True, autoincrement=False)
	country = Column( Unicode(255, collation='utf8_bin') )	

	#}

	def __init__(self, ut, order):
		self.ut = ut
		self.order = order
		self.country = country


class Author(Base):
	
	__tablename__ = 'author'
	
	#{ Columns
	ut = Column(String(32), ForeignKey('article.ut'), primary_key=True)
	order = Column(Integer, primary_key=True, autoincrement=False)
	name = Column( UnicodeText(255, collation='utf8_bin') )
	author_id = Column(String(32), primary_key=False, autoincrement=False)
	#}
	
	def __init__(self, order, name, author_id):
		self.order = order
		self.name = name
		self.author_id = author_id

	
class AuthorAddress(Base):
	
	__tablename__ = 'author_address'
	
	#{ Columns
	ut = Column(String(32), ForeignKey('article.ut'), primary_key=True)
	order = Column(Integer, primary_key=True, autoincrement=False)
	name = Column( UnicodeText(255, collation='utf8_bin') )
	surname = Column( UnicodeText(255, collation='utf8_bin') )
	address = Column( UnicodeText(collation='utf8_bin') )
	level1 = Column( Unicode(255, collation='utf8_bin') )
	level2 = Column( Unicode(255, collation='utf8_bin') )
	level3 = Column( Unicode(255, collation='utf8_bin') )
	country = Column( Unicode(255, collation='utf8_bin') )
	author_id = Column(String(32), primary_key=False, autoincrement=False)
	name_complete = Column( UnicodeText(255, collation='utf8_bin') )
 
	#}
	
	def __init__(self, order, name, surname):
		self.name = name
		self.surname = surname
		self.order = order

class Keyword(Base):
	
	__tablename__ = 'keyword'
	
	#{ Columns
	ut = Column(String(32), ForeignKey('article.ut'), primary_key=True)
	order = Column(Integer, primary_key=True, autoincrement=False)
	keyword = Column( Unicode(255, collation='utf8_bin') )
	#}
	
	def __init__(self, order, keyword):
		self.keyword = keyword
		self.order = order
	

class Address(Base):
	
	__tablename__ = 'address'
	
	#{ Columns
	ut = Column(String(32), ForeignKey('article.ut'), primary_key=True)
	order = Column(Integer, primary_key=True, autoincrement=False)
	address = Column( UnicodeText(collation='utf8_bin') )
	
	level1 = Column( Unicode(255, collation='utf8_bin') )
	level2 = Column( Unicode(255, collation='utf8_bin') )
	level3 = Column( Unicode(255, collation='utf8_bin') )

	country = Column( Unicode(255, collation='utf8_bin') )
	#}
	
	def __init__(self, order):
		self.order = order


	
class Article(Base):
	
	__tablename__ = 'article'
	
	#{ Columns
	ut = Column(String(32), primary_key=True)
	title = Column(UnicodeText(collation='utf8_bin'))
	link = Column(Unicode(255))
	pub_name = Column( Unicode(255, collation='utf8_bin') )
	pub_issn = Column( String(9) )
	doctype	 = Column( String(30) )
	volume = Column( String(10) )
	number = Column( String(10) )
	year = Column( String(4) )
	abstract = Column( UnicodeText(collation='utf8_bin') )
	notes = Column( UnicodeText(collation='utf8_bin') )
	language = Column( String(20) )
	#}
	
	
	def __init__(self, ut):
		self.ut = ut
	
	 
	#def __repr__(self):
	#	return "<User('%s','%s', '%s')>" % (self.name, self.fullname, self.password)

#{ Relations
	authors = relation(Author)
	keywords = relation(Keyword)
	addresses = relation(Address)
	#contact = relation(Contact)
	authoraddresses = relation(AuthorAddress)

	#}



class Contact(Base):

	__tablename__ = 'contact'

	#{ Columns
	ut = Column(String(32), primary_key=True)
	email = Column(UnicodeText(collation='utf8_bin'))
	#link = Column(Unicode(255))
	#}

	def __init__(self, ut):
		self.ut = ut


	



if __name__ == "__main__":
	if len(sys.argv) == 2:
		metadata = Base.metadata
		engine = create_engine('mysql://' + sys.argv[1], echo=True)
		metadata.create_all(engine) 
	else:
		print "ArticleModel.py user:passwd@host/database"


