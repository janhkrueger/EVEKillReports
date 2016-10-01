DROP TABLE IF EXISTS KR_participants;
CREATE TABLE KR_participants (
  killID int(32) NOT NULL,
  solarSystemID int(16) NOT NULL,
  kill_time datetime NOT NULL,
  isVictim tinyint(1) NOT NULL,
  shipTypeID int(8) NOT NULL DEFAULT '0',
  damage int(8) NOT NULL DEFAULT '0',
  characterID int(16) NOT NULL DEFAULT '0',
  characterName text COLLATE utf8mb4_unicode_ci,
  corporationID int(16) NOT NULL DEFAULT '0',
  corporationName text COLLATE utf8mb4_unicode_ci,
  allianceID int(16) NOT NULL DEFAULT '0',
  allianceName text COLLATE utf8mb4_unicode_ci,
  factionID int(16) NOT NULL DEFAULT '0',
  finalBlow tinyint(1) DEFAULT NULL,
  weaponTypeID int(8) DEFAULT NULL,
  PRIMARY KEY (killID,characterID,shipTypeID,damage,kill_time,corporationID),
  KEY idxIsVictim (isVictim),
  KEY idxFinalBlow (finalBlow),
  KEY idxSolarSystem (solarSystemID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16
/*!50100 PARTITION BY RANGE (YEAR(kill_time))
(PARTITION p2005 VALUES LESS THAN (2006) ENGINE = InnoDB,
 PARTITION p2006 VALUES LESS THAN (2007) ENGINE = InnoDB,
 PARTITION p2007 VALUES LESS THAN (2008) ENGINE = InnoDB,
 PARTITION p2008 VALUES LESS THAN (2009) ENGINE = InnoDB,
 PARTITION p2009 VALUES LESS THAN (2010) ENGINE = InnoDB,
 PARTITION p2010 VALUES LESS THAN (2011) ENGINE = InnoDB,
 PARTITION p2011 VALUES LESS THAN (2012) ENGINE = InnoDB,
 PARTITION p2012 VALUES LESS THAN (2013) ENGINE = InnoDB,
 PARTITION p2013 VALUES LESS THAN (2014) ENGINE = InnoDB,
 PARTITION p2014 VALUES LESS THAN (2015) ENGINE = InnoDB,
 PARTITION p2015 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION p2016 VALUES LESS THAN (2017) ENGINE = InnoDB,
 PARTITION p2017 VALUES LESS THAN (2018) ENGINE = InnoDB,
 PARTITION p2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION p2019 VALUES LESS THAN (2020) ENGINE = InnoDB) */;
