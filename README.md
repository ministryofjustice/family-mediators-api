# Family Mediators API
[![Travis CI](https://travis-ci.org/ministryofjustice/family-mediators-api.svg?branch=master)](https://travis-ci.org/ministryofjustice/family-mediators-api)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/family-mediators-api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/family-mediators-api)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/family-mediators-api/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/family-mediators-api/coverage)

Maintains a list of family mediators. Provides an API and an HTML admin UI for
uploading spreadsheets of mediator data. 

## Admin App

* /admin - Homepage

## API Endpoints

* /api/v1/healthcheck - Check health of service
* /api/v1/mediators - List all mediators
* /api/v1/mediators/:id - Show a mediator

## Local set-up

Assumes Postgres DB is up and running on your machine.

Set up the DB if this is the first time:

    bundle exec rake db:setup

Run the app:

    rackup

...and goto http://localhost:9292/api/v1/mediators/

### Run build

The default rake command runs specs, features, generates coverage report and runs Rubocop. 

    rake

The coverage report is available under `/coverage/index.html`.


## Play around in IRB

    RACK_ENV=development irb
    irb> require_relative 'lib/mediators'
    irb> Mediators::Models::Mediator.all.to_a
    irb> ...etc


## Deploy to cloud development environment via Tsuru

See [MoJ Tsuru documentation](https://docs.google.com/document/d/11xQRRJ_KH4Oipn9qYCt-wk-PEaUbUrrd8pLCi1pijLE/)
