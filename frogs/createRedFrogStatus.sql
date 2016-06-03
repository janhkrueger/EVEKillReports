CREATE TABLE RedFrogStatus (
  lastUpdate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  nextUpdate timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  outstandingContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  inProgressContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  24HourContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  12HourContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  12to24HourContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  24to48HourContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  Over48HourContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  LastHourIssuedContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  LastHourAcceptedContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  LastHourCompletedContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  LastDayIssuedContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  LastDayAcceptedContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  LastDayCompletedContractTotal int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (lastUpdate),
  UNIQUE KEY nextUpdate (nextUpdate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
