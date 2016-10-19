require 'bundler'
Bundler.require
Bundler.require(Sinatra::Base.environment)

require 'admin/admin'
require 'api/api'