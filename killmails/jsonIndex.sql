-- Used for the raw kills saved as JSON in Postgres

DROP INDEX idx_killsjson_killid;
CREATE INDEX idx_killsjson_killid 
ON kills.killsjson ((rawjson->>'killID'));

DROP INDEX idx_killsjson_killTime;
CREATE INDEX idx_killsjson_killTime 
ON kills.killsjson ((rawjson->>'killTime'));

DROP INDEX idx_killsjson_solarSystem;
CREATE INDEX idx_killsjson_solarSystem 
ON kills.killsjson ((rawjson->'solarSystem'->>'id'));DROP INDEX idx_killsjson_victimcharacterid;
CREATE INDEX idx_killsjson_victimcharacterid 
ON kills.killsjson ((rawjson->'victim'->'character'->>'id'));

DROP INDEX idx_killsjson_victimshipTypeid;
CREATE INDEX idx_killsjson_victimshipTypeid 
ON kills.killsjson ((rawjson->'victim'->'shipType'->>'id'));
