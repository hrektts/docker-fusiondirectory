#!/bin/bash
set -e

/etc/init.d/php5-fpm start
/usr/sbin/nginx -g 'daemon off;'
