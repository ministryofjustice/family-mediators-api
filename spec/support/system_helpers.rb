require_relative "../../support/helpers/temporary_workbook"

module UploadHelpers
  def upload_spreadsheet(headings, data, blacklist = [])
    temp_workbook = TemporaryWorkbook.new(headings, data, blacklist)
    visit "/admin/upload"
    attach_file("spreadsheet_file", temp_workbook.file_path)
    find('input[type="submit"]').click
  end
end

module ObservationHelpers
  def get_table_data(selector)
    data = page.all("#{selector} tr").collect do |row|
      row.all(:xpath, ".//th|td").collect(&:text)
    end
    !data.empty? ? data : [[]]
  end
end

module DataHelpers
  class PracticeData
    extend Forwardable
    delegate [:each] => :@mediators

    def initialize(data_table, practice_data: "15 Smith Street, London WC1R 4RL|01234567890")
      @mediators = data_table
      @practice_data = practice_data
    end

    def headings
      @mediators[0] << "Practices"
    end

    def data
      @mediators[1..].map do |row|
        row << @practice_data
      end
    end
  end

  class MediatorsDataTable
    extend Forwardable
    delegate %i[each []] => :@mediators

    def initialize(data_table)
      @mediators = data_table
    end

    def headings
      @mediators[0]
    end

    def data
      @mediators[1..]
    end

    class << self
      def create_mediator
        mediator = {
          "URN" => "1234A",
          "DCC" => "Yes",
          "Title" => "Mr",
          "First Name" => "John",
          "Last Name" => "Smith",
          "FMCA Date" => "27/03/2001",
          "Legal Aid Qualified" => "Yes",
          "Legal Aid Franchise" => "No",
          "PPC URN" => "",
        }
        new([mediator.keys, mediator.values])
      end
    end
  end
end

module AuthenticationHelpers
  def login
    visit "/admin/login"
    fill_in "username", with: "username"
    fill_in "password", with: "password"
    click_button "Login"
  end
end

RSpec.configure do |config|
  config.include UploadHelpers, type: :feature
  config.include ObservationHelpers, type: :feature
  config.include AuthenticationHelpers, type: :feature
end
