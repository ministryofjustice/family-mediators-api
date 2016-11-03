module Admin

  module Processing
    class Spreadsheet

      attr_reader :data, :parser

      def initialize(file_path, parser = nil)
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

        headings = Headings.process(workbook.delete_row(0).cells.map {|cell| cell.value})

        @data = workbook.map do |row|
          row.cells.each_with_index.inject({}) do |hash, (cell, index)|
            hash.merge({ headings[index] => cell.value.to_s })
          end
        end
      end

      def workbook
        @workbook ||= RubyXL::Parser.parse(@file_path)[0]
      end

    end
  end
end
