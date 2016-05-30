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


conf = ConfigParser.ConfigParser()
conf.read(["init.ini", "init_local.ini"])

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
		"User-Agent":"RASI load Frog status"
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

	jetzt =  str(datetime.now())

        frogstatusurl = conf.get("LOADFROGS","frogstatus")

	# Abfragen des Frogstatus
	try:
		data = getData(frogstatusurl)

		dlastUpdate = data['lastUpdate']
		dnextUpdate = data['nextUpdate']
		doutstandingContractTotal = data['outstandingContractTotal']
		dinProgressContractTotal = data['inProgressContractTotal']
		d24HourContractTotal = data['24HourContractTotal']
		d12HourContractTotal = data['12HourContractTotal']
		d12to24HourContractTotal = data['12to24HourContractTotal']
		d24to48HourContractTotal = data['24to48HourContractTotal']	
		dOver48HourContractTotal = data['Over48HourContractTotal']
		dLastHourIssuedContractTotal = data['LastHourIssuedContractTotal']
		dLastHourAcceptedContractTotal = data['LastHourAcceptedContractTotal']
		dLastHourCompletedContractTotal = data['LastHourCompletedContractTotal']
		dLastDayIssuedContractTotal = data['LastDayIssuedContractTotal']
		dLastDayAcceptedContractTotal = data['LastDayAcceptedContractTotal']
		dLastDayCompletedContractTotal = data['LastDayCompletedContractTotal']


		sql = "INSERT INTO RedFrogStatus VALUES ('{0}','{1}',{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14})".format(dlastUpdate, dnextUpdate, doutstandingContractTotal, dinProgressContractTotal, d24HourContractTotal, d12HourContractTotal, d12to24HourContractTotal, d24to48HourContractTotal, dOver48HourContractTotal, dLastHourIssuedContractTotal, dLastHourAcceptedContractTotal, dLastHourCompletedContractTotal, dLastDayIssuedContractTotal, dLastDayAcceptedContractTotal, dLastDayCompletedContractTotal);
		#print (sql)
		cursor.execute(sql)
		db.commit()

	except IOError:
		print " >>> IOError, kann Status nicht lesen."
		quit()
	except:
		print " >>> Konnte Datensatz nicht einfuegen"
		quit()
			

	cursor.close()
	db.close()


if __name__ == "__main__":
	main()
