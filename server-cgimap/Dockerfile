# Docker "osm-gridmaps-cgimap" image for openstreetmap-website server + cgimap
FROM selcolumbia/osm-gridmaps:0.1
MAINTAINER Chris Natali

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
  zlib1g-dev

# now cgimap setup
WORKDIR /
RUN git clone git://github.com/zerebubuth/openstreetmap-cgimap.git
WORKDIR /openstreetmap-cgimap
RUN ./autogen.sh
RUN ./configure --with-fcgi=/usr --with-boost-libdir=/usr/lib/x86_64-linux-gnu
RUN make && make install
RUN ldconfig /usr/local/lib
WORKDIR /root

# include cgimap run script
RUN mkdir /etc/service/cgimap
ADD cgimap_run.sh /etc/service/cgimap/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
