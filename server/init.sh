#!/bin/bash
# setup osm website. This will be run on each container startup
echo "*** running gridmaps init script"
pushd /home/app/openstreetmap-website

# copy application.yml so that we can run rails
# a hack, but this keeps the external file untouched
if [[ ! -f /tmp/application.yml ]]; then
    echo "osm configuration file must be mounted to /tmp/application.yml"
	exit 1
fi

cp /tmp/application.yml config/application.yml

# wait for database (checked via rails config)
while ! sudo -u app rails runner -e production 'exit(begin; ActiveRecord::Base.connection; rescue Exception; false; else true; end)'
do
  echo "waiting for database..."
  sleep 1
done

sudo -u app RAILS_ENV=production rake db:migrate

echo "adding admin user if not done..."
sudo -u app rails runner -e production /home/app/add_admin.rb 

echo "registering id as client if not done..."
sudo -u app rails runner -e production /home/app/add_id_client.rb 

# sub the iD client key into application.yml and copy into config dir
id_key=`psql -h db -d osm -U postgres -tA -c "select key from client_applications where name='iD';"`
sed -i "s/<id_key>/$id_key/" config/application.yml

sudo -u app RAILS_ENV=production rake assets:precompile

# set the SECRET_KEY for prod on each startup
mkdir -p /etc/nginx/main.d
echo "env SECRET_KEY_BASE=`rake secret`;" > /etc/nginx/main.d/secret_key.conf
popd
