module Admin
  module Parsers

    # Identifies each of the four parts of the practice string raising
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
    class PracticeLine
      PART_SEPARATOR = '|'

      MATCHERS = {
        address: /((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[A-Z]?[0-9][ABD-HJLNP-UW-Z]{2}))/i,
        url: /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/i,
        email: /@/,
        tel: /[\d\s-]{8,12}/
      }

      attr_reader :warnings

      def initialize
        @warnings = []
      end

      def parse(line, practice_num)
        parts = split_into_parts(line)
        practice_hash = {}
        unmatched = allocate_matches(parts, practice_hash)
        add_to_warnings(unmatched, practice_num) if unmatched.any?
        practice_hash
      end

      private

      def add_to_warnings(parts, practice_num)
        @warnings += parts.map { |part| "Practice #{practice_num}: Could not identify: #{part}" }
      end

      def allocate_matches(parts, practice_hash)
        MATCHERS.inject(parts) do |parts_to_match, (key, regex)|
          matches = parts_to_match.grep(regex)
          practice_hash[key] = matches.first
          parts_to_match.delete(practice_hash[key])
          parts_to_match
        end
      end

      def split_into_parts(line)
        line.split(PART_SEPARATOR).map { |part| sanitise(part) } .compact
      end

      def sanitise(string)
        string.strip.squeeze(' ') unless string.blank?
      end
    end

  end
end
