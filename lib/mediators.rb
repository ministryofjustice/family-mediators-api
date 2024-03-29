LOGGER = Logger.new($stdout)
LOGGER.level = ENV["LOG_LEVEL"] ? ENV["LOG_LEVEL"].to_sym : Logger::DEBUG
LOGGER.info "LOG_LEVEL: #{LOGGER.level}"

db_config = YAML.load_file(File.expand_path("../config/database.yml", __dir__), aliases: true)

# :nocov:
if %w[staging production].include?(ENV["RACK_ENV"])
  db_config[ENV["RACK_ENV"]] = { "url" => ENV["DATABASE_URL"] }
end
# :nocov:

ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
