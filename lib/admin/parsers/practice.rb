module Admin
  module Parsers

    # Parse a string of practices into an array of hashes.
    class Practice
      RECORD_SEPARATOR = "\n"

      attr_reader :warnings

      def initialize
        @warnings = []
      end

      def parse(practices_data, line_parser = PracticeLine.new)
        practices = split_into_lines(practices_data).map.each_with_index do |practice_line, index|
          line_parser.to_h(practice_line, index+1)
        end

        @warnings = line_parser.warnings
        practices
      end

      private

      def split_into_lines(practices_data)
        practices_data && practices_data.split(RECORD_SEPARATOR) || []
      end

    end
  end
end
