#!/usr/bin/env python2.7
# encoding: utf-8


import sys, StringIO, os, getopt, json
import psycopg2
import ConfigParser
from pprint import pprint

conf = 0


def db_init():
  global conf
  db_schema = conf.get("GLOBALSPSQL","edb_name")
  db_IP = conf.get("GLOBALSPSQL","edb_host")
  db_user = conf.get("GLOBALSPSQL","edb_user")
  db_pw = conf.get("GLOBALSPSQL","edb_pw")
  db_port = int(conf.get("GLOBALSPSQL","edb_port"))

  global cursor,db
  db = psycopg2.connect(database =db_schema, host=db_IP, user=db_user, password=db_pw) 
  cursor = db.cursor()

def move_file(file):
  sourcepath = "/var/games/KillReporter/killmails/killjson/imported/"+file
  destpath = "/var/games/KillReporter/killmails/killjson/importpsql/"+file
  os.rename(sourcepath, destpath)

def main():
  global conf
  conf = ConfigParser.ConfigParser()
  conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])
  db_init()

  # Read all *.txt Files 
  mypath = '//var//games//KillReporter//killmails//killjson//imported//'
  for file in os.listdir(mypath):
    if file.endswith(".json"):
      killid= os.path.splitext(os.path.basename(file))[0]

      # den alten Stand entfernen
      query = "DELETE FROM kills.killsjson WHERE killID =  {0} ".format(killid)
      cursor.execute(query) 
      db.commit()

      ### Datei importieren
      killfile = open(mypath+file, 'r').read()
      data = json.loads(killfile)

      cursor.execute("INSERT INTO kills.killsjson (killid, rawjson) VALUES (%s, %s)", (killid, json.dumps(data), ))
      db.commit()

      ### Verarbeitete Datei verschieben
      move_file(file)
  db.close()

if __name__ == "__main__":
  main()
