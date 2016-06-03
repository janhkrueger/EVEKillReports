CREATE TABLE KR_remarkableKills (
  killID bigint(20) NOT NULL,
  comment longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (killID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16 COMMENT='Special kills I want to remember easily.';
