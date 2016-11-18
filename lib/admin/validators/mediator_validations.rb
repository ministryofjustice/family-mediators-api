require_relative 'mediator_validator'
require_relative 'error_message'
require_relative 'referential_validator'

module Admin
  module Validators

    class MediatorValidations

      attr_reader :validations

      def initialize(mediators)
        @validations = mediators.map do |mediator|
          MediatorValidator.new(mediator).validate
        end
        @referential_validations = ReferentialValidator.new(mediators).validate
      end

      def valid?
        validations.all? {|result| result.success? } && @referential_validations.messages.count == 0
      end

      def collection_errors
        @referential_validations.messages
      end

      def item_errors
        error_messages = []
        validations.each_with_index do |result, index|
          result_messages = result.messages
          unless result_messages.empty?
            error_messages << ErrorMessage.new(heading: index, values: result_messages)
          end
        end
        error_messages
      end

    end
  end
end