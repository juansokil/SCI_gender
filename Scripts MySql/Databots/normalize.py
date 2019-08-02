#!/usr/bin/python
# -*- coding: utf-8  -*-
import re

def normalize(name):
    
    normalized = name.upper().replace('Y',' ').replace('OF',' ').replace('(', ' ').replace(')',' ').replace('/',' ').replace('-',' ').replace(',',' ').replace(' DEL ', ' ').replace(' LA ',' ').replace(' LAS ',' ').replace(' EL ',' ').replace(' LOS ',' ').replace(' DE ',' ').replace(' & ',' ')
    normalized = normalized.replace(u'Á','A').replace(u'É','E').replace(u'Í','I').replace(u'Ó','O').replace(u'Ú','U').replace(u'Ñ','N')
    normalized = re.sub(' +',' ', normalized)        
    normalized = normalized.strip()
    
    return normalized
