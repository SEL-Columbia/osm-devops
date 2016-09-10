#!/bin/bash

# cgimap run script, based roughly on 
# https://github.com/geo-data/openstreetmap-website-docker/blob/master/cgimap/run

CGIMAP_HOST=db; export CGIMAP_HOST
CGIMAP_DBNAME=osm; export CGIMAP_DBNAME
CGIMAP_USERNAME=postgres; export CGIMAP_USERNAME

CGIMAP_MEMCACHE=localhost; export CGIMAP_MEMCACHE
CGIMAP_RATELIMIT=102400; export CGIMAP_RATELIMIT
CGIMAP_MAXDEBT=250; export CGIMAP_MAXDEBT
CGIMAP_PIDFILE=/home/app/cgimap.pid; export CGIMAP_PIDFILE
CGIMAP_LOGFILE=/home/app/cgimap.log; export CGIMAP_LOGFILE

exec /usr/bin/fghack /sbin/setuser app /usr/local/bin/map --daemon --port=8000
