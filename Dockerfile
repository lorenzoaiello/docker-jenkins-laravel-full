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

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get install -y apt-transport-https build-essential ca-certificates curl libssl-dev
RUN rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm # or ~/.nvm , depending
ENV NODE_VERSION 6.10.3

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Install pip
RUN apt-get install -y python-pip
