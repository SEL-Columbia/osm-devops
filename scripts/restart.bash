#!/bin/bash

function run () {
    docker-compose stop && docker-compose rm -f && docker-compose up -d
}
