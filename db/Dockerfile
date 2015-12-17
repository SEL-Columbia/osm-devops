# Docker image for openstreetmap-website db
FROM postgres
MAINTAINER Chris Natali

# setup requirements for building lib functions
RUN apt-get update && apt-get -y install \
  build-essential \
  git-core \
  imagemagick \
  libmagickwand-dev \
  libpq-dev \
  libsasl2-dev \
  libxml2-dev \
  libxslt1-dev

RUN apt-get -y install postgresql-server-dev-all

# build library functions for install in db
ADD osm_build_lib_functions.sh /tmp/
RUN bash /tmp/osm_build_lib_functions.sh

ADD init.sh /docker-entrypoint-initdb.d/
