Dir["#{__dir__}/tasks/*.rake"].each do |tasks|
  import tasks
end

task default: [:clean, :rubocop, :spec, :features]
