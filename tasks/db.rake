$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require "bundler/setup"
load "tasks/otr-activerecord.rake"

namespace :db do
  # Some db tasks require your app code to be loaded; they'll expect to find it here
  task :environment do
    require 'env'
    require 'mediators'
  end
end