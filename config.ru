$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'dotenv'
Dotenv::load

require 'lib/env'
require 'lib/mediators'

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
