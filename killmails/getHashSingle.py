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


workKillID = sys.argv[1]

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

	sql = "SELECT killID FROM KR_participantsHash WHERE killID= %s;"
        sql = sql % (workKillID)
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
				sql = "DELETE FROM KR_participantsOld WHERE killID=%s" % killid
				cursor.execute(sql)
                		db.commit()
				pass


	cursor.close()
	db.close()


if __name__ == "__main__":
	main()
