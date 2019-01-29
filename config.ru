$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

$stdout.sync = true

require 'dotenv'
Dotenv::load

require 'raven'
use Raven::Rack # will use SENTRY_DSN env variable, if set

require 'lib/env'
require 'lib/mediators'

map '/robots.txt' do
  run Proc.new { [200, {'Content-Type' => 'text/plain'}, ["User-Agent: *\nDisallow: /"]] }
end

map '/' do
  run Proc.new { [302, {'Location' => '/admin'}, []] }
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
