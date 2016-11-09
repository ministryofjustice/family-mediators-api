Given(/^I upload a spreadsheet with (\d+) warnings and (\d+) errors$/) do |_warn_count, fatal_count|
  data = valid_data
  fatal_count.to_i.times do
    data << fatal_data_sample
  end
  upload_spreadsheet(headings, data)
end

When(/^I visit '(.*)'$/) do |endpoint|
  url = "http://localhost:9292#{endpoint}"
  visit url
end

Given(/^there's (\d+) records in the database$/) do |num|
  create_list(:mediator, num.to_i)
end