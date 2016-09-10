#!/bin/bash

function check_depedencies () {
    out "<32;1>Checking depedencies<0>"

    if [ ! -f "docker-compose.yml" ] ; then
        out -n "<32>Copying docker-compose.yml file...<0>\n"
        cp docker-compose.yml{.example,}
    fi

    if ! type "docker" &> /dev/null; then
        out "<31>Please install Docker<0>"
        exit 1
    fi

    if ! type "docker-compose" &> /dev/null; then
        out "<31>Please install docker-compose<0>"
        exit 1
    fi

    out "<33;1>All depedencies installed<0>"
}

function repositories () {
    out "<32;1>Installing repositories<0>"
	git submodule init
	git submodule update
    out "<33;1>Repositories installed!<0>"
}

function install () {
    out "<32;1>Beggining installation<0>"
    # Check depedencies
    check_depedencies

    # Clone repositories
    repositories

	echo "Building Images:"
	docker build -t "osm/osmosis" ./containers/osmosis
	docker build -t "osm/web" ./containers/osm-web
	docker build -t "osm/web-cgimap" ./containers/osm-web-cgimap
	docker run -d --name osm_web osm/web
	docker cp osm_web:/home/app/db/functions/libpgosm.so ./containers/db/libpgosm.so
	docker stop osm_web
	docker rm -f osm_web
	docker build -t "osm/db" ./containers/db

    # Run
    docker-compose up -d
    out "<33;1>Installation finished<0>"
}

function help() {
    out '
<33>Available methods:<0>
  <32;1>-c|--check-depedencies<0>           Check if you have everything to install the enviroment.<0>
  <32;1>-i|--install<0>                     Install and config the full stack.<0>
  <32;1>-r|--repositories<0>                Clone all the repositories.<0>
'
}

function run () {
    case $1 in
        -c|--check-depedencies)
            check_depedencies
            exit 0
        ;;
        -i|--install)
            install
            exit 0
        ;;
        -r|--repositories)
            repositories
            exit 0
        ;;
        *)
            help
            out "<33;1>Please choose one of the methods above.<0>"
        ;;
    esac
}
