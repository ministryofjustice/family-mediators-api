module Admin
  module Parsers
    class Practice
      RECORD_SEPARATOR = "\n"
      PART_SEPARATOR = '|'
      EMAIL_REGEX = /@/i
      TEL_REGEX = /[\d\s]{8,12}/
      POSTCODE_REGEX = /((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[A-Z]?[0-9][ABD-HJLNP-UW-Z]{2}))/i
      URL_REGEX = /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/i

      class << self
        def parse(practices_data)
          split_into_lines(practices_data).map do |practice_line|
            identify_parts(practice_line)
          end
        end

        def split_into_lines(practices_data)
          practices_data && practices_data.split(RECORD_SEPARATOR) || []
        end

        def identify_parts(practice_line)
          parts = split_into_parts(practice_line)
          parts = parts.map { |part| sanitise(part) }
          build_practice_hash(parts)
        end

        def build_practice_hash(parts)

          parts.inject({}) do |result, part|
            result[:email] = part if part.match(EMAIL_REGEX)
            result[:address] = part if part.match(POSTCODE_REGEX)
            result[:tel] = part if part.match(TEL_REGEX)
            result[:url] = part if part.match(URL_REGEX)
            result
          end
        end

        def split_into_parts(practice_line)
          practice_line.split(PART_SEPARATOR)
        end

        def sanitise(string)
          string.strip.squeeze(' ')
        end
      end
    end
  end
end
