CREATE TABLE KR_participantsHash (
  killID bigint(20) NOT NULL,
  crestHash char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  collected int(8) DEFAULT '0',
  PRIMARY KEY (killID),
  UNIQUE KEY killID_2 (killID,collected) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16
/*!50100 PARTITION BY HASH (killID)
PARTITIONS 25 */;
