#!/bin/sh
cd /usr/src/app

bundle exec rake db:create db:migrate db:seed
bundle exec pumactl -F config/puma.rb start
