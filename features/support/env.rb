ENV['RACK_ENV'] = 'test'

require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.server_port = 9292
Capybara.default_driver = :poltergeist
Capybara.app = Rack::Builder.parse_file(File.expand_path('../../config.ru', __dir__)).first

