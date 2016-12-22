# Family Mediators API
[![Travis CI](https://travis-ci.org/ministryofjustice/family-mediators-api.svg?branch=master)](https://travis-ci.org/ministryofjustice/family-mediators-api)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/family-mediators-api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/family-mediators-api)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/family-mediators-api/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/family-mediators-api/coverage)

Maintains a list of family mediators. Provides an API and an HTML admin UI for
uploading spreadsheets of mediator data. 


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

The coverage report is available under `/coverage/index.html`


## Play around in IRB

    RACK_ENV=development irb
    irb> require_relative 'lib/mediators'
    irb> Mediators::Models::Mediator.all.to_a
    irb> ...etc


## Deploy to cloud development environment via Tsuru

See [MoJ Tsuru documentation](https://docs.google.com/document/d/11xQRRJ_KH4Oipn9qYCt-wk-PEaUbUrrd8pLCi1pijLE/)

## API Doc

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

