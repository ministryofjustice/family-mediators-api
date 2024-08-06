#!/bin/sh
bundle exec rake db:migrate
bundle exec pumactl -F config/puma.rb start
