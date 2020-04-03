#!/bin/bash
set -e

/etc/init.d/php7.3-fpm start
/usr/sbin/nginx -g 'daemon off;'
