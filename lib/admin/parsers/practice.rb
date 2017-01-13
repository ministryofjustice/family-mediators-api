module Admin
  module Parsers

    # Attempts to identify each of the four parts of the practice raising
    # warnings for parts not identified.
    #
    # The regular expressions are designed to identify their part beyond
    # reasonable doubt - not to validate it - that's done later by the various
    # validators. For this reason they are all quite lax with the
    # exception of the postcode regex in the address matcher. Conversly, they
    # need to be specific enough so as not to match any other parts.
    #
    # This approach avoids skipping unidentified parts which could have
    # recieved a validation warning later - which is more useful to the user.
    class Practice
      RECORD_SEPARATOR = "\n"
      PART_SEPARATOR = '|'

      MATCHERS = {
        address: /((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[A-Z]?[0-9][ABD-HJLNP-UW-Z]{2}))/i,
        url: /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/i,
        tel: /[\d\s]{8,12}/
        email: /@/,
      }

      attr_reader :warnings

      def initialize
        @warnings = []
      end

      def parse(practices_data)
        @warnings = []
        split_into_lines(practices_data).map.each_with_index do |practice_line, index|
          parse_practice(practice_line, index + 1)
        end
      end

      private

      def split_into_lines(practices_data)
        practices_data && practices_data.split(RECORD_SEPARATOR) || []
      end

      def parse_practice(practice_line, practice_num)
        practice_hash = {}
        parts = split_into_parts(practice_line).compact

        MATCHERS.each do |key, regex|
          matches = parts.grep(regex)
          practice_hash[key] = matches.first
          parts.delete(matches.first)
        end

        @warnings += parts.map { |part| "Practice #{practice_num}: Could not identify: #{part}" }
        practice_hash
      end

      def split_into_parts(practice_line)
        practice_line.split(PART_SEPARATOR).map { |part| sanitise(part) }
      end

      def sanitise(string)
        string.strip.squeeze(' ')
      end

    end
  end
end
