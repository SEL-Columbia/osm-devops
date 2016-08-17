#!/bin/bash

echo "Building Images:"
docker build -t "osm/osmosis" ./containers/osmosis
docker build -t "osm/db" ./containers/db
docker build -t "osm/web" ./containers/osm-web
docker build -t "osm/web-cgimap" ./containers/osm-web-cgimap
