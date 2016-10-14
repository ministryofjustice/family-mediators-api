$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'lib/env'
require 'lib/mediators'

run Mediators::API
