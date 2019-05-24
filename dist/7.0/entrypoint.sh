#!/usr/bin/env sh

set -e

# Configure Xdebug
if [ "$XDEBUG_CONFIG" ]; then
    XDEBUG_INI=/usr/local/etc/php/conf.d/zz-xdebug.ini    

    echo "" > $XDEBUG_INI
    for config in $XDEBUG_CONFIG; do
        echo "xdebug.$config" >> $XDEBUG_INI
    done    
fi

# Execute the supplied command
exec "$@"