module Admin
  module Validators
    class ValidationResult
      attr_reader :messages

      def initialize
        @messages = []
      end

      def add(message)
        @messages << message
      end

      def success?
        @messages.count == 0
      end
    end

    class ReferentialValidator
      def initialize(data)
        @data = data
        @validation_result = ValidationResult.new
      end

      def validate
        supervisor_presence
        duplicate_urns
        @validation_result
      end

      def duplicate_urns
        duplicates = urns.select { |registration_number| urns.count(registration_number) > 1 }
        result = duplicates.uniq
        if result.length > 0
          @validation_result.add(ErrorMessage.new(heading: "Duplicate URN", values: result))
        end
      end

      def supervisor_presence
        result = ppc_urns.reject { |urn| urn.blank? } - urns
        if result.any?
          humanised_result = result.map { |val| val.blank? ? "blank" : val }
          @validation_result.add(ErrorMessage.new(heading: "PPC URN not recognised", values: humanised_result))
        end
      end

      def ppc_urns
        @ppc_urns ||= @data.map { |mediator| mediator[:ppc_urn] }
      end

      def urns
        @urns ||= @data.map { |mediator| mediator[:urn] }
      end
    end
  end
end
