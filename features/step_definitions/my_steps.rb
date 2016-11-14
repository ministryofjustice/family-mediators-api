Given(/^I upload a spreadsheet with (\d+) valid mediators/) do |valid_mediadator_count|
  spreadsheet_data = SpreadsheetData.new(valid_item_count: valid_mediadator_count.to_i)
  upload_spreadsheet(spreadsheet_data)
end

Given(/^I upload a spreadsheet with (\d+) errors$/) do |invalid_error_count|
  spreadsheet_data = SpreadsheetData.new(invalid_item_count: invalid_error_count.to_i)
  upload_spreadsheet(spreadsheet_data)
end

When(/^I visit '(.*)'$/) do |endpoint|
  url = "http://localhost:9292#{endpoint}"
  visit url
end

Given(/^there's (\d+) records in the database$/) do |num|
  create_list(:mediator, num.to_i)
end