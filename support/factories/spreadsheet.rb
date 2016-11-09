module Support
  module Factories
    class Spreadsheet
      def self.build(headings, row_data)
        workbook = RubyXL::Workbook.new
        worksheet = workbook[0]
        set_headings(headings, worksheet)
        set_data(row_data, worksheet)
        workbook
      end

      def self.set_data(row_data, worksheet)
        row_data.each_with_index do |row, row_index|
          row.each_with_index do |cell_value, cell_index|
            worksheet.add_cell(row_index+1, cell_index, cell_value)
          end
        end
      end

      def self.set_headings(headings, worksheet)
        headings.each_with_index do |heading, index|
          worksheet.add_cell(0, index, heading)
        end
      end
    end
  end
end
