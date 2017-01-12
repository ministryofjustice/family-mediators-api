#!/bin/bash
cd /usr/src/app
case ${DOCKER_STATE} in
create)
    echo "running create"
    bundle exec rake db:setup db:seed
    ;;
migrate_and_seed)
    echo "running migrate and seed"
    bundle exec rake db:migrate db:seed
    ;;
esac
echo "Running app"
bundle exec rackup
