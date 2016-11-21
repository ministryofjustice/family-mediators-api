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

end

World(UploadHelpers)