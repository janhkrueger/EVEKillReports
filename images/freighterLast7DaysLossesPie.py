#!/usr/bin/env python2.7
# encoding: utf-8

import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
import ConfigParser
from datetime import datetime, timedelta
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

db_name='JHK_rasi'
db_host='localhost'
db_user='jhk_rasi'
db_pw='aina2412'
db_port=3306

def db_init():
        global cursor,db
        db = MySQLdb.connect(host=db_host, user=db_user, passwd=db_pw, port=db_port, db=db_name)
        cursor = db.cursor()

db_init()

frachter_SQL = "SELECT * FROM Frachter_0_7"
cursor.execute(frachter_SQL)
rows = cursor.fetchall()

kills = [0] * 5

for row in rows:
	if row[0] == 34328:
		kills[0] = row[2]
	if row[0] == 20185:
		kills[1] = row[2]
	if row[0] == 20189:
		kills[2] = row[2]
	if row[0] == 20187:
		kills[3] = row[2]
	if row[0] == 20183:
		kills[4] = row[2]


grundwert = sum(kills)

bowhead = float(kills[0]) / (float(grundwert) / 100 )
charon = float(kills[1]) / (float(grundwert) / 100 )
fenrir = float(kills[2]) / (float(grundwert) / 100 )
obelisk = float(kills[3]) / (float(grundwert) / 100 )
providence = float(kills[4]) / (float(grundwert) / 100 )

# The slices will be ordered and plotted counter-clockwise.
labels = 'Bowhead '+str(kills[0]), 'Charon '+str(kills[1]), 'Fenrir '+str(kills[2]), 'Obelisk '+str(kills[3]), 'Providence '+str(kills[4])

sizes = [bowhead, charon, fenrir, obelisk, providence]
colors = ['grey', 'lightskyblue', 'lightcoral', 'lightgreen', 'gold']
explode = (0, 0.1, 0, 0, 0) # only "explode" the 2nd slice (i.e. 'Hogs')

plt.pie(sizes, explode=explode, labels=labels, colors=colors,
        autopct='%1.1f%%', shadow=False, startangle=90)
# Set aspect ratio to be equal so that pie is drawn as a circle.
plt.axis('equal')

#plt.figure( figsize=(20,10) )
#plt.title("Frachter Kills 7 Days")
plt.savefig('/var/www/html/janhkrueger.de/rasi/charts/freighterLast7DaysLossesPie.png', dpi = 75)

if db:
	db.close()
