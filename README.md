# Openstreetmap Devops

Simplifies deployment and management of short-lived openstreetmap instances for localized data gathering projects.

Developed in support of [SEL's](sel.columbia.edu) electrification access initiatives.

Builds are currently based on our [fork of openstreetmap-website](https://github.com/SEL-Columbia/openstreetmap-website) (aka "gridmaps").

Experience with Docker is a prerequisite.

## Quick Setup

To deploy to a host for a data collection effort:

### Setup a server with docker and docker-compose

- Setup a linux server securely with a user account, sudo and ssh access
- Make user part of docker group:  ```gpasswd -a cjn docker```
- install docker 
- start it (depends on your system, but something like ```service start docker``` should work)

Instructions can be found [here](https://docs.docker.com/engine/installation/)

Tested with Debian "jessie" instructions [here](https://docs.docker.com/engine/installation/debian/#debian-jessie-80-64-bit)

### Setup the osm-devops repository

- clone this repo onto that server and cd into the clone dir

### Configure osm application

- application.yml
	- copy example.application.yml to application.yml
	- edit any necessary params
    - NOTE:  signup/registration will not happen properly without setting up a working mail server and account 

- copy example.database.yml to database.yml and edit appropriately (shouldn't need to change)

### Run

- Run the database and server in the background:

```docker-compose up -d gridmaps-cgimap```

### Manage

- Navigate to the url you setup for your server (OSM will be running on port 80)
- Login to the admin account with user/password admin/admin
- CHANGE THE PASSWORD for the admin account!
- Users should register via the "Sign Up" link
- Manage users as appropriate via <server>/users

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
