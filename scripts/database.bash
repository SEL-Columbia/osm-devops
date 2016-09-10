#!/bin/bash

function dump() {
    shift;
    out "<32;1>Dumping database<0>"
    if ! [ -n "$1" ]; then echo "<db_name> parameter is required" && exit 1; fi
    if ! [ -n "$2" ]; then echo "<file_name> parameter is required" && exit 1; fi
    cid=$(docker-compose ps -q database)
    docker exec $cid sh -c "pg_dump -U osm $1 -f /$2"
    docker cp $cid:/$2 $ORIG_PWD
    docker exec $cid sh -c "rm $2"
    out "<32;1>Database dump complete<0>"
}

function cli () {
    out "<32;1>Initiate database cli<0>"
    docker-compose run --rm database sh -c 'exec psql -h osm -p 5432 -U osm'
    out "<32;1>Database cli finished<0>"
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>-d|--dump <db_name> <file_name><0>  Dump database.<0>
  <32;1>-c|--cli<0>                         Initiate cli pgsql.<0>
'
}

function run () {
    case $1 in
        -d|--dump)
            dump $*
            exit $?
        ;;
        -c|--cli)
            cli
            exit 0
        ;;
        *)
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
