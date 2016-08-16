#!/bin/bash
# setup databases for osm

psql -U "$POSTGRES_USER" -c "update pg_database set encoding=6, datcollate='en_US.UTF-8', datctype='en_US.UTF-8' where datname='template1';"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE osm OWNER postgres TEMPLATE template1;"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE osm_test OWNER postgres TEMPLATE template1;"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE osm_dev OWNER postgres TEMPLATE template1;"

# Setup the tile functions in the dev/prod db's
# assumes tile functions have been built
for osm_env in "osm_dev" "osm_test" "osm"
do
    psql -U "$POSTGRES_USER" -d $osm_env -c "CREATE EXTENSION btree_gist;"
    psql -U "$POSTGRES_USER" -d $osm_env -c "CREATE FUNCTION maptile_for_point(int8, int8, int4) RETURNS int4 AS '/openstreetmap-website/db/functions/libpgosm', 'maptile_for_point' LANGUAGE C STRICT;"
    psql -U "$POSTGRES_USER" -d $osm_env -c "CREATE FUNCTION tile_for_point(int4, int4) RETURNS int8 AS '/openstreetmap-website/db/functions/libpgosm', 'tile_for_point' LANGUAGE C STRICT;"
    psql -U "$POSTGRES_USER" -d $osm_env -c "CREATE FUNCTION xid_to_int4(xid) RETURNS int4 AS '/openstreetmap-website/db/functions/libpgosm', 'xid_to_int4' LANGUAGE C STRICT;"
done
