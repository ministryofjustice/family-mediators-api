require 'bundler'
Bundler.require
Bundler.require(Sinatra::Base.environment)
require 'hanami/validations/form'
require 'logger'

require_relative 'admin/admin'
require_relative 'api/api'
require_relative 'documentation/app'
