module Admin
  module Processing
    class PracticeParser
      EMAIL_REGEX = /([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i
      TEL_REGEX = /\d{5,12}/
      POSTCODE_REGEX = /((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))/i
      URL_REGEX = /\A((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/i

      def self.parse(data)
        data.split("\n").map { |practice| parse_address(practice) }
      end

      # private

      def self.parse_address(practice)
        elements = practice.split(':').map { |element| sanitise(element) }

        {
          'address' => find(elements, POSTCODE_REGEX),
          'tel' => find(elements, TEL_REGEX),
          'email' => find(elements, EMAIL_REGEX),
          'url' => find(elements, URL_REGEX)
        }
      end

      def self.sanitise(string)
        string.nil? ? nil : string.strip.squeeze(' ')
      end

      def self.find(elements, regex)
        elements.each { |ele| return elements.delete(ele) if ele =~ regex }
        nil
      end
    end
  end
end
