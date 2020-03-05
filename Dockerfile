# Dockerfile
#
# VERSION               0.4

FROM debian:stretch-backports
MAINTAINER Xiwen Cheng <x@cinaq.com>

RUN apt update && apt install -y --no-install-recommends gnupg ca-certificates-java openjdk-11-jre postgresql-client procps curl syslog-ng

COPY syslog-ng.conf /etc/

# Need help from Mendix
#RUN apt-key adv --fetch-keys https://packages.mendix.com/mendix-debian-archive-key.asc
RUN echo "deb http://packages.mendix.com/platform/debian/ stretch main" > /etc/apt/sources.list.d/mendix.list

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated m2ee-tools && apt-get clean

RUN useradd -m mendix -b /srv && cd /srv/mendix && mkdir -p .m2ee data/database data/files data/model-upload data/log data/tmp  model runtimes web package
ADD m2ee.yaml /srv/mendix/.m2ee/m2ee.yaml

RUN chown -R mendix:mendix /srv/mendix

VOLUME /srv/mendix/data/files

COPY ./bin/* /usr/local/bin/
USER mendix
ENTRYPOINT ["/usr/local/bin/mendix-run"]
EXPOSE 8000
