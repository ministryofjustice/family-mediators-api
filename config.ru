$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'rack/protection'
require 'dotenv'
Dotenv::load

require 'lib/env'
require 'lib/mediators'

map '/robots.txt' do
  run Proc.new { [200, {'Content-Type' => 'text/plain'}, ["User-Agent: *\nDisallow: /"]] }
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
  TEN_MINUTES   = 60 * 10
  use Rack::Session::Pool, expire_after: TEN_MINUTES
  use Rack::Protection
  use Rack::Protection::AuthenticityToken, authenticity_param: 'token'
  run Admin::App
end
