CREATE TABLE KR_wars (
  warID bigint(20) NOT NULL,
  aggressorCorporationID bigint(20) DEFAULT NULL,
  aggressorAllianceID bigint(20) DEFAULT NULL,
  aggressorKills bigint(20) DEFAULT NULL,
  defenderCorporationID bigint(20) DEFAULT NULL,
  defenderAllianceID bigint(20) DEFAULT NULL,
  defenderKills bigint(20) DEFAULT NULL,
  timeDeclared datetime NOT NULL,
  timeStarted datetime NOT NULL,
  timeFinished datetime DEFAULT NULL,
  timeChecked datetime DEFAULT '2099-12-31 23:59:00',
  PRIMARY KEY (warID,timeDeclared),
  KEY pkWarID (warID),
  KEY idxStartedEnded (timeStarted,timeFinished),
  KEY idxWarAggressor (aggressorCorporationID,aggressorAllianceID),
  KEY idxWarDefender (defenderCorporationID,defenderAllianceID),
  KEY idxWarStart (timeStarted) USING BTREE,
  KEY idxWarDeclared (timeDeclared)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16 COMMENT='wars imported via CREST.'
/*!50100 PARTITION BY RANGE (YEAR(timeDeclared))
(PARTITION warsP2003 VALUES LESS THAN (2003) ENGINE = InnoDB,
 PARTITION warsP2004 VALUES LESS THAN (2004) ENGINE = InnoDB,
 PARTITION warsP2005 VALUES LESS THAN (2005) ENGINE = InnoDB,
 PARTITION warsP2006 VALUES LESS THAN (2006) ENGINE = InnoDB,
 PARTITION warsP2007 VALUES LESS THAN (2007) ENGINE = InnoDB,
 PARTITION warsP2008 VALUES LESS THAN (2008) ENGINE = InnoDB,
 PARTITION warsP2009 VALUES LESS THAN (2009) ENGINE = InnoDB,
 PARTITION warsP2010 VALUES LESS THAN (2010) ENGINE = InnoDB,
 PARTITION warsP2011 VALUES LESS THAN (2011) ENGINE = InnoDB,
 PARTITION warsP2012 VALUES LESS THAN (2012) ENGINE = InnoDB,
 PARTITION warsP2013 VALUES LESS THAN (2013) ENGINE = InnoDB,
 PARTITION warsP2014 VALUES LESS THAN (2014) ENGINE = InnoDB,
 PARTITION warsP2015 VALUES LESS THAN (2015) ENGINE = InnoDB,
 PARTITION warsP2016 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION warsP2017 VALUES LESS THAN (2017) ENGINE = InnoDB) */;