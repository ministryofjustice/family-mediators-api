if Gem::Specification.all_names.grep(/^rspec-core/).any?
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do
    ENV['coverage'] = 'true'
  end
end
