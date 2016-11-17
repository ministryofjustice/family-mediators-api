require 'bundler'
Bundler.require
Bundler.require(Sinatra::Base.environment)
require 'hanami/validations/form'

require 'admin/admin'
require 'api/api'
require 'documentation/app'