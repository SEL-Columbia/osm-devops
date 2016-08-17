# Docker "openstreetmap-website" image for openstreetmap-website server
FROM debian:jessie
MAINTAINER Flávio Briz

# Passenger repository configuration
RUN apt-get update \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7 \
	&& apt-get install -y apt-transport-https ca-certificates \
	&& sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main > /etc/apt/sources.list.d/passenger.list' \
	&& apt-get update \
	&& apt-get upgrade -y

# install packages
RUN apt-get install -y --fix-missing \
	gnupg \
	build-essential \
	ruby \
	libruby \
	ruby-dev \
    libmagickwand-dev \
	libxml2-dev \
	libxslt1-dev \
	nodejs \
    build-essential \
	postgresql \
	postgresql-contrib \
	libpq-dev \
	postgresql-server-dev-all \
	libsasl2-dev \
	imagemagick \
	nginx \
	nginx-extras \
	passenger \
	&& ln -sf /usr/bin/nodejs /usr/local/bin/node # Fix for nodejs on debian >= 8

RUN gem install bundler

# NGINX configuration
RUN rm -f /etc/service/nginx/down \
	&& sed -i "s/include \/etc\/nginx\/passenger.conf;/include \/etc\/nginx\/passenger.conf;/" /etc/nginx/nginx.conf

# get openstreetmap and put it into /home/app
ADD ./src /home/app
WORKDIR /home/app
RUN bundle install

# Build database functions
RUN cd db/functions \
    && make

# get openstreetmap and put it into /home/app
WORKDIR /root

# add init script
RUN mkdir -p /etc/my_init.d
ADD init.sh /etc/my_init.d/init.sh

# and script to add admin user and id-client if not there
ADD add_admin.rb /home/app/add_admin.rb
ADD add_id_client.rb /home/app/add_id_client.rb

# disable default site
RUN rm /etc/nginx/sites-enabled/default
ADD ./osm-web-nginx.conf /etc/nginx/sites-enabled/osm-web-nginx.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
