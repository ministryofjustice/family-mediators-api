When(/^I visit '(.*)'$/) do |endpoint|
  url = "http://localhost:9292#{endpoint}"
  visit url
end

When(/I click '(.*)'$/) do |text|
  find_button(text).click
end

Given(/^there's (\d+) records in the database$/) do |num|
  create_list(:mediator, num.to_i)
end

Given(/^I upload a spreadsheet like this:$/) do |table|
  mediators_data_table = DataHelpers::MediatorsDataTable.new(table.raw)
  with_practice_data =DataHelpers:: PracticeData.new(mediators_data_table)
  upload_spreadsheet(with_practice_data.headings, with_practice_data.data)
end

Given(/^I upload a mediator with practice data (.*)/) do |practice_data|
  mediators_data_table = DataHelpers::MediatorsDataTable.create_mediator()
  with_practice_data = DataHelpers::PracticeData.new(mediators_data_table, practice_data: practice_data)
  upload_spreadsheet(with_practice_data.headings, with_practice_data.data)
end