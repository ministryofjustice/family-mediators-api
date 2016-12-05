require 'base64'
require 'zlib'

require_relative 'parsers/mediator_parser'
require_relative 'parsers/practice'
require_relative 'parsers/workbook'
require_relative 'validators/mediator_validations'
require_relative 'validators/file_validator'
require_relative 'processing/data_store'
require_relative 'processing/headings'
require_relative 'processing/marshaler'
require_relative 'services/process_file'
require_relative 'services/process_data'
require_relative 'helpers'
require_relative 'app'