source "https://rubygems.org"

ruby file: ".ruby-version"

gem "activerecord", ">= 7.2"
gem "bcrypt"
gem "dotenv"
gem "dry-validation"
gem "grape", "~> 2.1"
gem "grape-entity"
gem "pg"
gem "prometheus_exporter"
gem "puma"
gem "rake"
gem "rubyXL"
gem "sentry-ruby"
gem "sinatra", ">= 4"
gem "sinatra-contrib"
gem "slim", "< 6.0.0"

group :test do
  gem "cucumber", "< 10.0.0"
  gem "database_cleaner"
  gem "debug", "~> 1.9"
  gem "factory_bot"
  gem "poltergeist", ">= 1.4.0"
  gem "rack-test", require: "rack/test"
  gem "rspec"
  gem "rubocop-govuk", require: false
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "simplecov-json", require: false
end

group :test, :development do
  gem "brakeman"
end

group :development do
  gem "rack-console"
end
