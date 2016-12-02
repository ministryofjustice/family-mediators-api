module Admin
  module Parsers
    class MediatorPractices
      PRACTICES_HEADING = :practices

      def self.parse(mediators)
        mediators.map do |mediator|
          parse_practices(mediator)
          mediator
        end
      end

      def self.parse_practices(data)
        if data[PRACTICES_HEADING]
          data[PRACTICES_HEADING] = Practice.parse(data[PRACTICES_HEADING])
        end
      end
    end
  end
end
