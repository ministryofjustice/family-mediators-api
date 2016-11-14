require_relative '../../support/helpers/temporary_workbook'


module UploadHelpers

  require_relative '../../support/helpers/spreadsheet_data'

  def upload_spreadsheet(spreadsheet)
    temp_workbook = TemporaryWorkbook.new(spreadsheet.headings, spreadsheet.data)
    visit 'http://localhost:9292/admin/upload'
    attach_file('spreadsheet_file', temp_workbook.file_path)
    find('input[type="submit"]').click
  end

end

World(UploadHelpers)