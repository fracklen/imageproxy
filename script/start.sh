#!/bin/bash



exec bundle exec unicorn_rails -E \$RAILS_ENV -c /var/www/imageproxy/release/config/unicorn.rb
