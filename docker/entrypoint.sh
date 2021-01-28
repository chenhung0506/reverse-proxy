#!/bin/sh
cd /etc/nginx
rm nginx.conf

set -e

export NAMESERVER=`cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | tr '\n' ' '`


envsubst '
$$NAMESERVER
' < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf
nginx -t
nginx -g "daemon off;"
