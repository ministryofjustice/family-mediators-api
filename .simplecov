SimpleCov.formatters  = [SimpleCov::Formatter::HTMLFormatter]

if ENV['coverage'] == 'true'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/features/'
    add_group "API", "lib/api"
    add_group "Admin", "lib/admin"
  end
end