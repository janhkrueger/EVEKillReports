SELECT p.* FROM KR_participants p
WHERE p.shipTypeID in (SELECT it.typeID FROM invTypes it WHERE it.groupID in (361,1246,1247,1249,1250,1273,1275,1276))
AND p.isVictim = 1
ORDER BY p.kill_time
