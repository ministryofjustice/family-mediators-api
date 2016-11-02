module Admin

  module Processing
    class Spreadsheet

      attr_reader :data, :parser

      def initialize(file_path, parser=nil)
        @file_path = file_path
        @parser = parser
      end

      def process
        extract_data
        # validate - this will come later
        @data = parser.parse(data) if parser
        save
      end

      private

      def save
        saved_data = []
        data.each do |item|
            saved_data << { data: item}
        end
        ActiveRecord::Base.transaction do
          API::Models::Mediator.delete_all
          API::Models::Mediator.create(saved_data)
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
