Dir["#{__dir__}/tasks/*.rake"].each do |tasks|
  import tasks
end

task default: %i[clean rubocop spec features]
