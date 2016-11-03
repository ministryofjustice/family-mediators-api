module Admin
  module Parsers
    class Mediators
      PRACTICES_HEADING = 'md_practices'

      def parse(mediators)
        mediators.map do |mediator|
          parse_practices(mediator)
          mediator
        end
      end

      private

      def parse_practices(data)
        if data[PRACTICES_HEADING]
          data[PRACTICES_HEADING] = Practice.parse(data[PRACTICES_HEADING])
        end
      end
    end
  end
end
