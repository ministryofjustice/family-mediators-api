ROOT_DIR = File.dirname(__FILE__)
$LOAD_PATH.unshift("#{ROOT_DIR}/lib")

require 'mediators_api'

run MediatorsApi
