<div align="center">

<a id="readme-top"></a>

<br>

<img alt="MoJ logo" src="https://moj-logos.s3.eu-west-2.amazonaws.com/moj-uk-logo.png" width="200">

# Family Mediators API

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Ffamily-mediators-api&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/family-mediators-api)

</div>

Maintains a list of family mediators. Provides an API and an admin UI for uploading spreadsheets of mediator data .

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
