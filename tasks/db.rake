$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require "bundler/setup"
load "tasks/otr-activerecord.rake"

namespace :db do
  task :environment do
    require 'env'
    require 'mediators'
  end
end