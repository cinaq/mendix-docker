Docker image for running Mendix applications
=

A simple docker image you can use as base to build your own docker images to run a Mendix app.

As of this writing this image should not be used in a production environment. I hope to mark it as production ready before the end of 2020.

For now this image is only suitable for testing Mendix apps.

Philosophy
==

This docker image came to life because there's no solution that is:
- very simple to extend
- easy to configure
- designed for the docker mindset: clear separation between build and run stages
- lightweight
- fast to build
- fast to run
- logs to STDOUT


Disclaimer
==

This image is not endorsed or supported officially by Mendix. This was forked from pommie/mendix-docker and adjusted to improve usability.


Usage
==

With own Dockerfile
===

Create a Dockerfile with the following contents:
```
FROM cinaq/mendix-docker:v0.2

ENV MENDIX_VERSION 8.5.0.64176
# runtime is always needed to run
RUN mendix-download $MENDIX_VERSION

# OPTION 1: MDA
ARG APP_PACKAGE=releases/TestApp080500.mda

# OPTION 2: Project source
#RUN mendix-download $MENDIX_VERSION with-mxbuild
#ARG APP_PACKAGE=.
# NOTE: The order of above two lines is important for efficiency!

# DO NOT CHANGE BELOW HERE
COPY $APP_PACKAGE /srv/mendix/package
RUN mendix-build

USER mendix
```

Also create a `docker-compose.yml`:

```
version: '3.3'

services:
   db:
     image: postgres:12
     restart: always
     environment:
       POSTGRES_USER: mendix
       POSTGRES_PASSWORD: mendix
       POSTGRES_DB: mendix

   app:
     restart: always
     depends_on:
       - db
     build: .
     image: app
     ports:
       - "8000:8000"
```

Build and run the stack:
```
docker-compose build
docker-compose up -d
docker-compose logs -f

```

Your app should be running at http://localhost:8000


