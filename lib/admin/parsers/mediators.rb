module Admin
  module Parsers
    class Mediators
      PRACTICES_HEADING = 'md_practices'

      def parse data
        data.map do |mediator|
          mediator[PRACTICES_HEADING] = Practice.parse(mediator[PRACTICES_HEADING])
          { 'data' => mediator }
        end
      end
    end
  end
end
