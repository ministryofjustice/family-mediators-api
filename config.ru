$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

$stdout.sync = true

require 'dotenv'
Dotenv::load

require 'raven'
use Raven::Rack # will use SENTRY_DSN env variable, if set

require 'lib/env'
require 'lib/root_app'
require 'lib/mediators'

map '/' do
  run RootApp
end

map '/api' do
  map '/' do
    run API::App
  end

  map '/documentation' do
    run Documentation::App
  end
end

map '/admin' do
  run Admin::App
end
