FROM ubuntu:latest
MAINTAINER Matthew Mattox

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y mailutils

COPY run.sh /usr/bin/run.sh
CMD /usr/bin/run.sh
