CREATE TABLE KR_participantsExpensiveLoss (
  killID bigint(20) NOT NULL COMMENT 'Die ID des Losses',
  totalValue decimal(32,2) NOT NULL COMMENT 'Der Gesamtwert des Verlustes',
  shipTypeID int(11) DEFAULT NULL,
  surveyDate datetime DEFAULT NULL,
  KEY idxKR_participantsExpensiveLoss (killID,totalValue)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=16;
