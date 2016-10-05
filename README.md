# Family Mediators API


## Local set up

Install Mongo DB (Assumes Mac OS):

    brew install mongodb

Run:

    rackup

...and goto http://localhost:9292/api/v1/mediators/


## Play around in IRB

    RACK_ENV=development irb
    irb> require_relative 'lib/mediators'
    irb> Mediators::Models::Mediator.all.to_a
    irb> ...etc


[![Code Climate](https://codeclimate.com/github/ministryofjustice/family-mediators-api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/family-mediators-api)
