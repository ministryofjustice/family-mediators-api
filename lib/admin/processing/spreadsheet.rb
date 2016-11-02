module Admin
  module Processing
    class Spreadsheet
      PRACTICES_HEADING = 'md_practices'

      attr_reader :data

      def initialize(file_path)
        @file_path = file_path
      end

      def process
        extract_data

        # validate - this will come later
        create_mediators
      end

      private

      def create_mediators
        mediators = @data.map do |mediator|
          if mediator[PRACTICES_HEADING]
            mediator[PRACTICES_HEADING] = PracticeParser.parse(mediator[PRACTICES_HEADING])
          end

          { 'data' => mediator }
        end

        ActiveRecord::Base.transaction do
          API::Models::Mediator.delete_all
          API::Models::Mediator.create(mediators)
        end
      end

      def extract_data
        raise "File not found: #{@file_path}" unless File.exist?(@file_path)

        workbook = RubyXL::Parser.parse @file_path

        data = workbook[0].inject([]) do |row_result, row |
          cells = row.cells.map do |cell|
            cell && cell.value.to_s || ''
          end
          row_result << cells
          row_result
        end

        headings = Headings.process(data.shift)

        mediators = []

        data.each do |mediator_row|
          row_data = {}
          mediator_row.each_with_index do |value, index|
            row_data[headings[index]] = value
          end
          mediators << row_data
        end

        @data = mediators
      end

    end
  end
end
