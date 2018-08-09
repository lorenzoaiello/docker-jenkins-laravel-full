FROM php:7.1-apache
MAINTAINER Lorenzo Aiello <lorenzo@6c61.com>

# Install php dependencies
RUN apt-get update
RUN apt-get install -y libmcrypt-dev libldap2-dev nano git zip unzip zlib1g-dev libldap2-dev libxml2-dev wget

# Recompile PHP to include additional packages
RUN docker-php-source extract
RUN rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap pdo pdo_mysql zip soap
RUN docker-php-source delete

# Install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php

RUN apt-get update -q && apt-get install -q -y \
        curl apt-transport-https apt-utils dialog gnupg

WORKDIR /home/download
ARG NODEREPO="node_6.x"
ARG DISTRO="jessie"
# Only newest package kept in nodesource repo. Cannot pin to version using apt!
# See https://github.com/nodesource/distributions/issues/33
RUN curl -sSO https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-key add nodesource.gpg.key
RUN echo "deb https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" >> /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -q && apt-get install -y 'nodejs=6.*' && npm i -g npm@5

# Install pip
RUN apt-get install -y python3 python-dev python3-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev python-pip
RUN pip --no-cache-dir install --upgrade awscli awsebcli
