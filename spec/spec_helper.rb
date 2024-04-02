require "simplecov"
require "simplecov-json"
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
])

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/features/"
  add_group "API", "lib/api"
  add_group "Admin", "lib/admin"
end

ENV["RACK_ENV"] = "test"
$LOAD_PATH.unshift("#{__dir__}/..")

require "dotenv"
Dotenv.load

require "lib/env"
require "lib/root_app"
require "lib/mediators"

Dir["#{__dir__}/../support/factories/*.rb"].each { |f| require f }
Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

ActiveRecord::Base.logger = nil # Get rid of Sinatra's noisy logging in tests
