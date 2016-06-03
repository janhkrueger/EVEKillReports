CREATE TABLE KR_participantsCollected (
  collected int(10) unsigned NOT NULL,
  to_collect int(10) unsigned NOT NULL,
  surveyDate datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
