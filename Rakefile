Dir["#{__dir__}/tasks/*.rake"].each do |tasks|
  import tasks
end

task default: [:clean, :spec, :coverage_check, 'rubocop:auto_correct', 'rubocop']