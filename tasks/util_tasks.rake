task :clean do
  directories = %w(coverage)
  directories.each do |dir|
    dir = "#{__dir__}/../#{dir}"
    FileUtils.rm_rf(dir) if File.exist?(dir)
  end
end