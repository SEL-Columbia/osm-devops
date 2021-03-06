# Openstreetmap Devops

Simplifies deployment and management of short-lived openstreetmap instances for localized data gathering projects.

Developed in support of [SEL's](http://sel.columbia.edu) electrification access initiatives.

Builds are currently based on our [fork of openstreetmap-website](https://github.com/SEL-Columbia/openstreetmap-website) (aka "gridmaps").

Experience with Docker is a prerequisite.

## Quick Setup

To deploy to a host for a data collection effort:

### Setup a server with docker and docker-compose

- Setup a linux server (make sure it's secure)
- install docker (if not using an image with docker preinstalled)
- install docker-compose via instructions [here](http://docs.master.dockerproject.org/compose/install/)
- start docker if not done (depends on your system, but something like ```service start docker``` should work)

### Setup the osm-devops repository

- clone this repo onto that server and cd into the clone dir

```bash
git clone https://github.com/SEL-Columbia/osm-devops
cd osm-devops
```

### Configure osm application

- application.yml
	- copy example.application.yml to application.yml (this will be added as a volume to osm config dir)
	- edit any necessary params
      - Email related (mail* and email*) using a gmail email and their smtp service works
      - NOTE:  signup/registration will not happen properly without setting up a working mail server and account 

- copy example.database.yml to database.yml

### Run

- Run the database and server in the background:

```docker-compose up -d gridmaps-cgimap```

### Manage

- Navigate to the url you setup for your server (OSM will be running on port 80)
- Login to the admin account with user/password admin/admin
- CHANGE THE PASSWORD for the admin account!
- Users should register via the "Sign Up" link
- Manage users as appropriate via UI at ```<server>/users``` endpoint

## Deployment Architecture [Production]

<pre>
+-- host
|   +-- docker-compose
|   |   +-- db (docker container)
|   |   |   +-- postgresql 
|   |   |   +-- osm tile library functions 
|   |   +-- gridmaps [web server] (docker container)
|   |   |   +-- nginx
|   |   |   +-- rails
|   |   |   +-- cgimap
</pre>

docker-compose is configured to map traffic on port from the host to the gridmaps container.  

## Images

Dockerfiles for the images are maintained in sub-folders.  
You can build all images from the parent dir via:

```
docker build -t selcolumbia/osm-db ./db
docker build -t selcolumbia/osm-gridmaps ./server
docker build -t selcolumbia/osm-gridmaps-cgimap ./server-cgimap
docker build -t selcolumbia/osm-gridmaps-dev ./server-dev
```

## Development workflow

Development for the openstreetmap-website fork should be done in the SEL-Columbia/openstreetmap-website repository.  

#### Branch organization:
- ```master```:  should be synchronized with upstream openstreetmap/openstreetmap-website regularly (fork changes are not applied here)
- ```gridmaps```:  "production" SEL openstreetmap-website fork.  This should be deployable at all times.  Nothing untested should make it in here.
- ```gridmaps-<branch>```:  Any changes to fork code to be merged in a pull-request to gridmaps
- ```gridmaps-<deployment>```:  Any prior deployments in case bug fixes need to be made

#### Git flow for fix/feature

Use a simple feature-branch workflow.  
Since the gridmaps branch contains our SEL-specific customizations, we should use it to create feature branches from.
That said, regular synchronization with upstream/master should be done since the OSM folks are constantly improving things.
YMMV, but one approach to doing this is:

- update master from upstream
```
git fetch upstream
git checkout master
git merge upstream/master
```

- create gridmaps-feature branch with latest from upstream + SEL customizations
```
git checkout gridmaps
git checkout -b gridmaps-feature
git merge master
```

- Once changes have been tested, issue PR to merge ```gridmaps-<feature_or_fix>``` into gridmaps branch

#### Testing

Testing can be done via docker-compose.  

1.  Checkout the branch you want to test
2.  Update the ```dev``` service in docker-compose.yml to refer to your local checkout of openstreetmap-website.
3.  Bring up the services via:

```
docker-compose run dev bash
```

4.  At the prompt, navigate to your mounted source dir and run the tests:

```
cd /src/openstreetmap-website
bundle install
rake db:migrate RAILS_ENV=test
rake test
```

Note that you can save time with the bundle install step if you commit a working image with appropriate gems installed

5.  You can test the gridmaps or gridmaps-cgimap image via:

```
docker-compose run gridmaps bash -c "cd /home/app/openstreetmap-website; cp /tmp/application.yml config/application.yml; rake test test/models/trace_test.rb"
```

Note the need to copy the /tmp/application.yml file into the config dir in order for tests to pass

#### Backups

Backups are currently ad-hoc. 

- Backup the osm-db container's osm db (sql dump that clears existing entities first):

```
docker exec -t root_db_1 pg_dump -d osm -U postgres -c > backup/osm_dump.sql
```

- Populate/Restore an osm-db container's osm db via the dump (change -d osm to osm_dev for development):
```
cat osm_dump.sql | docker exec -i osmdevops_db_1 psql -U postgres -d osm
```
