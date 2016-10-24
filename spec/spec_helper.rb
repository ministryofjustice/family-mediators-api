ENV['RACK_ENV'] = 'test'
require 'simplecov'
$LOAD_PATH.unshift("#{__dir__}/..")

require 'lib/env'
require 'lib/mediators'

require 'factories/mediator'

def fixture_path file
  File.expand_path("../support/fixtures/#{file}", __FILE__)
end

def delete_uploads
  upload_dir = File.expand_path('../../public/uploads', __FILE__)
  Dir["#{upload_dir}/*"].each do |file|
    File.delete file
  end
end

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
