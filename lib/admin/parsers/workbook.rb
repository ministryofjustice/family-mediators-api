module Admin
  module Parsers
    class Workbook

      def initialize(workbook,
                     headings_processor: Admin::Processing::Headings)
        @workbook = workbook
        @headings_processor = headings_processor
      end

      def call
        data = transform_worksheet
        data = @data_parser.parse(data) if @data_parser
        data
      end

      private

      def transform_worksheet
        return [] if first_worksheet[0].nil?

        processed_headings = @headings_processor.process(
          first_worksheet[0].cells.map { |cell| cell.value }
        )

        first_worksheet[1..-1].map do |row|
          row.cells.each_with_index.inject({}) do |hash, (cell, index)|
            hash.merge({processed_headings[index] => cell.value.to_s})
          end
        end
      end

      def first_worksheet
        @workbook[0] if @workbook
      end

    end
  end
end