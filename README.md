# Family Mediators API
[![Code Climate](https://codeclimate.com/github/ministryofjustice/family-mediators-api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/family-mediators-api)

## Local set-up

Assumes Postgres DB is up and running on your machine.

Set up the DB if this is the first time:

    bundle exec rake db:setup

Run the app:

    rackup

...and goto http://localhost:9292/api/v1/mediators/


## Play around in IRB

    RACK_ENV=development irb
    irb> require_relative 'lib/mediators'
    irb> Mediators::Models::Mediator.all.to_a
    irb> ...etc
