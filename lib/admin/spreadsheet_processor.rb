module Admin

  class SpreadsheetProcessor
    def initialize file_path
      @workbook = RubyXL::Parser.parse file_path
    end

    def process
      # read
      extract_data
      extract_headers
      # validate TODO
      create_mediators
    end

    private

    def create_mediators
      @data.each do |mediator_row|
        row_data = {}
        mediator_row.each_with_index do |value, index|
          row_data[@headings[index]] = value
        end

        API::Models::Mediator.create(data: row_data.to_json)
      end
    end

    def extract_data
      @data ||= @workbook[0].inject([]) do |row_result, row |
        cells = row.cells.map do |cell|
          cell && cell.value.to_s || ''
        end
        row_result << cells
        row_result
      end
    end

    def extract_headers
      headings = @data.shift
      @headings = HeadingsProcessor.process(headings)
    end
  end
end
