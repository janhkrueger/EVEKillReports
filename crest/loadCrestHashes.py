#!/usr/bin/env python2.7
# encoding: utf-8


import sys, gzip, StringIO, sys, math, os, getopt, time, json, socket
import urllib2
import psycopg2
import ConfigParser
import codecs
import time
import MySQLdb
from datetime import datetime
import urllib
from pprint import pprint


conf = ConfigParser.ConfigParser()
conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])

cursor = None
db = None

# set up the database connection
def db_init():
  global cursor,db
  db_schema = conf.get("GLOBALS","db_name")
  db_IP = conf.get("GLOBALS","db_host")
  db_user = conf.get("GLOBALS","db_user")
  db_pw = conf.get("GLOBALS","db_pw")
  db_port = int(conf.get("GLOBALS","db_port"))

  db = MySQLdb.connect(host=db_IP, user=db_user, passwd=db_pw, port=db_port, db=db_schema)
  cursor = db.cursor()


def main():
        # read default configs
  conf = ConfigParser.ConfigParser()
  conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])

        # read filename from command line
        killdate=sys.argv[1]
  db_init()

        # read json file
  with open(killdate) as data_file:
        data = json.load(data_file)
                # import every entry, do nothing if killID exists already
                for key, value in data.items():
                  sql = "INSERT INTO KR_participantsHash (killID, cresthash) VALUES (%s, '%s') ON DUPLICATE KEY UPDATE killID=killID;" % (key, value)
                  cursor.execute("%s" % (sql))
                  db.commit()

        # correctly close the db connection
  db.close()

if __name__ == "__main__":
  main()
