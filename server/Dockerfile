# Docker "osm-gridmaps" image for openstreetmap-website server
FROM phusion/passenger-ruby20:0.9.18
MAINTAINER Chris Natali

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# install dependencies
RUN apt-get update && apt-get -y install \
  build-essential \
  git-core \
  imagemagick \
  libmagickwand-dev \
  libpq-dev \
  libsasl2-dev \
  libxml2-dev \
  libxslt1-dev \
  nodejs \
  wget \
  zip

# now postgres version 9.4
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get -y install postgresql-9.4

RUN gem install bundler

# Run nginx in bg on init
RUN rm -f /etc/service/nginx/down

# get openstreetmap and put it into /home/app
WORKDIR /home/app
RUN git clone https://github.com/SEL-Columbia/openstreetmap-website.git
WORKDIR /home/app/openstreetmap-website
RUN git checkout gridmaps
RUN chown -R app:app /home/app/openstreetmap-website
RUN bundle install
WORKDIR /root

# add init script
RUN mkdir -p /etc/my_init.d
ADD init.sh /etc/my_init.d/init.sh

# and script to add admin user and id-client if not there
ADD add_admin.rb /home/app/add_admin.rb
ADD add_id_client.rb /home/app/add_id_client.rb

# disable default site
RUN rm /etc/nginx/sites-enabled/default

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
