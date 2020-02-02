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
FROM cinaq/mendix-docker:latest

# MDA
COPY ./releases/TestApp080500.mda /srv/mendix/data/model-upload/
RUN mendix-build
```

Build the image:
```
docker build -t mendix-app:latest .
```

After that you can run any number of instances
```
docker run mendix-app
```

visit the App
```
curl localhost:$(docker inspect -f '{{(index (index .NetworkSettings.Ports "8000/tcp") 0).HostPort}}' mendix_app)
```
