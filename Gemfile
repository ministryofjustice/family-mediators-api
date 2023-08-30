# frozen_string_literal: true
source 'https://rubygems.org'

ruby File.read('.ruby-version')

gem 'activerecord', '< 8.0.0'
gem 'bcrypt'
gem 'dotenv'
gem 'dry-validation'
gem 'grape', '~> 1.7', '>= 1.7.1'
gem 'grape-entity'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'rubyXL'
gem 'sentry-raven', '~> 3.0'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'slim', '< 4.0.0'

group :test do
  gem 'cucumber', '< 4.0.0'
  gem 'poltergeist', ">= 1.4.0"
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'debug', '~> 1.8'
  gem 'factory_bot'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'rubocop', '~> 1.51', require: false
  gem 'rubocop-performance', '~> 1.18', require: false
  gem 'rubocop-rails', '~> 2.19', '>= 2.19.1', require: false
  gem 'simplecov', require: false
end

group :test, :development do
  gem 'brakeman'
end
