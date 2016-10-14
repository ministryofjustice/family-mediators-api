LOGGER = Logger.new(STDOUT)
LOGGER.level = ENV['LOG_LEVEL'] ? Kernel.const_get("Logger::#{ENV['LOG_LEVEL']}") : Logger::DEBUG
LOGGER.info "LOG_LEVEL: #{LOGGER.level}"

if ENV['DATABASE_URL']
  LOGGER.info "Configuring DB connection from DATABASE_URL env var"
  OTR::ActiveRecord.configure_from_url! ENV['DATABASE_URL']
else
  LOGGER.info "Configuring DB connection from database.yml"
  OTR::ActiveRecord.configure_from_file! File.expand_path("../../config/database.yml", __FILE__)
end
