$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'lib/env'
require 'lib/mediators'

map '/api' do
  run API::App
end

map '/admin' do
  run Admin::App
end