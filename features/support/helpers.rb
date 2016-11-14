require_relative '../../support/helpers/temporary_workbook'

module UploadHelpers

  def upload_spreadsheet(headings, data)
    temp_workbook = TemporaryWorkbook.new(headings, data)
    visit 'http://localhost:9292/admin/upload'
    attach_file('spreadsheet_file', temp_workbook.file_path)
    find('input[type="submit"]').click
  end

  def headings
    ['registration no', 'md offers dcc', 'md_first_name', 'md_last_name', 'md_mediation_legal_aid']
  end

  def valid_data
    [%w(0123T Y John Doe N), %w(0124T Y Jane Smith Y)]
  end

  def fatal_data_sample
    [ nil, 'Y' ]
  end

end

World(UploadHelpers)