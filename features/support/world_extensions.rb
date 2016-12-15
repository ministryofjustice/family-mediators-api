require_relative '../../support/helpers/temporary_workbook'

module UploadHelpers

  def upload_spreadsheet(headings, data)
    temp_workbook = TemporaryWorkbook.new(headings,data)
    visit 'http://localhost:9292/admin/upload'
    attach_file('spreadsheet_file', temp_workbook.file_path)
    find('input[type="submit"]').click
  end

end

module ObservationHelpers
  def get_table_data(selector)
    data = page.all(selector + ' tr').collect do |row|
      row.all(:xpath, './/th|td').collect do |cell|
        cell.text
      end
    end
    !data.empty? ? data : [[]]
  end

  def get_column_data(selector,position)
    data = page.all(selector + " tr td[#{position}]").collect { |cell| cell.text }
    !data.empty? ? data : []
  end
end

module DataHelpers
  class PracticeData
    extend Forwardable
    delegate [:each] => :@mediators

    def initialize(data_table, practice_data: '15 Smith Street, London WC1R 4RL|01234567890')
      @mediators = data_table
      @practice_data = practice_data
    end

    def headings
      @mediators[0] << 'Practices'
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

    class << self
      def create_mediator
        mediator = {
            'URN' => '1234A',
            'DCC' => 'Yes',
            'Title' => 'Mr',
            'First Name' => 'John',
            'Last Name' => 'Smith',
            'Legal Aid Qualified' => 'Yes',
            'Legal Aid Franchise' => 'No',
            'PPC URN' => 'not known'
        }
        new([mediator.keys, mediator.values])
      end
    end
  end
end

module AuthenticationHelpers
  def login
    visit 'http://localhost:9292/admin/login'
    fill_in 'username', :with => 'username'
    fill_in 'password', :with => 'password'
    click_button 'Login'
  end
end

World(UploadHelpers)
World(ObservationHelpers)
World(DataHelpers)
World(AuthenticationHelpers)