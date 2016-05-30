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
from elementtree.ElementTree import parse
from pprint import pprint

import xml.etree.ElementTree as ET

conf = ConfigParser.ConfigParser()
conf.read(["init.ini", "init_local.ini"])

cursor = None
db = None

db_schema = conf.get("GLOBALS","db_name")
db_IP = conf.get("GLOBALS","db_host")
db_user = conf.get("GLOBALS","db_user")
db_pw = conf.get("GLOBALS","db_pw")
db_port = int(conf.get("GLOBALS","db_port"))

def db_init():
	global cursor,db
	db = MySQLdb.connect(host=db_IP, user=db_user, passwd=db_pw, port=db_port, db=db_schema)
	cursor = db.cursor()


def main():
	db_init()
	conf = ConfigParser.ConfigParser()
	conf.read(["init.ini", "init_local.ini"])

	db_schema = conf.get("GLOBALS","db_name")
	db_IP = conf.get("GLOBALS","db_host")
	db_user = conf.get("GLOBALS","db_user")
	db_pw = conf.get("GLOBALS","db_pw")
	db_port = int(conf.get("GLOBALS","db_port"))
	db_chars = conf.get("KILL_REPORTER","db_chars")

	jetzt =  str(datetime.now())

	with open('IndustrySystems.json') as data_file:    
    			data = json.load(data_file)
			for entry in data['items']:
				systemID = entry["solarSystem"]["id"]
				solarSystemName = entry["solarSystem"]["name"]
				manufacturingIndex = entry["systemCostIndices"][1]["costIndex"]
				teResearchIndex = entry["systemCostIndices"][2]["costIndex"]
				meResearchIndex = entry["systemCostIndices"][3]["costIndex"]
				copyIndex = entry["systemCostIndices"][4]["costIndex"]
				inventionIndex = entry["systemCostIndices"][0]["costIndex"]

				sql = "INSERT INTO industryCostIndexes (solarSystemID, surveyDate, manufacturingIndex, teResearchIndex, meResearchIndex, copyIndex, inventionIndex, solarSystemName) VALUES ({0}, '{7}', {1}, {2}, {3}, {4}, {5}, '{6}') ON DUPLICATE KEY UPDATE manufacturingIndex={1}, teResearchIndex ={2}, meResearchIndex={3}, copyIndex={4}, inventionIndex={5}".format(systemID, manufacturingIndex, teResearchIndex, meResearchIndex, copyIndex, inventionIndex, solarSystemName, jetzt) 
                        	cursor.execute("%s" % (sql))
                        	db.commit()

	db.close()

if __name__ == "__main__":
	main()
