require 'logger'
require 'grape'
require 'grape-entity'
require 'otr-activerecord'

require_relative 'mediators/models/mediator'
require_relative 'mediators/entities/mediator'
require_relative 'mediators/api'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::DEBUG

if ENV['DATABASE_URL']
  LOGGER.info "Configuring DB connection from DATABASE_URL env var"
  OTR::ActiveRecord.configure_from_url! ENV['DATABASE_URL']
else
  LOGGER.info "Configuring DB connection from database.yml"
  OTR::ActiveRecord.configure_from_file! File.expand_path("../../config/database.yml", __FILE__)
end
