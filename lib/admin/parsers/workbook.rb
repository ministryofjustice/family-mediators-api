module Admin
  module Parsers

    # Takes a workbook as parsed from an XLSX file by the rubyXL gem, and
    # converts the first worksheet into an array of hashes.
    class Workbook
      WORKSHEET = 0

      def initialize(rubyxl_workbook,
                     headings_processor: Admin::Processing::Headings)
        @rubyxl_workbook = rubyxl_workbook
        @headings_processor = headings_processor
      end

      def call
        as_hashes = transform_worksheet
        as_hashes = @data_parser.parse(as_hashes) if @data_parser
        as_hashes
      end

      private

      def transform_worksheet
        return [] if worksheet[0].nil?

        processed_headings = @headings_processor.process(
          worksheet[0].cells.map { |cell| cell.value }
        )

        worksheet[1..-1].map do |row|
          row.cells.each_with_index.inject({}) do |hash, (cell, index)|
            hash.merge({processed_headings[index].to_sym => cell.value.to_s})
          end
        end
      end

      def worksheet
        @rubyxl_workbook[WORKSHEET] if @rubyxl_workbook
      end

    end
  end
end