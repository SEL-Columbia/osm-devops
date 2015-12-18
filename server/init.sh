#!/bin/bash
# setup osm website. This will be run on each container startup
echo "*** running gridmaps init script"
pushd /home/app/openstreetmap-website

# wait for database (checked via rails config)
while ! sudo -u app rails runner -e production 'exit(begin; ActiveRecord::Base.connection; rescue Exception; false; else true; end)'
do
  echo "waiting for database..."
  sleep 1
done

sudo -u app RAILS_ENV=production rake db:migrate

echo "adding admin user if not done..."
sudo -u app rails runner -e production /home/app/add_admin.rb 

sudo -u app RAILS_ENV=production rake assets:precompile

# set the SECRET_KEY for prod on each startup
mkdir -p /etc/nginx/main.d
echo "env SECRET_KEY_BASE=`rake secret`;" > /etc/nginx/main.d/secret_key.conf
popd
