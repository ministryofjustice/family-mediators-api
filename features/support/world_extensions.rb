require_relative '../../support/helpers/temporary_workbook'

module UploadHelpers

  require_relative '../../support/helpers/spreadsheet_data'

  def upload_spreadsheet(headings, data)
    temp_workbook = TemporaryWorkbook.new(headings,data)
    visit 'http://localhost:9292/admin/upload'
    attach_file('spreadsheet_file', temp_workbook.file_path)
    find('input[type="submit"]').click
  end

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
    !data.empty? ? [data] : [[]]
  end

  def insert_practice(table_data)
    table_data[0] << 'md_practices'
    table_data[1..-1].each do |row|
      row << '15 Smith Street, London WC1R 4RL|01234567890'
    end
    table_data
  end

end

World(UploadHelpers)