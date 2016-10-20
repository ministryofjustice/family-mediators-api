if Gem::Specification.all_names.grep(/^rspec-core/).any?
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do
    ENV['coverage'] = 'true'
  end

  require 'cucumber'
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "mode=regression features --format pretty"
    ENV['coverage'] = 'true'
  end
end
