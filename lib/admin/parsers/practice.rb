module Admin
  module Parsers
    class Practice
      RECORD_SEPARATOR = "\n"
      PART_SEPARATOR = '|'
      EMAIL_REGEX = /([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i
      TEL_REGEX = /[\d\s-]{5,12}/
      POSTCODE_REGEX = /((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))/i
      URL_REGEX = /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/i

      def self.parse(data)
        return if data.nil?
        data.split(RECORD_SEPARATOR).map { |practice| parse_address(practice) }
      end

      # private

      def self.parse_address(practice)
        parts = practice.split(PART_SEPARATOR).map { |part| sanitise(part) }

        {
          "address" => find(parts, POSTCODE_REGEX),
          "tel" => find(parts, TEL_REGEX),
          "email" => find(parts, EMAIL_REGEX),
          "url" => find(parts, URL_REGEX)
        }
      end

      def self.sanitise(string)
        string.nil? ? nil : string.strip.squeeze(' ')
      end

      def self.find(parts, regex)
        parts.each { |part| return parts.delete(part) if part =~ regex }
        nil
      end
    end
  end
end
