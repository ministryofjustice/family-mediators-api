if Gem::Specification.all_names.grep(/^rubocop/).any?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
