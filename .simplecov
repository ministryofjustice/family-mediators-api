SimpleCov.formatters  = [SimpleCov::Formatter::HTMLFormatter]

SimpleCov.start do
  add_group "API", "lib/api"
end