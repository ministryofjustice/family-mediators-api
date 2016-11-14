class TemporaryWorkbook
  def initialize headings, data
    dir = Dir.mktmpdir
    @file = File.new("#{dir}/foo.xlsx", 'w+')
    workbook = Support::Factories::Spreadsheet.build(headings, data)
    workbook.write(@file.path)
  end

  def file_path
    @file.path
  end
end