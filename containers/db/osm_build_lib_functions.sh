#!/bin/bash
# Install OSM site

# Get the openstreetmap website
git clone https://github.com/SEL-Columbia/openstreetmap-website.git
cd openstreetmap-website
# gridmaps is effectively our master branch
git checkout gridmaps

# Make the libpgosm shared object lib
cd db/functions
make libpgosm.so
cd
