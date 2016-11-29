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
  mediators_data_table = MediatorsDataTable.new(table.raw)
  with_practice_data = PracticeData.new(mediators_data_table)
  upload_spreadsheet(with_practice_data.headings, with_practice_data.data)
end

Given(/^I upload a mediator with practice data (.*)/) do |practice_data|
  valid_mediator = {
      'Registration No' => '1234A',
      'md_offers_dcc' => 'Y',
      'md_first_name' => 'John',
      'md_last_name' => 'Smith',
      'md_mediation_legal_aid' => 'Y',
      'md_ppc_id' => 'not known',
      'fmca_cert' => 'unknown'
  }
  valid_mediator.merge!('md_practices' => practice_data)
  headings = valid_mediator.keys
  data = [valid_mediator.values]
  upload_spreadsheet(headings, data)

  mediators_data_table = MediatorsDataTable.create_mediator()
  with_practice_data = PracticeData.new(mediators_data_table, practice_data: practice_data)

end

class PracticeData
  extend Forwardable
  delegate [:each] => :@mediators

  def initialize(data_table, practice_data: '15 Smith Street, London WC1R 4RL|01234567890')
    @mediators = data_table
    @practice_data = practice_data
  end

  def headings
    @mediators[0] << 'md_practices'
  end

  def data
    @mediators[1..-1].map do |row|
      row << @practice_data
    end
  end
end

class MediatorsDataTable
  extend Forwardable
  delegate [:each, :[]] => :@mediators

  def initialize(data_table)
    @mediators = data_table
  end

  def headings
    @mediators[0]
  end

  def data
    @mediators[1..-1]
  end
end