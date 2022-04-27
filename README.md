# Family Mediators API
[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.data%5B%3F%28%40.name%20%3D%3D%20%22family-mediators-api%22%29%5D.status&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fgithub_repositories)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_repositories#family-mediators-api "Link to report")

[![CI and CD](https://github.com/ministryofjustice/family-mediators-api/actions/workflows/test-build-deploy.yml/badge.svg)](https://github.com/ministryofjustice/family-mediators-api/actions/workflows/test-build-deploy.yml)

Maintains a list of family mediators. Provides an API and an admin UI for uploading spreadsheets of mediator data.

## Docker

The application can be run inside a docker container. This will take care of the ruby environment, postgres database,
and any other dependency for you, without having to configure anything in your machine.

* `docker-compose up`
* `docker-compose build` - when you need to test your docker configurations

The application will be run in "production" mode, so will be as accurate as possible to a real production environment.  

## Local set-up

Assumes Postgres DB is up and running on your machine.

Set up the DB if this is the first time:

    bundle exec rake db:setup

Run the app:

    bundle exec rackup

...and goto http://localhost:9292/api/v1/mediators/

### To run the tests:

* `RACK_ENV=test bundle exec rake db:setup db:migrate`

### Run build

The default rake command runs specs, features, generates coverage report and runs Rubocop.

    rake

The coverage report is available under `/coverage/index.html`


## Play around in IRB

    RACK_ENV=development irb -r './lib/env' -r './lib/mediators'
    irb> require_relative 'lib/mediators'
    irb> API::Models::Mediator.all.to_a
    irb> ...etc


## Deploy to kubernetes cloud platform

Refer to the [deploy repository](https://github.com/ministryofjustice/family-mediators-api-deploy)

## Environment variables

The following environment variables are used:

* LOG_LEVEL - Can be one of _debug_, _error_, _info_, _warn_ or _fatal_. Assumes _debug_ if not set.
* RACK_ENV - Can be one of _staging_ or _production_. The app uses the development environment if this is not set.
* DATABASE_URL - Must be set if RACK_ENV is _staging_ or _production_.
* USERNAME - For logging into the admin area.
* PASSWORD_HASH - A hash of the password for logging into the admin area.

To generate the password hash, use bcrypt-ruby. In irb:

    require 'bcrypt'

    BCrypt::Password.create("my password")
      #=> "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"

...and use the long string generated.

When running the app locally you can set these ENV variables in the `.env` file.  
This file is also used by `docker-compose` but will not be used in production environments.

## API Doc

Documentation is generated as part of the docker build, using [aglio](https://github.com/danielgtaylor/aglio) to parse
an [API Blueprint](api.apib).

Although this documentation can be also generated locally, it requires a vast amount of node modules dependencies,
and a very specific NodeJS version, so if you want to see the generated documentation it is quicker and easier to just
do `docker-compose up` and go to `http://localhost:9292/api/documentation`

### Admin App

* /admin - Homepage

### Endpoints

* /api/v1/healthcheck - Check health of service
* /api/v1/mediators - List all mediators
* /api/v1/mediators/:id - Show a mediator's information

### Parameters

* **detail=[simple|full]**
Controls the amount of information returned. Default is full, but will switch to simple in the near future so use ?detail=full if you need all the fields. Fields included in each are described in the Fields section.

### Result structure
A call to the API will return JSON. The root JSON object contains 2 object values, 'meta', describing the result set, and 'data', containing the results.


### Fields
All dates are in ISO 8601 standard. All booleans are a string 'Yes' or 'No', to remain consistent with extra FMC-provided data.


#### Simple detail
* **id** *int*: internal ID of the mediator
* **urn** *string*: registration number of the mediator, composed of a numeric root followed by a letter [ATP] indicating the status of the mediator. 'A' means certified, 'P' provisionally certified, and 'T' in training.
* **dcc** *boolean*: Whether the mediator is habilitated to work with children directly.
* **title** *string*: 'Mr', 'Mrs', etc.
* **first_name** *string*: Given name - 'Sue', 'Peter', etc.
* **last_name** *string*: Patronymic name - 'Smith', 'Jones', etc.
* **fmca_date** *date*: Date at which the mediator was certified with an FMCA.
* **practices** *array*: An array containing the addresses and contact details of where this mediator practices. Each address is an object containing
  *  **tel** *string*: The phone number to contact the mediator at this practice.
  * **website** *string*: Website URL for this practice.
  * **email** *string*: Email to contact the mediator at this practice
  * **address** *string*: Full address of the practice
* **legal_aid_franchise** *boolean*: Whether the mediator is part of an organisation registered with Legal Aid.
* **legal_aid_qualified** *boolean*: Whether the mediator is qualified to work within Legal Aid. If both this and legal_aid_franchise are true then the mediator can work with clients receiving Legal Aid.

#### Full detail
In addition to the previous field set, the full set also comprises the following fields. These fields are not validated, and are present at the discretion of FMC. They may disappear or change meaning and format without warning, so caveat emptor.
* **com** *boolean*: Whether the mediator is a member of CoM.
* **fma** *boolean*: Whether the mediator is a member of FMA.
* **nfm** *boolean*: Whether the mediator is a member of NFM.
* **resolution** *boolean*: Whether the mediator is a member of Resolution.
* **adrg** *boolean*: Whether the mediator is a member of ADRG.
* **law_soc** *boolean*: Whether the mediator is a member of the Law Society.
* **ppc** *boolean*: Whether the mediator is a PPC (supervises other mediators).
* **ppc_urn** *string*: The URN of this mediator's PPC.
* **ppc_name** *string*: The name of this mediator's supervisor.
* **ppcs_previous_12_months** *string*: This mediator's supervisors in the previous 12 months, if they changed.
* **dbs_date** *date*: Date of the mediator's last DBS
* **trained_with** *string*: Organisation that trained this mediator.
* **training_date** *date*: Date on which this mediator started training.
* **accredited_for** *string*:
* **cpd_up_to_date** *string*:
