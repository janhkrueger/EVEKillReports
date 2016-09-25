CREATE TABLE KR_characterUpdates (
  characterID bigint(20) NOT NULL,
  characterName text COLLATE utf8mb4_unicode_ci,
  corporationID bigint(11) DEFAULT NULL,
  corporationName text COLLATE utf8mb4_unicode_ci,
  allianceID bigint(11) DEFAULT NULL,
  allianceName text COLLATE utf8mb4_unicode_ci,
  lastUpdate datetime DEFAULT NULL,
  PRIMARY KEY (characterID),
  KEY characterID (characterID,lastUpdate),
  KEY corpID (characterID,corporationID),
  KEY allianceID (characterID,allianceID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16;

CREATE TABLE KR_characterUpdatesPrio (
  characterID bigint(20) NOT NULL,
  PRIMARY KEY (characterID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16;

CREATE TABLE KR_characterUpdatesWork (
  characterID bigint(20) NOT NULL,
  PRIMARY KEY (characterID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16;
