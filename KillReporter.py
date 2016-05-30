#!/usr/bin/env python2.7
# encoding: utf-8

import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
import ConfigParser
from datetime import datetime, timedelta

from eveapi import eveapi
import zkb

# Konfiguration einlesen und Arbeitsvariablen bereitstellen
try:
	conf = ConfigParser.ConfigParser()
	conf.read(["init.ini", "init_local.ini"])

	cursor = None
	db = None

	db_schema = conf.get("GLOBALS","db_name")
	db_IP = conf.get("GLOBALS","db_host")
	db_user = conf.get("GLOBALS","db_user")
	db_pw = conf.get("GLOBALS","db_pw")
	db_port = int(conf.get("GLOBALS","db_port"))

	db_participants = conf.get("KILL_REPORTER","db_participants")
	db_fits = conf.get("KILL_REPORTER","db_fits")
except:
	print "Konnte Konfiguration nicht lesen"
	quit()

### Datenbank verbindung aufbauen
# Sollte eine Tablle nicht vorhanden sein, kann diese
# zur Laufzeit angelegt werden.
def db_init():
	global cursor,db
	db = MySQLdb.connect(host=db_IP, user=db_user, passwd=db_pw, port=db_port, db=db_schema)
	cursor = db.cursor()
	# StatusInfos. Deaktiviert fuer das Massengeschaeft
	#print "DB connection:\tGOOD"

def load_SQL(queryObj):
	progress = 0
	kills_obj = []
	latest_date = ""
	for zkb_return in queryObj:
		print "%s: %s\t%s" % (time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),latest_date,progress)
		for kill in zkb_return:
			kills_obj.append(kill)
			participants_cols = (
				"killID",
				"solarSystemID",
				"kill_time",
				"isVictim",
				"shipTypeID",
				"damage",
				"characterID",
				"characterName",
				"corporationID",
				"corporationName",
				"allianceID",
				"allianceName",
				"factionID",
				"factionName",
				"finalBlow",
				"weaponTypeID",
				"points",
				"totalValue")

			participants_sql = "INSERT INTO %s (%s) " % (db_participants,','.join(participants_cols))

			fit_sql = "INSERT INTO %s (killID,characterID,corporationID,allianceID,factionID,shipTypeID,\
				typeID,flag,qtyDropped,qtyDestroyed,singleton) " % db_fits

			killID = kill["killID"]
			solarSystemID = kill["solarSystemID"]
			killTime = kill["killTime"]
			try:
				victim_name = str(kill["victim"]["characterName"])
			except UnicodeEncodeError, e:
				victim_name = "DEFAULT CHARACTER NAME"
			try:
				victim_corp = str(kill["victim"]["corporationName"])
			except UnicodeEncodeError, e:
				victim_corp = "DEFAULT CORP NAME"
			try:
				victim_alliance = str(kill["victim"]["allianceName"])
			except UnicodeEncodeError, e:
				victim_alliance = "DEFAULT ALLIANCE NAME"
			try:
				victim_faction = kill["victim"]["factionName"]
			except KeyError:
				victim_faction = "NULL"

			victim_name = victim_name.replace("'",'\'\'')	#replace (') to avoid SQL errors
			victim_corp = victim_corp.replace("'",'\'\'')
			victim_alliance = victim_alliance.replace("'",'\'\'')
			victim_faction = victim_faction.replace("'",'\'\'')

			crest = kill["zkb"]["hash"]

			try:
				points = kill["zkb"]["points"]
				totalValue = kill["zkb"]["totalValue"]
			except KeyError:
				points = "NULL"
				totalValue = "NULL"
			victim_info = (
				killID,
				solarSystemID,
				"'%s'" % killTime,
				1,	#isVictim
				kill["victim"]["shipTypeID"],
				kill["victim"]["damageTaken"],
				kill["victim"]["characterID"],
				"'%s'" % victim_name,
				kill["victim"]["corporationID"],
				"'%s'" % victim_corp,
				kill["victim"]["allianceID"],
				"'%s'" % victim_alliance,
				kill["victim"]["factionID"],
				"'%s'" % victim_faction,
				"NULL",	#finalBlow
				"NULL",	#weaponTypeID
				points,
				totalValue
				)	#json.dumps(kill["items"]))	#stringify fit for storage (without fit db)

			info_str = ','.join(str(item) for item in victim_info)	#join only works on str
			info_str = info_str.rstrip(',')	#strip trailing comma
			victim_participants = "VALUES (%s) ON DUPLICATE KEY UPDATE killID=killID, characterID=characterID" % info_str
			#print "%s%s" % (participants_sql,victim_participants)
			#print participants_sql
			#print victim_participants
			cursor.execute("%s%s" % (participants_sql,victim_participants))
			db.commit()

			# Sicherstellen das der Kill auch ueber Crest abgeholt werden kann.
			crest_sql = "INSERT INTO KR_participantsHash (killID, cresthash) VALUES (%s, '%s') ON DUPLICATE KEY UPDATE killID=killID;" % (killID, crest)
			cursor.execute(crest_sql)
			db.commit()

			# Nun hier noch die CharDaten aktualisieren lassen.
			chars_sql = "INSERT INTO KR_characterUpdatesPrio (characterID) VALUES (%s) ON DUPLICATE KEY UPDATE characterID=characterID;" % (kill["victim"]["characterID"])
			try:
				cursor.execute("%s" % (chars_sql))
				db.commit()
			except:
				fehler = True

			killers_SQL = "%s VALUES " % participants_sql
			for killer in kill["attackers"]:
				try:
					killer_name = str(killer["characterName"])
				except UnicodeEncodeError, e:
					killer_name = "DEFAULT CHARACTER NAME"
				try:
					killer_corp = str(killer["corporationName"])
				except UnicodeEncodeError, e:
					killer_corp = "DEFAULT CORP NAME"
				try:
					killer_alliance = str(killer["allianceName"])
				except UnicodeEncodeError, e:
					killer_alliance = "DEFAULT ALLIANCE NAME"
				try:
					killer_faction = str(killer["factionName"])
				except KeyError:
					killer_faction = "NULL"

				killer_name = killer_name.replace("'",'\'\'')	#replace (') to avoid SQL errors
				killer_corp = killer_corp.replace("'",'\'\'')
				killer_alliance = killer_alliance.replace("'",'\'\'')
				killer_faction = killer_faction.replace("'",'\'\'')

				killer_info = (
					killID,
					solarSystemID,
					"'%s'" % killTime,
					0,	#isVictim
					killer["shipTypeID"],
					killer["damageDone"],
					killer["characterID"],
					"'%s'" % killer_name,
					killer["corporationID"],
					"'%s'" % killer_corp,
					killer["allianceID"],
					"'%s'" % killer_alliance,
					killer["factionID"],
					"'%s'" % killer_faction,
					killer["finalBlow"],
					killer["weaponTypeID"],
					"NULL",
					"NULL",
				)

				killer_str = ','.join(str(item) for item in killer_info)
				killer_str = killer_str.rstrip(',')
				killers_SQL = "%s\n (%s)," % (killers_SQL,killer_str)

			killers_SQL = killers_SQL.rstrip(',')
			#print killers_SQL
			killers_SQL = "%s ON DUPLICATE KEY UPDATE killID=killID, characterID=characterID" % killers_SQL
			#print killers_SQL

			cursor.execute(killers_SQL)
			db.commit()

			# Und hier die Charactere der Sieger in KR_characterUpdatesPrio uebertragen

			fits_SQL = "%s VALUES " % fit_sql
#			for item in kill["items"]:
#				fit_info = (
#					killID,
#					kill["victim"]["characterID"],
#					kill["victim"]["corporationID"],
#					kill["victim"]["allianceID"],
#					kill["victim"]["factionID"],
#					kill["victim"]["shipTypeID"],
#					item["typeID"],
#					item["flag"],
#					item["qtyDropped"],
#					item["qtyDestroyed"],
#					item["singleton"])
#
#				fit_str = ','.join(str(value) for value in fit_info)
#				fit_str = fit_str.rstrip(',')

				#would prefer not to have to do it item-by-item, but :update:
#				fit_str = "%s (%s) ON DUPLICATE KEY UPDATE killID=killID, characterID=characterID, qtyDropped=qtyDropped + %s, qtyDestroyed = qtyDestroyed + %s"\
#					% (fits_SQL,fit_str,item["qtyDropped"],item["qtyDestroyed"])

		#fits_SQL = fits_SQL.rstrip(',')
		#fits_SQL = "%s ON DUPLICATE KEY UPDATE killID=killID, characterID=characterID, qtyDropped+=" % fits_SQL
			latest_date = killTime
		# cursor.execute(fits_SQL)
		progress += len(zkb_return)
	return kills_obj

def main():
	db_init()

	# Auslesen der Uebergabeparameter fuer welchen Zeitraum die
	# Abfragen laufen sollen.
	try:
		startdate =  sys.argv[1]
		enddate =  sys.argv[2]
		enddateplusone = sys.argv[3]
 	except:
		# Bis auf weiteres keine Fehlerbehandlung
		startdate =  sys.argv[1]
		enddate =  sys.argv[2]
		enddateplusone = sys.argv[3]
		
	try:
		shipgroups = sys.argv[4]
		shipfilename = "shiplist.%s.json" % shipgroups
		#shipfilename = "toaster_shiplist.json"
	except:
		shipfilename = "toaster_shiplist.json"

	#build query
	# LatestKillID = letztes Datum
	# zkb.Query = Beginn des Auswertungszeitraumes
	# endTime = letztes Datum plus 1
	kills_obj=[]
	try:
		ship_groupIDs=json.load(open(shipfilename))
	except:
		quit()

	# Nun jeden Gruppeneintrag in der Definitionsdaten durchwandern
	for groupID,shipType in ship_groupIDs["groupID"].iteritems():
		print "%s: Fetching Group %s Start: %s End: %s" % (time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),shipType, startdate, enddate)
		latestKillID = zkb.fetchLatestKillID(enddateplusone)
		#print  "lastest: %s " % latestKillID
		groupQuery = zkb.Query(startdate)
		groupQuery.groupID(int(groupID))
		groupQuery.endTime(enddateplusone)
		groupQuery.beforeKillID(latestKillID)
		tmp_kills_obj = load_SQL(groupQuery)
		# Der Append koennte theoretisch auf schmalbruestigen
		# System zu einem Problem werden.
		kills_obj.append(tmp_kills_obj)

	# Nun jeden Einzeleintrag in der Definitionsdaten durchwandern
	for groupID,shipType in ship_groupIDs["shipID"].iteritems():
		print "%s: Fetching Ships %s Start: %s End: %s" % (time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),shipType, startdate, enddate)
		latestKillID = zkb.fetchLatestKillID(enddate)
		groupQuery = zkb.Query(startdate)
		groupQuery.groupID(int(groupID))
                #groupQuery.losses
                #groupQuery.solarSystemID(30000144)
		groupQuery.endTime(enddateplusone)
		groupQuery.beforeKillID(latestKillID)
		tmp_kills_obj = load_SQL(groupQuery)
		kills_obj.append(tmp_kills_obj)

if __name__ == "__main__":
	main()
