require_relative 'mediator'

module Admin
  module Validators

    class MediatorValidations

      attr_reader :validations

      def initialize(mediators)
        @validations = mediators.map do |mediator|
          result = Mediator.new(mediator).validate
          result
        end
      end

      def valid?
        validations.all? {|result| result.success? }
      end

      def error_messages
        error_messages = []
        validations.each_with_index do |result, index|
          unless result.messages.empty?
            error_messages << {
                messages: result.messages,
                row_number: index + 1
            }
          end
        end
        error_messages
      end

    end
  end
end