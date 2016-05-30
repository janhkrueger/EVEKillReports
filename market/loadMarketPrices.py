#!/usr/bin/env python2.7
# encoding: utf-8


import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import ConfigParser
import codecs
import time
import StringIO
from datetime import datetime
from elementtree.ElementTree import parse
from pprint import pprint
import xml.etree.ElementTree as ET
import requests


import psycopg2
import psycopg2.extensions

conf = ConfigParser.ConfigParser()
conf.read(["init.ini", "init_local.ini"])

cursor = None
db = None

def db_init():
	db_schema = conf.get("GLOBALSPSQL","edb_name")
	db_IP = conf.get("GLOBALSPSQL","edb_host")
	db_user = conf.get("GLOBALSPSQL","edb_user")
	db_pw = conf.get("GLOBALSPSQL","edb_pw")
	db_port = int(conf.get("GLOBALSPSQL","edb_port"))

	global cursor,db
        db = psycopg2.connect(database = "",host=db_IP, user="", password="")
	cursor = db.cursor()

def getData(url):
	request_headers = {
		"Accept":"application/json",
		"Accept-Encoding":conf.get("GLOBALS","loadencoding"),
		"Maintainer":"",
		"Mail":conf.get("GLOBALS","mail"),
		"Twitter":"",
		"User-Agent":"UpdateMarketPrices"
	}

        request = urllib2.Request(url, headers=request_headers)
        opener = urllib2.build_opener()
        raw_zip = opener.open(request)
        dump_zip_stream = raw_zip.read()
        dump_IOstream = StringIO.StringIO(dump_zip_stream)
        zipper = gzip.GzipFile(fileobj=dump_IOstream)
        data = json.load(zipper)
	return data

def main():
	db_init()
	conf = ConfigParser.ConfigParser()
	conf.read(["init.ini", "init_local.ini"])

	marketurl = "https://crest-tq.eveonline.com/market/prices/"
	# Abfragen des Krieges
	try:
		data = getData(marketurl)
	except IOError:
		print " >>> IOError: kann Preise nicht lesen, beende Verarbeitung."
		quit()
	except:
	       	print " >>> Fehler: kann Preise nicht lesen, beende Verarbeitung"
	       	quit()

	# print data

	jetzt = str(datetime.now())
	for item in data['items']:			
		adjustedPrice = item['adjustedPrice']
		if 'averagePrice' in item:
			averagePrice = item['averagePrice']
		else:
			averagePrice = 0.0
		typeID = item['type']['id']
		# now put it into the database
		sql = "INSERT INTO \"universe\".\"crestMarketPrices\" (\"typeID\", \"adjustedPrice\", \"averagePrice\", \"surveyDate\") VALUES ({0}, {1}, {2}, '{3}' )".format(typeID, adjustedPrice, averagePrice, jetzt )
		#print sql
		cursor.execute(sql)
		db.commit()
		adjustedPrice = 0.0
		averagePrice = 0.0


	# Curse beenden und Verbindung korrekt schliessen
	cursor.close()
	db.close()


if __name__ == "__main__":
	main()
