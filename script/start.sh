#!/bin/bash


/usr/sbin/varnishd -s malloc,1G -T 127.0.0.1:1080 -a 0.0.0.0:80 -F -f /etc/varnish/default.vcl &
exec bundle exec unicorn_rails -E production -c /var/www/imageproxy/release/config/unicorn.rb

