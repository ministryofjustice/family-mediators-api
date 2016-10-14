require 'codeclimate-test-reporter'

SimpleCov.formatters  = [SimpleCov::Formatter::HTMLFormatter]

SimpleCov.start do
  add_filter '/spec/'
end