Given(/^I upload a spreadsheet with (\d+) warnings and (\d+) errors$/) do |_warn_count, fatal_count|
  headings = [ 'registration no', 'md offers dc' ]
  data = [
      [ '0123T', 'Y' ],
      [ '0124T', 'Y' ],
  ]
  fatal_count.to_i.times do
    data << [ nil, 'Y' ]
  end
  file_path = make_workbook_file(headings, data)
  visit 'http://localhost:9292/admin/upload'
  attach_file('spreadsheet_file', file_path)
  find('input[type="submit"]').click
end

When(/^I visit '(.*)'$/) do |endpoint|
  url = "http://localhost:9292#{endpoint}"
  visit url
end

Given(/^there's (\d+) records in the database$/) do |num|
  create_list(:mediator, num.to_i)
end

Given(/^I upload a spreadsheet with (\d+) fatal errors$/) do |_num|
  headings = [ 'Registration No' ]
  data = [
      [ '0123T' ]
  ]
  file_path = make_workbook_file(headings, data)
  visit 'http://localhost:9292/admin/upload'
  attach_file('spreadsheet_file', file_path)
  find('input[type="submit"]').click
end

def make_workbook_file(headings, data)
  dir = Dir.mktmpdir
  file = File.new("#{dir}/foo.xlsx", 'w+')
  workbook = Support::Factories::Spreadsheet.build(headings, data)
  workbook.write(file.path)
  file.path
end

