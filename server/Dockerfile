# Docker "osm-gridmaps" image for openstreetmap-website server
FROM phusion/passenger-ruby20
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
  postgresql 

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

# disable default site
RUN rm /etc/nginx/sites-enabled/default

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
