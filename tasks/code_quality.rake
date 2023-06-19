if Gem::Specification.all_names.grep(/^rubocop/).any?
  require "rubocop/rake_task"

  require_relative "support/console"
  RuboCop::RakeTask.new

  desc "Coverage check"
  task coverage_check: :environment do
    required_percentage = 100
    percentage = JSON(File.read("#{__dir__}/../coverage/.last_run.json"))["result"]["covered_percent"]
    unless percentage == required_percentage
      Console.error "Expected coverage: #{required_percentage}% got: #{percentage}%"
      exit 0
    end
  end
end
