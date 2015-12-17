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
  postgresql

RUN gem2.0 install bundler

# get openstreetmap and put it into /
# this will just get overridden by a volume with local source
RUN mkdir -p /src/
WORKDIR /
RUN git clone https://github.com/SEL-Columbia/openstreetmap-website.git
WORKDIR /openstreetmap-website
RUN git checkout gridmaps
RUN bundle install
