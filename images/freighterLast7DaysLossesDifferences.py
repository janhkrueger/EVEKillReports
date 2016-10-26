#!/usr/bin/env python

"""
The new ticker code was designed to explicitly support user customized
ticking.  The documentation
http://matplotlib.org/matplotlib.ticker.html details this
process.  That code defines a lot of preset tickers but was primarily
designed to be user extensible.

In this example a user defined function is used to format the ticks in
millions of dollars on the y axis
"""
import numpy as np
import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import MySQLdb
import ConfigParser
from datetime import datetime, timedelta
import matplotlib
from matplotlib.ticker import FuncFormatter

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

# Frachterkills diese Woche holen
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

# Frachterkills letzte Woche holen
frachter_SQL = "SELECT * FROM Frachter_7_14"
cursor.execute(frachter_SQL)
rows = cursor.fetchall()

killslastweek = [0] * 5

for row in rows:
        if row[0] == 34328:
                killslastweek[0] = row[2]
        if row[0] == 20185:
                killslastweek[1] = row[2]
        if row[0] == 20189:
                killslastweek[2] = row[2]
        if row[0] == 20187:
                killslastweek[3] = row[2]
        if row[0] == 20183:
                killslastweek[4] = row[2]


# Kills der beiden Wochen gegenueber stellen

killssum = [0] * 5

if kills[0] >= killslastweek[0]: killssum[0] = kills[0] - killslastweek[0]
else: killssum[0] = (killslastweek[0] - kills[0]) * -1

if kills[1] >= killslastweek[1]: killssum[1] = kills[1] - killslastweek[1]
else: killssum[1] = (killslastweek[1] - kills[1]) * -1

if kills[2] >= killslastweek[2]: killssum[2] = kills[2] - killslastweek[2]
else: killssum[2] = (killslastweek[2] - kills[2]) * -1

if kills[3] >= killslastweek[3]: killssum[3] = kills[3] - killslastweek[3]
else: killssum[3] = (killslastweek[3] - kills[3]) * -1

if kills[4] >= killslastweek[4]: killssum[4] = kills[4] - killslastweek[4]
else: killssum[4] = (killslastweek[4] - kills[4]) * -1


x =     np.arange(5)

def bla(x, pos):
    'The two args are the value and tick position'
    return '%1.0f' % x

formatter = FuncFormatter(bla)

fig, ax = plt.subplots()
ax.yaxis.set_major_formatter(formatter)
plt.bar(x, killssum)

plt.xticks( x + 0.5,  ('Bowhead', 'Charon', 'Fenrir', 'Obelisk', 'Providence') )
plt.savefig('/var/www/html/janhkrueger.de/rasi/charts/freighterLast7DaysLossesDifferences.png', dpi = 75)
