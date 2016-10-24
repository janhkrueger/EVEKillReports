#!/usr/bin/env python2.7
# encoding: utf-8


import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
import psycopg2
import ConfigParser
import codecs
import time
from datetime import datetime
import urllib
from pprint import pprint
from lxml import etree
import xml.etree.ElementTree

def main():
	conf = ConfigParser.ConfigParser()
	conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])

	db_schema = conf.get("GLOBALSPSQL","edb_name")
	db_IP = conf.get("GLOBALSPSQL","edb_host")
	db_user = conf.get("GLOBALSPSQL","edb_user")
	db_pw = conf.get("GLOBALSPSQL","edb_pw")
	db_port = int(conf.get("GLOBALSPSQL","edb_port"))
	db = psycopg2.connect(database = "[DATABASE]",host=db_IP, user="[USERNAME]", password="[PASSWORD]")
	cursor = db.cursor()


	e = xml.etree.ElementTree.parse('Jumps.xml').getroot()
	#datatime
	survey = e[1][1].text
	for atype in e.findall('result'):
		for btype in atype.findall('rowset'):
			for ctype in btype.findall('row'):
				system = int(ctype.get('solarSystemID'))
				jumps = int(ctype.get('shipJumps'))
				sql = """INSERT INTO universe.jumps (timestamp, shipjumps, solarsystemid) VALUES ('%s}', %s, %s)""" % (survey, jumps, system)
				#print sql
				cursor.execute("%s" % (sql))
			db.commit()
	
	db.close()

if __name__ == "__main__":
	main()
