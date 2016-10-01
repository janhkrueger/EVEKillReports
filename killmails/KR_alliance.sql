-- ----------------------------
-- Table structure for KR_alliance
-- ----------------------------
DROP TABLE IF EXISTS KR_alliance;
CREATE TABLE KR_alliance (
  allianceID bigint(20) unsigned NOT NULL,
  allianceName text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (allianceID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED
/*!50100 PARTITION BY HASH (allianceID)
PARTITIONS 25 */;
