module Admin
  module Parsers
    # Takes a workbook as parsed from an XLSX file by the rubyXL gem, and
    # converts the first worksheet (the mediator data) into an array of
    # hashes, and the second worksheet (column blacklist) into an array
    # of strings.
    class Workbook
      MEDIATORS_WORKSHEET = 0
      BLACKLIST_WORKSHEET = 1

      def initialize(rubyxl_workbook,
                     headings_processor: Admin::Processing::Headings)
        @rubyxl_workbook = rubyxl_workbook
        @headings_processor = headings_processor
      end

      def call
        [parse_mediators, processed_blacklist]
      end

    private

      def parse_mediators
        as_hashes = transform_mediators
        remove_blank_rows(as_hashes)
      end

      def parse_blacklist
        blacklist_worksheet[1..].map { |row| row.cells.first.value }
      end

      def processed_blacklist
        @headings_processor.process(parse_blacklist)
      end

      def remove_blank_rows(hashes)
        hashes.each_with_object([]) do |row, compacted|
          compacted << row unless all_values_blank?(row)
        end
      end

      def all_values_blank?(row)
        row.values.all? { |val| (val && val.empty?) || val.nil? }
      end

      def transform_mediators
        return [] if mediators_worksheet[0].nil?

        mediators_worksheet[1..].map do |row|
          processed_headings.size.times.inject({}) do |hash, index|
            cell = row.cells[index]
            value = cell&.value
            hash.merge({ processed_headings[index].to_sym => value })
          end
        end
      end

      def processed_headings
        @_processed_headings ||= @headings_processor.process(
          mediators_worksheet[0].cells.map(&:value),
        )
      end

      def mediators_worksheet
        @rubyxl_workbook[MEDIATORS_WORKSHEET] if @rubyxl_workbook
      end

      def blacklist_worksheet
        @rubyxl_workbook[BLACKLIST_WORKSHEET] if @rubyxl_workbook
      end
    end
  end
end
