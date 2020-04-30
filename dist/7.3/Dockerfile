FROM hevelop/php:7.3-cli-stretch

ARG UNAME=www-data
ARG UID=1000
ARG GID=1000

RUN if grep -q $GID /etc/group; then GROUP_NAME=$(grep :$GID: /etc/group | sed -En "s/(.*):x:$GID:/\1/p") \
    && delgroup $GROUP_NAME; fi;
RUN if grep -q $UNAME /etc/group; then groupmod -g $GID $UNAME; else groupadd -g $GID $UNAME; fi;
RUN usermod -u $UID $UNAME

# update the repository sources list
RUN apt-get update

# Install dependencies
RUN apt-get install -y \
    mysql-client \
    sudo \
    gnupg2 \
    net-tools \
    git

RUN apt-get install --no-install-recommends -y \
    cmake \
    make \
    gcc \
    libc6-dev

# Install Xdebug (but don't enable)
RUN pecl install -o -f xdebug

# Configure the gd library
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# tini
RUN ln -s /tini /usr/local/sbin/tini

RUN mkdir -p /var/www/.npm && chown -R www-data:www-data /var/www/.npm
RUN mkdir -p /var/www/.nvm && chown -R www-data:www-data /var/www/.nvm
RUN mkdir -p /var/www/.config && chown -R www-data:www-data /var/www/.config

# Install Node, NVM, NPM and Grunt
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs build-essential \
    && npm i -g grunt-cli yarn \
    && su www-data -s /bin/bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && chown -R www-data:www-data /var/www/.nvm'

RUN apt-get -y autoclean

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/www/deploy

CMD ["php", "-A"]
