#!/bin/sh
printf '\e[33mINFO: Running migration\e[0m\n'
bundle exec rake db:migrate

printf '\e[33mINFO: Launching Puma\e[0m\n'
bundle exec pumactl -F config/puma.rb start
