require 'grape'
require 'mongoid'

require_relative 'mediators/models/mediator'
require_relative 'mediators/api'

Mongoid.load! 'config/mongoid.config'
