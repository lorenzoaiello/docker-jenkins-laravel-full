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

# nvm environment variables
RUN mkdir ~/.nvm
ENV NVM_DIR ~/.nvm
ENV NODE_VERSION 6.10.3

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install pip
RUN apt-get install -y python3 python-dev python3-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev python-pip
