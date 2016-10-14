Dir["#{__dir__}/tasks/*.rake"].each do |tasks|
  import tasks
end

task default: [:spec, 'rubocop:auto_correct', 'rubocop']