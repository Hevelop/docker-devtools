#!/usr/bin/env bash

set -e

# Configure Xdebug
if [ "$XDEBUG_CONFIG" ]; then
    XDEBUG_INI=/usr/local/etc/php/conf.d/zz-xdebug.ini

    touch $XDEBUG_INI
    for config in $XDEBUG_CONFIG; do
        echo "xdebug.$config" >> $XDEBUG_INI
    done

    REMOTE_HOST=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
    echo "xdebug.remote_host=${REMOTE_HOST}" >> $XDEBUG_INI

    docker-php-ext-enable xdebug
fi

# Execute the supplied command
exec "$@"