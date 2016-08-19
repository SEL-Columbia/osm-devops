#!/bin/bash
echo "Building Images:"
docker build -t "osm/osmosis" ./containers/osmosis
docker build -t "osm/web" ./containers/osm-web
docker build -t "osm/web-cgimap" ./containers/osm-web-cgimap
docker run -d --name osm_web osm/web
docker cp osm_web:/home/app/db/functions/libpgosm.so ./containers/db/libpgosm.so
docker stop osm_web
docker rm -f osm_web
docker build -t "osm/db" ./containers/db
