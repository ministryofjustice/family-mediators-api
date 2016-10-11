require 'grape'
require 'grape-entity'
require 'otr-activerecord'

require_relative 'mediators/models/mediator'
require_relative 'mediators/entities/mediator'
require_relative 'mediators/api'

OTR::ActiveRecord.configure_from_file! File.expand_path("../../config/database.yml", __FILE__)
