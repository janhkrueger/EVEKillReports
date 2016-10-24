#!/bin/bash
export PGPASSFILE=~/.pgpass

# helpers Schema
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE helpers.driftercharacter'


# Twitter Schema
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE twitter.tweets'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE twitter.tweet_ccp'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE twitter.tweet_ccp_collected'


# Kill Schema
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE kills.cresthashes'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE kills.kr_remarkablekills'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE kills.participants'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE kills."participantsToCollect"'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE kills.killsjson'

# Universe-Schema
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE universe.alliances'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE universe.crestmarketprices'
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE universe.jumps'

# wars-Schema
psql --host=127.0.0.1 --port=5432 --dbname=eve --username=psql_eve -c 'VACUUM ANALYZE wars.wars'