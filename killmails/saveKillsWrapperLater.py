#!/usr/bin/env python2.7
# encoding: utf-8


import sys, StringIO, os, getopt, json
import MySQLdb
import ConfigParser
from pprint import pprint

conf = 0


def db_init():
  global conf
  db_schema = conf.get("GLOBALS","db_name")
  db_IP = conf.get("GLOBALS","db_host")
  db_user = conf.get("GLOBALS","db_user")
  db_pw = conf.get("GLOBALS","db_pw")
  db_port = int(conf.get("GLOBALS","db_port"))

  global cursor,db
  db = MySQLdb.connect(host=db_IP, user=db_user, passwd=db_pw, port=db_port, db=db_schema)
  cursor = db.cursor()

def move_file(file):
  sourcepath = "/var/games/KillReporter/killmails/killjson/later/"+file
  destpath = "/var/games/KillReporter/killmails/killjson/imported/"+file
  os.rename(sourcepath, destpath)

def move_error(file):
  sourcepath = "/var/games/KillReporter/killmails/killjson/later/"+file
  destpath = "/var/games/KillReporter/killmails/killjson/errors/"+file
  os.rename(sourcepath, destpath)

def main():
  global conf
  conf = ConfigParser.ConfigParser()
  conf.read(["/var/games/KillReporter/init.ini", "init_local.ini"])
  db_init()

  # Read all *.txt Files 
  mypath = '//var//games//KillReporter//killmails//killjson//later//'
  for file in os.listdir(mypath):
    if file.endswith(".json"):
      killid= os.path.splitext(os.path.basename(file))[0]

      # print (killid)

      # den alten Stand entfernen
      query = "DELETE FROM KR_participants WHERE killID =  {0} ".format(killid)
      cursor.execute(query) 
      db.commit()

      data=""
      ### Datei imprtieren
      try:
        killfile = open(mypath+file, 'r').read()
        data = json.loads(killfile)
        attackerCount = data['attackerCount_str']
        #print (jsonkill)
        attackerCount = data['attackerCount_str']
        solarSystem = data['solarSystem']['id']
        killTime = data['killTime']

        # Victim Specific
        damageTaken = data['victim']['damageTaken_str']
        shipType = data['victim']['shipType']['id']

        # Victim Char
        if 'character' in data['victim']:
          characterID = data['victim']['character']['id']
          characterName = data['victim']['character']['name'].replace("'",'\'\'').encode('utf-8')
          # Store the char
          sql = "INSERT INTO KR_character (characterID, characterName) VALUES ({0}, '{1}') ON DUPLICATE KEY UPDATE characterID={0} ".format(characterID, characterName)
          cursor.execute(sql)
          db.commit()
        else:
          characterID = 0

        # Victim Corp
        if 'corporation'  in data['victim']:
          corporationID = data['victim']['corporation']['id']
          corporationName = data['victim']['corporation']['name'].replace("'",'\'\'').encode('utf-8')
          # Store the corp
          sql = "INSERT INTO KR_corporation (corporationID, corporationName) VALUES ({0}, '{1}') ON DUPLICATE KEY UPDATE corporationID={0} ".format(corporationID, corporationName)
          cursor.execute(sql)
          db.commit()
        else:
          corporationID = 0

        # Victim Alliance
        if 'alliance' in data['victim']:
          allianceID = data['victim']['alliance']['id']
          allianceName = data['victim']['alliance']['name'].replace("'",'\'\'').encode('utf-8')
          # Store the alliance
          sql = "INSERT INTO KR_alliance (allianceID, allianceName) VALUES ({0}, '{1}') ON DUPLICATE KEY UPDATE allianceID={0} ".format(allianceID, allianceName)
          cursor.execute(sql)
          db.commit()
        else:
          allianceID = 0

        # Victim Faction
        if 'faction' in data['victim']:
          factionID = data['victim']['faction']['id']
        else:
          factionID = 0

        if 'finalBlow' in data['victim']:
          finalBlow = 1
        else:
          finalBlow = 0

        # Save the Victim
        query = "INSERT INTO KR_participants (killID, solarSystemID, kill_time, isVictim, shipTypeID, damage, characterID, corporationID, allianceID, factionID,  finalBlow, weaponTypeID) VALUES ({0}, {1}, '{2}', {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}) ON DUPLICATE KEY UPDATE killid={0}, characterID={6} ".format(killid, solarSystem, killTime, 1, shipType, damageTaken, characterID, corporationID, allianceID,  factionID, finalBlow, 'NULL' )        
        cursor.execute(query)
        db.commit()

        # All Attackers
        for att in data['attackers']:
          attCorporationID = 0
          attAllianceID = 0
          attWeaponTypeID = 'NULL'
          attCharacterID = 0
          finalBlow = 1
          attShipType = 0
          attdamageDone = 0
 
          # Attacker Char
          if 'character' in att:
            attCharacterID = att['character']['id']
            attCharacterName =  att['character']['name'].replace("'",'\'\'').encode('utf-8')
            # Store the char
            sql = "INSERT INTO KR_character (characterID, characterName) VALUES ({0}, '{1}') ON DUPLICATE KEY UPDATE characterID={0} ".format(attCharacterID, attCharacterName)
            cursor.execute(sql)
            db.commit()
          else:
            attcharacterID = 0
 
          # Attacker Corp
          if 'corporation' in att:
            attCorporationID = att['corporation']['id']
            attCorporationName = att['corporation']['name'].replace("'",'\'\'').encode('utf-8')
            # Store the corp
            sql = "INSERT INTO KR_corporation (corporationID, corporationName) VALUES ({0}, '{1}') ON DUPLICATE KEY UPDATE corporationID={0} ".format(attCorporationID, attCorporationName)
            cursor.execute(sql)
            db.commit()
          else:
            attCorporationID = 0

          # Attacker Alliance
          if 'alliance' in att:
            attAllianceID = att['alliance']['id']
            attAllianceName = att['alliance']['name'].replace("'",'\'\'').encode('utf-8')
            # store the alianceName
            sql = "INSERT INTO KR_alliance (allianceID, allianceName) VALUES ({0}, '{1}') ON DUPLICATE KEY UPDATE allianceID={0} ".format(attAllianceID, attAllianceName)
            cursor.execute(sql)
            db.commit()
          else:
            attAllianceID = 0

          # Victim Faction
          if 'faction' in att:
            attfactionID = att['faction']['id']
          else:
            attfactionID = 0

          # Attacker ShipType
          if 'shipType' in att:
            attShipType = att['shipType']['id']
          else:
            attShipType = 0

          attdamageDone = att['damageDone_str']
        
          if att['finalBlow'] == False:
            finalBlow = 0
          else:
            finalBlow = 1

          if 'weaponType' in att:
            attWeaponTypeID = att['weaponType']['id']
          else:
            attWeaponTypeID = 'NULL'

          # Save the Attacker
          query = "INSERT INTO KR_participants (killID, solarSystemID, kill_time, isVictim, shipTypeID, damage, characterID, corporationID, allianceID, factionID,  finalBlow, weaponTypeID) VALUES ({0}, {1}, '{2}', {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}) ON DUPLICATE KEY UPDATE killid={0}, characterID={6} ".format(killid, solarSystem, killTime, 0, attShipType, attdamageDone, attCharacterID, attCorporationID, attAllianceID,  attfactionID, finalBlow, attWeaponTypeID )
          cursor.execute(query)
          db.commit()

        # Markiere Kill als erledigt
        sql = "UPDATE KR_participantsHash SET collected = 1 WHERE killID={0}".format(killid)
        cursor.execute(sql)
        db.commit()

        ### Verarbeitete Datei verschieben
        move_file(file)
      except:
        # Markiere Kill als erledigt
        # print (killid)
        sql = "UPDATE KR_participantsHash SET collected = 0 WHERE killID={0}".format(killid)
        cursor.execute(sql)
        db.commit()
        move_error(file)
     
  db.close()

if __name__ == "__main__":
  main()
