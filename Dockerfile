ARG TAG=latest
FROM ubuntu:${TAG}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --yes jq locales dpkg-dev devscripts equivs autopkgtest
RUN update-locale LANG=C LANGUAGE=C
RUN apt-get autopurge --yes locales
ADD /check /opt/resource/check
ADD /out /opt/resource/out
ADD /in /opt/resource/in
RUN chmod +x /opt/resource/*
