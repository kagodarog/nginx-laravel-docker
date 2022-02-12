#!/bin/bash

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

cd /var/www/html
cp .env.example .env
chmod 775 .env
php artisan key:generate 
php artisan config:cache
cd -

# Always chown webroot for better mounting
chown -Rf nginx:nginx /var/www/html

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
