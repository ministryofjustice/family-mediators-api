module Admin

  module Processing
    class Spreadsheet

      def initialize(xl_parser: RubyXL::Parser,
                     data_parser: Admin::Parsers::Mediators.new)
        @xl_parser = xl_parser
        @data_parser = data_parser
      end

      def save(array) # TODO
        saved_data = array.map { |item| {'data' => item} }

        ActiveRecord::Base.transaction do
          API::Models::Mediator.delete_all
          API::Models::Mediator.create(saved_data)
        end
      end

      def read(path)
        @workbook = @xl_parser.parse(path)
      end

      def to_a
        @as_array ||= build_array_from_worksheet
      end

      private

      def build_array_from_worksheet
        data = transform_worksheet
        data = @data_parser.parse(data) if @data_parser
        data
      end

      def transform_worksheet
        return [] if first_worksheet[0].nil?

        processed_headings = Headings.process(
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
