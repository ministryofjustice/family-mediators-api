#!/bin/sh
cd /app

bundle exec rake db:migrate
bundle exec pumactl -F config/puma.rb start
