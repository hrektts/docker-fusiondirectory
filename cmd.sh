#!/bin/bash
set -e

/etc/init.d/php7.0-fpm start
/usr/sbin/nginx -g 'daemon off;'
