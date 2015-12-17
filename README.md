# Openstreetmap Devops

Simplifies deployment and management of short-lived openstreetmap instances for localized data gathering projects.

Developed in support of [SEL's](sel.columbia.edu) electrification access initiatives.

Builds are currently based on our [fork of openstreetmap-website](https://github.com/SEL-Columbia/openstreetmap-website) (aka "gridmaps").

Experience with Docker is a prerequisite.

## Quick Setup

To deploy to a host for a data collection effort:

## Deployment Architecture [Production]

.
+-- host
|   +-- docker-compose
|   |   +-- db (docker container)
|   |   |   +-- postgresql 
|   |   |   +-- osm tile library functions 
|   |   +-- gridmaps [web server] (docker container)
|   |   |   +-- nginx
|   |   |   +-- rails
|   |   |   +-- cgimap

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
