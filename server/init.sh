#!/bin/bash
# setup osm website. This will be run on each container startup
echo "*** running gridmaps init script"
pushd /home/app/openstreetmap-website
sudo -u app RAILS_ENV=production rake db:migrate
sudo -u app RAILS_ENV=production rake assets:precompile

# set the SECRET_KEY for prod on each startup
mkdir -p /etc/nginx/main.d
echo "env SECRET_KEY_BASE=`rake secret`;" > /etc/nginx/main.d/secret_key.conf
popd
