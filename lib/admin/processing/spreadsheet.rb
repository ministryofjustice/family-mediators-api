module Admin

  module Processing
    class Spreadsheet

      attr_reader :parser

      def initialize(workbook, parser = nil)
        @workbook = workbook
        @parser = parser
      end

      def process
        data = to_hash
        data = parser.parse(data) if parser
        # save(data)
        data
      end

      def save(data)
        saved_data = data.map { |item| {'data' => item} }

        ActiveRecord::Base.transaction do
          API::Models::Mediator.delete_all
          API::Models::Mediator.create(saved_data)
        end
      end

      private

      def to_hash
        processed_headings = Headings.process(first_worksheet[0].cells.map { |cell| cell.value })

        first_worksheet[1..-1].map do |row|
          row.cells.each_with_index.inject({}) do |hash, (cell, index)|
            hash.merge({ processed_headings[index] => cell.value.to_s })
          end
        end
      end

      def first_worksheet
        @workbook[0]
      end

    end
  end
end
