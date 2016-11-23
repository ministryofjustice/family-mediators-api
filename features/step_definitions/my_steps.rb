Given(/^I upload a spreadsheet with (\d+) valid mediators/) do |valid_mediadator_count|
  spreadsheet_data = SpreadsheetData.new(valid_item_count: valid_mediadator_count.to_i)
  upload_spreadsheet(spreadsheet_data.headings, spreadsheet_data.data)
end

Given(/^I upload a spreadsheet with (\d+) errors$/) do |invalid_error_count|
  spreadsheet_data = SpreadsheetData.new(invalid_item_count: invalid_error_count.to_i)
  upload_spreadsheet(spreadsheet_data.headings, spreadsheet_data.data)
end

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
  table_data = table.raw
  table_data = insert_practice(table_data)
  headings = table_data[0]
  data = table_data[1..-1]
  upload_spreadsheet(headings, data)
end

And(/^I click to proceed from the overview page$/) do
  find_button('Process data and apply updates').click
end