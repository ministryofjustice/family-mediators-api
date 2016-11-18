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
        duplicate_registration_nos
        @validation_result
      end

      def duplicate_registration_nos
        duplicates = registration_nos.select { |registration_number| registration_nos.count(registration_number) > 1 }
        result = duplicates.uniq
        if result.length > 0
          @validation_result.add(ErrorMessage.new(heading: 'Duplicate registration numbers', values: result))
        end
      end

      def supervisor_presence
        result = ppc_ids - registration_nos - ['not known']
        if result.length > 0
          @validation_result.add(ErrorMessage.new(heading: 'MD_PPC_ID not recognised', values: result))
        end
      end

      def ppc_ids
        @ppc_ids ||= @data.map{ |mediator| mediator['md_ppc_id'] }
      end

      def registration_nos
        @registration_nos ||= @data.map{ |mediator| mediator['registration_no'] }
      end

    end
  end
end