require "bundler/setup"
require "active_record"

module Rails
  def self.root
    File.dirname(__FILE__)
  end

  def self.env
    ENV["RACK_ENV"]
  end

  def self.application
    Paths.new
  end
end

class Paths
  def paths
    { "db/migrate" => [File.expand_path("../db/migrate", __dir__)] }
  end

  def load_seed
    load File.expand_path("../db/seeds.rb", __dir__)
  end
end

include ActiveRecord::Tasks

db_dir = File.expand_path("../db", __dir__)
config_dir = File.expand_path("../config", __dir__)

DatabaseTasks.root = File.dirname(__FILE__)
DatabaseTasks.env = ENV["RACK_ENV"] || "development"
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(config_dir, "database.yml")))
DatabaseTasks.migrations_paths = File.join(db_dir, "migrate")

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load "active_record/railties/databases.rake"
