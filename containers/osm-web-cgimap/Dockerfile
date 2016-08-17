# Docker "osm-gridmaps-cgimap" image for openstreetmap-website server + cgimap
FROM osm/web
MAINTAINER Flávio Briz

# cgimap dependencies
RUN apt-get update && apt-get -y install \
  automake \
  autoconf \
  daemontools \
  libtool \
  libpqxx3-dev \
  libfcgi-dev \
  libboost-dev \
  libboost-regex-dev \
  libboost-program-options-dev \
  libboost-date-time-dev \
  libboost-filesystem-dev \
  libboost-system-dev \
  libmemcached-dev \
  zlib1g-dev \
  wget

# now cgimap setup
WORKDIR /
RUN wget https://github.com/openstreetmap/cgimap/archive/master.tar.gz -O openstreetmap-cgimap.tar.gz
RUN tar -xf openstreetmap-cgimap.tar.gz && rm openstreetmap-cgimap.tar.gz

WORKDIR /cgimap-master
# hack to workaround the fact that these aren't configurable yet
RUN sed -i 's/#define MAX_AREA .*$/#define MAX_AREA 100\.0/' src/api06/map_handler.cpp
RUN sed -i 's/#define MAX_AREA .*$/#define MAX_AREA 100\.0/' src/api07/map_handler.cpp
RUN sed -i 's/#define MAX_NODES .*$/#define MAX_NODES 50000/' src/api06/map_handler.cpp
RUN sed -i 's/#define MAX_NODES .*$/#define MAX_NODES 50000/' src/api07/map_handler.cpp
RUN ./autogen.sh
RUN ./configure --with-fcgi=/usr --with-boost-libdir=/usr/lib/x86_64-linux-gnu
RUN make && make install
RUN ldconfig /usr/local/lib
WORKDIR /root

# include cgimap run script
RUN mkdir -p /etc/service/cgimap
ADD cgimap_run.sh /etc/service/cgimap/run

# disable default site
RUN rm /etc/nginx/sites-enabled/*
ADD ./osm-cgimap-nginx.conf /etc/nginx/sites-enabled/osm-cgimap-nginx.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
