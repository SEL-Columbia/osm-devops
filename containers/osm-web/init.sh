#!/bin/bash
# setup osm website. This will be run on each container startup
echo "*** running osm init script"
cd /home/app

# wait for database (checked via rails config)
while ! su - app -c "rails runner -e production 'exit(begin; ActiveRecord::Base.connection; rescue Exception; false; else true; end)'"
do
  echo "waiting for database..."
  sleep 1
done

su - app -c "RAILS_ENV=production rake db:migrate"

echo "adding admin user if not done..."
su - app -c "rails runner -e production /home/app/add_admin.rb"

echo "registering id as client if not done..."
su - app -c "rails runner -e production /home/app/add_id_client.rb"

# sub the iD client key into application.yml and copy into config dir
id_key=`psql -h db -d osm -U postgres -tA -c "select key from client_applications where name='iD';"`
sed -i "s/<id_key>/$id_key/" config/application.yml

su - app -c "RAILS_ENV=production rake assets:precompile"

# set the SECRET_KEY for prod on each startup
mkdir -p /etc/nginx/main.d
SECRET_KEY_BASE=`rake secret`
sed -i "s/\%SECRET_KEY_BASE\%/${SECRET_KEY_BASE}/" /etc/nginx/sites-enabled/*.conf
nginx -g "daemon off;"
