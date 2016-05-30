#!/bin/bash


# invTypes
wget https://www.fuzzwork.co.uk/dump/latest/invTypes.sql.bz2
bunzip2 invTypes.sql.bz2
mysql -u -p  < invTypes.sql
mysql  -N -u -p -e "ALTER TABLE invTypes CHANGE typeName typeName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER groupID, CHANGE description description longtext COLLATE 'utf8mb4_unicode_ci' NULL AFTER typeName, COLLATE 'utf8mb4_unicode_ci';"
rm invTypes.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invTypes

# invGroups
wget https://www.fuzzwork.co.uk/dump/latest/invGroups.sql.bz2
bunzip2 invGroups.sql.bz2
mysql -u -p  < invGroups.sql
mysql  -N -u -p -e "ALTER TABLE invGroups CHANGE groupName groupName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER categoryID, COLLATE 'utf8mb4_unicode_ci';"
rm invGroups.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invGroups

# invCategories
wget https://www.fuzzwork.co.uk/dump/latest/invCategories.sql.bz2
bunzip2 invCategories.sql.bz2
mysql -u -p  < invCategories.sql
mysql  -N -u -p -e "ALTER TABLE invCategories CHANGE categoryName categoryName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER categoryID, COLLATE 'utf8mb4_unicode_ci';"
rm invCategories.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invCategories

# invMetaGroups
wget https://www.fuzzwork.co.uk/dump/latest/invMetaGroups.sql.bz2
bunzip2 invMetaGroups.sql.bz2
mysql -u -p  < invMetaGroups.sql
mysql  -N -u -p -e "ALTER TABLE invMetaGroups CHANGE metaGroupName metaGroupName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER metaGroupID, CHANGE description description varchar(1000) COLLATE 'utf8mb4_unicode_ci' NULL AFTER metaGroupName, COLLATE 'utf8mb4_unicode_ci';"
rm invMetaGroups.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invMetaGroups

# invMetaTypes
wget https://www.fuzzwork.co.uk/dump/latest/invMetaTypes.sql.bz2
bunzip2 invMetaTypes.sql.bz2
mysql -u -p  < invMetaTypes.sql
mysql  -N -u -p -e "ALTER TABLE invMetaTypes COLLATE 'utf8mb4_unicode_ci';"
rm invMetaTypes.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invMetaTypes

# invPositions
wget https://www.fuzzwork.co.uk/dump/latest/invPositions.sql.bz2
bunzip2 invPositions.sql.bz2
mysql -u -p  < invPositions.sql
mysql  -N -u -p -e "ALTER TABLE invPositions COLLATE 'utf8mb4_unicode_ci';"
rm invPositions.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invPositions

# invItems
wget https://www.fuzzwork.co.uk/dump/latest/invItems.sql.bz2
bunzip2 invItems.sql.bz2
mysql -u -p  < invItems.sql
mysql  -N -u -p -e "ALTER TABLE invItems COLLATE 'utf8mb4_unicode_ci';"
rm invItems.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invItems

# invMarketGroups
wget https://www.fuzzwork.co.uk/dump/latest/invMarketGroups.sql.bz2
bunzip2 invMarketGroups.sql.bz2
mysql -u -p  < invMarketGroups.sql
mysql  -N -u -p -e "ALTER TABLE invMarketGroups CHANGE marketGroupName marketGroupName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER parentGroupID, CHANGE description description varchar(3000) COLLATE 'utf8mb4_unicode_ci' NULL AFTER marketGroupName, COLLATE 'utf8mb4_unicode_ci';"
rm invMarketGroups.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invMarketGroups

# invNames
wget https://www.fuzzwork.co.uk/dump/latest/invNames.sql.bz2
bunzip2 invNames.sql.bz2
mysql -u -p  < invNames.sql
mysql  -N -u -p -e "ALTER TABLE invNames  CHANGE itemName itemName varchar(200) COLLATE 'utf8mb4_unicode_ci' NOT NULL AFTER itemID, COLLATE 'utf8mb4_unicode_ci';"
rm invNames.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables invNames

# mapSolarSystems
wget https://www.fuzzwork.co.uk/dump/latest/mapSolarSystems.sql.bz2
bunzip2 mapSolarSystems.sql.bz2
mysql -u -p  < mapSolarSystems.sql
mysql  -N -u -p -e "ALTER TABLE mapSolarSystems CHANGE solarSystemName solarSystemName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER solarSystemID, CHANGE securityClass securityClass varchar(2) COLLATE 'utf8mb4_unicode_ci' NULL AFTER sunTypeID, COLLATE 'utf8mb4_unicode_ci';"
rm mapSolarSystems.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapSolarSystems

#chrFactions
wget https://www.fuzzwork.co.uk/dump/latest/chrFactions.sql.bz2
bunzip2 chrFactions.sql.bz2
mysql -u -p  < chrFactions.sql
mysql  -N -u -p -e "ALTER TABLE chrFactions CHANGE factionName factionName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER factionID, CHANGE description description varchar(1000) COLLATE 'utf8mb4_unicode_ci' NULL AFTER factionName, COLLATE 'utf8mb4_unicode_ci';"
rm chrFactions.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables chrFactions

# mapUniverse
wget https://www.fuzzwork.co.uk/dump/latest/mapUniverse.sql.bz2
bunzip2 mapUniverse.sql.bz2
mysql -u -p  < mapUniverse.sql
mysql  -N -u -p -e "ALTER TABLE mapUniverse CHANGE universeName universeName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER universeID, COLLATE 'utf8mb4_unicode_ci';"
rm mapUniverse.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapUniverse

# mapCelestialStatistics
wget https://www.fuzzwork.co.uk/dump/latest/mapCelestialStatistics.sql.bz2
bunzip2 mapCelestialStatistics.sql.bz2
mysql -u -p  < mapCelestialStatistics.sql
mysql  -N -u -p -e "ALTER TABLE mapCelestialStatistics CHANGE spectralClass spectralClass varchar(10) COLLATE 'utf8mb4_unicode_ci' NULL AFTER temperature, COLLATE 'utf8mb4_unicode_ci';"
rm mapCelestialStatistics.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapCelestialStatistics

# mapConstellationJumps
wget https://www.fuzzwork.co.uk/dump/latest/mapConstellationJumps.sql.bz2
bunzip2 mapConstellationJumps.sql.bz2
mysql -u -p  < mapConstellationJumps.sql
mysql  -N -u -p -e "ALTER TABLE mapConstellationJumps COLLATE 'utf8mb4_unicode_ci';"
rm mapConstellationJumps.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapConstellationJumps

# mapConstellations
wget https://www.fuzzwork.co.uk/dump/latest/mapConstellations.sql.bz2
bunzip2 mapConstellations.sql.bz2
mysql -u -p  < mapConstellations.sql
mysql  -N -u -p -e "ALTER TABLE mapConstellations CHANGE constellationName constellationName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER constellationID, COLLATE 'utf8mb4_unicode_ci';"
rm mapConstellations.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapConstellations

# mapDenormalize
wget https://www.fuzzwork.co.uk/dump/latest/mapDenormalize.sql.bz2
bunzip2 mapDenormalize.sql.bz2
mysql -u -p  < mapDenormalize.sql
mysql  -N -u -p -e "ALTER TABLE mapDenormalize CHANGE itemName itemName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER radius, COLLATE 'utf8mb4_unicode_ci';"
rm mapDenormalize.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapDenormalize

# mapJumps
wget https://www.fuzzwork.co.uk/dump/latest/mapJumps.sql.bz2
bunzip2 mapJumps.sql.bz2
mysql -u -p  < mapJumps.sql
mysql  -N -u -p -e "ALTER TABLE mapJumps COLLATE 'utf8mb4_unicode_ci';"
rm mapJumps.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapJumps

# mapLandmarks
wget https://www.fuzzwork.co.uk/dump/latest/mapLandmarks.sql.bz2
bunzip2 mapLandmarks.sql.bz2
mysql -u -p  < mapLandmarks.sql
mysql  -N -u -p -e "ALTER TABLE mapLandmarks CHANGE landmarkName landmarkName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER landmarkID, CHANGE description description longtext COLLATE 'utf8mb4_unicode_ci' NULL AFTER landmarkName, COLLATE 'utf8mb4_unicode_ci';"
rm mapLandmarks.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapLandmarks

# mapLocationScenes
wget https://www.fuzzwork.co.uk/dump/latest/mapLocationScenes.sql.bz2
bunzip2 mapLocationScenes.sql.bz2
mysql -u -p  < mapLocationScenes.sql
mysql  -N -u -p -e "ALTER TABLE mapLocationScenes COLLATE 'utf8mb4_unicode_ci';"
rm mapLocationScenes.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapLocationScenes

# mapLocationWormholeClasses
wget https://www.fuzzwork.co.uk/dump/latest/mapLocationWormholeClasses.sql.bz2
bunzip2 mapLocationWormholeClasses.sql.bz2
mysql -u -p  < mapLocationWormholeClasses.sql
mysql  -N -u -p -e "ALTER TABLE mapLocationWormholeClasses COLLATE 'utf8mb4_unicode_ci';"
rm mapLocationWormholeClasses.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapLocationWormholeClasses

# mapRegionJumps
wget https://www.fuzzwork.co.uk/dump/latest/mapRegionJumps.sql.bz2
bunzip2 mapRegionJumps.sql.bz2
mysql -u -p  < mapRegionJumps.sql
mysql  -N -u -p -e "ALTER TABLE mapRegionJumps COLLATE 'utf8mb4_unicode_ci';"
rm mapRegionJumps.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapRegionJumps

# mapRegions
wget https://www.fuzzwork.co.uk/dump/latest/mapRegions.sql.bz2
bunzip2 mapRegions.sql.bz2
mysql -u -p  < mapRegions.sql
mysql  -N -u -p -e "ALTER TABLE mapRegions CHANGE regionName regionName varchar(100) COLLATE 'utf8mb4_unicode_ci' NULL AFTER regionID, COLLATE 'utf8mb4_unicode_ci';"
rm mapRegions.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapRegions

# mapSolarSystemJumps
wget https://www.fuzzwork.co.uk/dump/latest/mapSolarSystemJumps.sql.bz2
bunzip2 mapSolarSystemJumps.sql.bz2
mysql -u -p  < mapSolarSystemJumps.sql
mysql  -N -u -p -e "ALTER TABLE mapSolarSystemJumps COLLATE 'utf8mb4_unicode_ci';"
rm mapSolarSystemJumps.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables mapSolarSystemJumps

# staStations
wget https://www.fuzzwork.co.uk/dump/latest/staStations.sql.bz2
bunzip2 staStations.sql.bz2
mysql -u -p  < staStations.sql
#mysql  -N -u -p -e "ALTER TABLE mapSolarSystemJumps COLLATE 'utf8mb4_unicode_ci';"
rm staStations.sql
mysqlcheck --user  --auto-repair --databases   --optimize -p --skip-write-binlog --tables staStations
