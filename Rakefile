require "bundler/setup"
load "tasks/otr-activerecord.rake"

namespace :db do
  # Some db tasks require your app code to be loaded; they'll expect to find it here
  task :environment do
    require_relative 'lib/mediators'
  end
end

Dir["#{__dir__}/tasks/*.rake"].each do |tasks|
  import tasks
end

task default: [:spec, 'rubocop:auto_correct', 'rubocop']
