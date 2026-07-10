require "capybara/rspec"

Capybara.app = Rack::Builder.parse_file(File.expand_path("../../config.ru", __dir__))
