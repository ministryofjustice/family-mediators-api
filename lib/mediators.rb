require 'grape'
require 'mongoid'

require 'mediators/models/mediator'
require 'mediators/api'

Mongoid.load! 'config/mongoid.config'
