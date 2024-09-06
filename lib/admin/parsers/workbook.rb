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
        Processing::RecordRemover.new(transform_mediators).call
      end

      def parse_blacklist
        blacklist_worksheet[1..].map { |row| row.cells.first.value }
      end

      def processed_blacklist
        @headings_processor.call(parse_blacklist)
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
        @processed_headings ||= @headings_processor.process(
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
