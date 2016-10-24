#!/usr/bin/env python2.7
# encoding: utf-8


import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
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
conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])

cursor = None
db = None

wars = conf.get("LOADWARS","wars")

def db_init():
        db_schema = conf.get("GLOBALSPSQL","edb_name")
        db_IP = conf.get("GLOBALSPSQL","edb_host")
        db_user = conf.get("GLOBALSPSQL","edb_user")
        db_pw = conf.get("GLOBALSPSQL","edb_pw")
        db_port = int(conf.get("GLOBALSPSQL","edb_port"))

        global cursor,db
        db = psycopg2.connect(database = "[DATABASE]",host=db_IP, user="[USERNAME]", password="[PASSWORD]")
        cursor = db.cursor()

def getData(url):
	request_headers = {
		"Accept":"application/json",
		"Accept-Encoding":conf.get("GLOBALS","loadencoding"),
		"Maintainer":"",
		"Mail":conf.get("GLOBALS","mail"),
		"Twitter":"",
		"User-Agent":""
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
	conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])

	jetzt =  str(datetime.now())

	data = getData(wars)

	totalCount =  data['totalCount_str']

	sql = "SELECT max(warID) as maxWarID FROM wars.wars"
	cursor.execute( sql)
	
	#for (maxWarID) in cursor:
#		startWarID =  maxWarID[0]
		

        
	#startWarID = int(startWarID)
        startWarID = 508617
	totalCount = int(totalCount)

	# print "%s StartWar: %s EndeWar: %s" % (time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),startWarID, totalCount)

        wardetailurl = conf.get("LOADWARS","wardetail")

	if (startWarID < totalCount):
		for warID in range(startWarID, totalCount):
			# Zusammenbauen der naechsten WarID
			warurl = wardetailurl % warID
			
			# Abfragen des Krieges
			try:
				data = getData(warurl)
				timeStarted = data['timeStarted']
				timeDeclared = data['timeDeclared']
				# Wenn der Krieg noch kein Ende hat
				if 'timeFinished'  in data:
					timeFinished = data['timeFinished']
				else:
					timeFinished = '2099-12-31 23:59:00'
				aggressorID = data['aggressor']['id']
				aggressorHref = data['aggressor']['href']
				aggressorShipsKilled = data['aggressor']['shipsKilled']
				defenderID = data['defender']['id']
				defenderHref = data['defender']['href']
				defenderShipsKilled = data['defender']['shipsKilled']

				if aggressorHref.find("corporations") == -1:
					# Alliance
					aggressorAllianceID = aggressorID
					aggressorCorporationID = "NULL"
				else:
					aggressorAllianceID = "NULL"
					aggressorCorporationID = aggressorID


        	               	if defenderHref.find("corporations") == -1:
               	                	# Alliance
	               	                 defenderAllianceID = defenderID
	                        	 defenderCorporationID = "NULL"
	                        else:
	                             	defenderAllianceID = "NULL"
	                                defenderCorporationID = defenderID

				sql = "INSERT INTO wars.wars (warid, aggressorCorporationID, aggressorAllianceID, defenderCorporationID, defenderAllianceID, timeDeclared, timeStarted, timeFinished, aggressorKills, defenderKills) VALUES ({0}, {1}, {2}, {3}, {4}, '{5}', '{6}', '{7}', {8}, {9} ) ON DUPLICATE KEY UPDATE timeFinished='{7}', aggressorKills={8}, defenderKills={9} ".format(warID, aggressorCorporationID, aggressorAllianceID, defenderCorporationID, defenderAllianceID, timeDeclared, timeStarted, timeFinished, aggressorShipsKilled, defenderShipsKilled)
                                print (sql)
				cursor.execute(sql)
				db.commit()

			except IOError:
				print " >>> IOError bei Krieg %s, beende Verarbeitung." % warID
				#quit()
			except:
        			print " >>> Fehler beim Lesen des Krieges %s" % warID
        			quit()
			

	cursor.close()
	db.close()


if __name__ == "__main__":
	main()
