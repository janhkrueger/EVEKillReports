#!/usr/bin/env python2.7
# encoding: utf-8


import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
import ConfigParser
import codecs
from datetime import datetime, timedelta
import urllib
from elementtree.ElementTree import parse

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

db_chars = conf.get("KILL_REPORTER","db_chars")
db_maxrequests = conf.get("KILL_REPORTER","db_maxrequests")
db_maxrequests = 10

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

	# Temporaere Tabelle fuellen
	sql='DELETE FROM KR_characterUpdatesWork'
	cursor.execute(sql)

	sql='SELECT characterID FROM KR_characterUpdatesPrio ORDER BY characterID ASC limit 0,%s' % (db_maxrequests)
	cursor.execute(sql)
	# Nun in KR_characterUpdatesWork einfuegen
	rows = cursor.fetchall()
	for row in rows:
		charToWork = row[0]
		chars_sql = "INSERT INTO KR_characterUpdatesWork (characterID) VALUES ({0}) ON DUPLICATE KEY UPDATE characterID={0}".format(charToWork)
		cursor.execute("%s" % (chars_sql))
		db.commit()

	##### Nun die Chars die noch nicht abgefragt wurden
	sql='SELECT characterID FROM %s WHERE lastUpdate IS NULL ORDER BY characterID DESC limit 0,%s' % (db_chars, db_maxrequests)
	cursor.execute(sql)
	rows = cursor.fetchall()
	for row in rows:
		charToWork = row[0]
		chars_sql = "INSERT INTO KR_characterUpdatesWork (characterID) VALUES ({0}) ON DUPLICATE KEY UPDATE characterID={0}".format(charToWork)  
		try:
			cursor.execute("%s" % (chars_sql))
			db.commit()
		except:
			fehler = True

	##### Nun die Chars aelter 30 Tage		
	sql='SELECT characterID FROM %s WHERE lastUpdate IS NULL OR lastUpdate<= NOW()-INTERVAL 30 DAY ORDER BY characterID DESC limit 0,%s' % (db_chars, db_maxrequests)
	cursor.execute(sql)
	rows = cursor.fetchall()
	for row in rows:
		charToWork = row[0]
		chars_sql = "INSERT INTO KR_characterUpdatesWork (characterID) VALUES ({0}) ON DUPLICATE KEY UPDATE characterID={0}".format(charToWork)  
		try:
			cursor.execute("%s" % (chars_sql))
			db.commit()
		except:
			fehler = True
	##### Ende Temporaere Tabelle


	# Nun selectieren welche Chars bearbeitet werden sollen
	sql='SELECT characterID FROM KR_characterUpdatesWork limit 0,%s' % (db_maxrequests)
	cursor.execute(sql)
	rows = cursor.fetchall()
	for row in rows:
		charToWork = row[0]

		# CharBlatt einlesen
		CHAR_URL = 'https://api.eveonline.com/eve/CharacterInfo.xml.aspx?characterID=%s' % (charToWork)
		print CHAR_URL
               	content = unicode(CHAR_URL.strip(codecs.BOM_UTF8), 'utf-8')
		tree = ET.parse(urllib.urlopen(content))
		root = tree.getroot()
	
		fehler = None


	
		try:
			#if ( root[1][7].tag == "corporationID" ):
			if  ( root[1].text == "Invalid characterID."):
				sql='DELETE FROM KR_characterUpdatesPrio WHERE characterID=%s' % (charToWork)
				cursor.execute(sql)
				db.commit()

				sql='DELETE FROM KR_characterUpdatesWork WHERE characterID=%s' % (charToWork)
				cursor.execute(sql)
				db.commit()

				sys.exit()
		except:
			sys.exit()
			
		print ("FOO")
		# Relevante Werte auslesen
		try:
			charID = root[1][0].text
			contentName = root[1][1].text.encode('utf-8')
                        charName = db.escape(contentName)
			#print charName
			corpID = root[1][7].text
			corpName = root[1][8].text
			# print corpName
			if ( root[1][7].tag == "corporationID" ):
				corpID = root[1][7].text
                                contentCorp = root[1][8].text.encode('utf-8')
				corpName = db.escape(contentCorp)
		 	else:
				corpID = "NULL"
				corpName = "NULL"
	
			# Pruefen ob es ein Allianztag gibt, wenn nein Werte auf NULL setzen
			if ( root[1][10].tag == "allianceID" ):
				allianceID = root[1][10].text
                                contentAlliance = root[1][11].text.encode('utf-8')
				allianceName = db.escape(contentAlliance)
			else:
				allianceID = "NULL"
				allianceName = "NULL"
	
		except IndexError:
			fehler = True
	
		# Routine wenn kein Char gefunden wurde
		if (fehler):
			# Hier das lastUpdate aktualisieren damit der Char das nächste Mal nicht angefasst wird.
			markCharSQL = "UPDATE KR_characterUpdates SET lastUpdate='2099-01-01' WHERE characterID = %s"% (charToWork)
			cursor.execute("%s" % (markCharSQL))
			db.commit()
		else:
			if (corpName == "NULL"):
		 		corpName = "'NULL'"
	
			if (allianceName == "NULL"):
				allianceName = "NULL"
			
			# Character einfuegen oder aktualiseren
			chars_sql = "INSERT INTO %s (characterID, characterName, corporationID, corporationName, allianceID, allianceName, lastUpdate) VALUES (%s, %s, %s, %s, %s, %s, now() )" % (db_chars, charID, charName, corpID, corpName, allianceID, allianceName)
			victim_participants = " ON DUPLICATE KEY UPDATE characterID=%s, characterName=%s, corporationID=%s, corporationName=%s, allianceID=%s, allianceName=%s, lastUpdate=now() " % (charID, charName, corpID, corpName, allianceID, allianceName)
			# print "%s%s" % (chars_sql,victim_participants)
		
			cursor.execute("%s%s" % (chars_sql, victim_participants))
			db.commit()
			
			# Nun den Char aus der Prioliste entfernen
			sql='DELETE FROM KR_characterUpdatesPrio WHERE characterID=%s' % (charToWork)
			cursor.execute(sql)
			db.commit()

			# Nun den Char aus der Arbeitsliste entfernen
			sql='DELETE FROM KR_characterUpdatesWork WHERE characterID=%s' % (charToWork)
			cursor.execute(sql)
			db.commit()
			
	db.close()

if __name__ == "__main__":
	main()
