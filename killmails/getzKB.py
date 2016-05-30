#!/usr/bin/env python2.7
# encoding: utf-8

import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
import ConfigParser
import codecs
from datetime import datetime
from elementtree.ElementTree import parse
from pprint import pprint
import xml.etree.ElementTree as ET
import requests


conf = ConfigParser.ConfigParser()
conf.read(["init.ini"])

cursor = None
db = None

def db_init():
	db_schema = conf.get("GLOBALS","db_name")
	db_IP = conf.get("GLOBALS","db_host")
	db_user = conf.get("GLOBALS","db_user")
	db_pw = conf.get("GLOBALS","db_pw")
	db_port = int(conf.get("GLOBALS","db_port"))

	global cursor,db
	db = MySQLdb.connect(host=db_IP, user=db_user, passwd=db_pw, port=db_port, db=db_schema)
	cursor = db.cursor()

def getData(url):
	request_headers = {
		"Accept":"application/json",
		"Accept-Encoding":conf.get("GLOBALS","loadencoding"),
		"Maintainer":"",
		"Mail":conf.get("GLOBALS","mail"),
		"Twitter":"",
		"User-Agent":"loadKillMails"
	}

	try:
		request = urllib2.Request(url, headers=request_headers)
        	opener = urllib2.build_opener()
        	raw_zip = opener.open(request)
        	dump_zip_stream = raw_zip.read()
        	dump_IOstream = StringIO.StringIO(dump_zip_stream)
        	zipper = gzip.GzipFile(fileobj=dump_IOstream)
		data = json.load(zipper)
	except urllib2.HTTPError:
		return "HTTP ERROR"
	except httplib.HTTPException:
		return "HTTP Exception"
	return data

def main():
	db_init()
	conf = ConfigParser.ConfigParser()
	conf.read(["init.ini", "init_local.ini"])
	jetzt =  str(datetime.now())

	#sql = "SELECT killID FROM KR_participantsHash WHERE (collected NOT IN (0,1) OR crestHash IS NULL) ORDER BY killID DESC LIMIT 10000;"
	#sql = "SELECT killID FROM KR_participantsHash WHERE killID=73;"
	#sql = "SELECT killID FROM KR_participantsHash WHERE killID IN (SELECT distinct killID FROM KR_participants PARTITION (p2014) GROUP BY killID, characterID, shipTypeID, damage, kill_time, corporationID, isVictim HAVING count(killID) > 1);"
	#sql = "SELECT killID FROM KR_participantsHash WHERE crestHash IS NULL AND killID IN (SELECT distinct killID FROM KR_participants PARTITION (p2013) ) ORDER BY killID DESC LIMIT 1000;"

        # CrestHash der noch zu sammelnden Schiffe ermitteln
	sql = "SELECT killID FROM KR_participantsHash WHERE (crestHash IS NULL OR collected = 3) AND killID IN (SELECT distinct killID FROM KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2015) ) ORDER BY killID DESC LIMIT 1000;"

        # CrestHash der PirateFaction BattleShips sammeln
        #sql = "select p.killID from KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2015, p2016) p, KR_participantsHash h where p.isVictim = 1 and p.shipTypeID IN (33472, 17736, 17918, 34151, 17738, 17920, 33820, 17740) AND (h.collected=3 OR h.crestHash IS NULL) AND p.killID = h.killID ORDER BY killID DESC LIMIT 1000;"

        # CrestHash der Interceptoren sammeln
        #sql = "select p.killID from KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2015, p2016) p, KR_participantsHash h where p.isVictim = 1 and p.shipTypeID IN (11202,11196,11176,11184,35779,11186,11178,11198,11200,33673) AND (h.collected=3 OR h.crestHash IS NULL) AND p.killID = h.killID ORDER BY killID DESC LIMIT 1000;"
	cursor.execute( sql)
	
        killmailurl = conf.get("ZKBSINGLE","base_query")

	rows = cursor.fetchall()
        for kill in rows:
		crest = 0
		# fehler = 99	
		killid = kill[0]

		# Zusammenbauen der URL der KillMail
		killmailurldetail = killmailurl % (killid)
		# Abfragen des Krieges
		try:
			data = getData(killmailurldetail)
			fehler = 0
			if data == "HTTP ERROR":
				raise ValueError('A very specific bad thing happened')
		except IOError:
			print " >>> IOError bei KillMail %s, beende Verarbeitung." % killid
			sql = "UPDATE KR_participantsHash SET collected = 8 WHERE killID={0} AND crestHash='{1}'".format(killid, cresthash)
                	cursor.execute(sql)
                	db.commit()
			fehler = 8
		except ValueError as err:
			fehler = 3
			print " >>> Hash moeglicherweise falsch?  %s" % killid
		except:
        		print " >>> Fehler beim Lesen der KillMail %s" % killid

		# print killid, lastKillID
		if (fehler == 0):

			# print killid

			try:
				crest = ( data[0]['zkb']['hash'] )
				sql = "UPDATE KR_participantsHash SET collected = 0, crestHash='{1}' WHERE killID={0}".format(killid, crest)
                		cursor.execute(sql)
                		db.commit()
			except (ValueError,IndexError):
				# print (killid)
				# print ("Fehler bei Kill: %s", killid)
				# 9 = kein Eintrag von zKillBoard gefundenn
                		#sql = "INSERT INTO KR_participantsHashSave VALUES (%s)" % killid
				#cursor.execute(sql)
                		#db.commit()
				sql = "DELETE FROM KR_participantsHash WHERE killID=%s" % killid
				cursor.execute(sql)
                		db.commit()
				sql = "DELETE FROM KR_participants WHERE killID=%s" % killid
				cursor.execute(sql)
                		db.commit()
				pass


	cursor.close()
	db.close()


if __name__ == "__main__":
	main()
