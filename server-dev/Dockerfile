# Docker image for openstreetmap-website db

FROM ubuntu:14.04
MAINTAINER Chris Natali

# install dependencies
RUN apt-get update && apt-get -y install \
  build-essential \
  git-core \
  ruby2.0 \
  libruby2.0 \
  ruby2.0-dev \
  imagemagick \
  libmagickwand-dev \
  libpq-dev \
  libsasl2-dev \
  libxml2-dev \
  libxslt1-dev \
  nodejs \
  wget

# now postgres version 9.4
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get -y install postgresql-9.4

RUN gem2.0 install bundler

# get openstreetmap and put it into /
# this will just get overridden by a volume with local source
RUN mkdir -p /src/
WORKDIR /
RUN git clone https://github.com/SEL-Columbia/openstreetmap-website.git
WORKDIR /openstreetmap-website
RUN git checkout gridmaps
RUN bundle install
