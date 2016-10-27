module Admin
  module Processing
    class Spreadsheet
      PRACTICES_HEADING = 'md_practices'

      def initialize file_path
        @file_path = file_path
      end

      def process
        # read
        extract_data
        extract_headers
        # validate - this will come later
        create_mediators
      end

      private

      def create_mediators
        @data.each do |mediator_row|
          row_data = {}
          mediator_row.each_with_index do |value, index|
            if @headings[index] == PRACTICES_HEADING
              row_data[@headings[index]] = PracticeParser.parse(value)
            else
              row_data[@headings[index]] = value
            end
          end

          API::Models::Mediator.create(data: row_data.to_json)
        end
      end

      def extract_data
        raise "File not found: #{@file_path}" unless File.exist?(@file_path)

        workbook = RubyXL::Parser.parse @file_path

        @data ||= workbook[0].inject([]) do |row_result, row |
          cells = row.cells.map do |cell|
            cell && cell.value.to_s || ''
          end
          row_result << cells
          row_result
        end
      end

      def extract_headers
        headings = @data.shift
        @headings = Headings.process(headings)
      end
    end
  end
end
