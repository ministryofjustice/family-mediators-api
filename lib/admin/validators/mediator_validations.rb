require_relative "mediator_validator"
require_relative "error_message"
require_relative "referential_validator"

module Admin
  module Validators
    class MediatorValidations
      attr_reader :validations

      def initialize(mediators)
        @validations = mediators.map do |mediator|
          MediatorValidator.new.call(mediator)
        end
        @referential_validations = ReferentialValidator.new(mediators).validate
      end

      def valid?
        validations.all?(&:success?) && @referential_validations.success?
      end

      def collection_errors
        @referential_validations.messages
      end

      def item_errors
        error_messages = []

        validations.each_with_index do |result, index|
          result_messages = result.errors.to_h
          unless result_messages.empty?
            error_messages << ErrorMessage.new(heading: index, values: result_messages)
          end
        end
        error_messages
      end
    end
  end
end
