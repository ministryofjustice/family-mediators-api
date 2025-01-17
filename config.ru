$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

$stdout.sync = true

require 'dotenv'
Dotenv::load


require 'sentry-ruby'

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  # get breadcrumbs from logs
  config.breadcrumbs_logger = [:sentry_logger, :http_logger]
end

use Sentry::Rack::CaptureExceptions

require "prometheus_middleware"
use PrometheusMiddleware

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
