Dir["#{__dir__}/tasks/*.rake"].each do |tasks|
  import tasks
end

task default: ['coverage:clean', :spec, :features, 'rubocop:auto_correct', 'rubocop']
