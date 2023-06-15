ENV["RACK_ENV"] = "test"
require "simplecov"

require "capybara/cucumber"
require "capybara/poltergeist"

Capybara.server_port = 9292
Capybara.app = Rack::Builder.parse_file(File.expand_path("../../config.ru", __dir__)).first

ActiveRecord::Base.logger = nil # Get rid of Sinatra's noisy logging in tests

Dir["#{__dir__}/../../support/factories/*.rb"].each { |f| require f }
World(FactoryBot::Syntax::Methods)
