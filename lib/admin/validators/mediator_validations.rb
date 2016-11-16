require_relative 'mediator_validator'
require_relative 'validation_error_message'

module Admin
  module Validators

    class MediatorValidations

      attr_reader :validations

      def initialize(mediators)
        @validations = mediators.map do |mediator|
          result = MediatorValidator.new(mediator).validate
          result
        end
        @duplicate_registration_nos = duplicate_registration_nos(mediators)
      end

      def duplicate_registration_nos mediators
        registration_numbers = mediators.map do |mediator|
          mediator['registration_no']
        end
        duplicates = registration_numbers.select{|registration_number| registration_numbers.count(registration_number) > 1 }
        duplicates.uniq
      end

      def valid?
        validations.all? {|result| result.success? } && @duplicate_registration_nos.length == 0
      end

      def collection_errors
        collection_errors = []
        if @duplicate_registration_nos.length > 0
          collection_errors << {
            'Duplicate registration numbers': @duplicate_registration_nos
          }
        end
        collection_errors
      end

      def item_errors
        error_messages = []
        validations.each_with_index do |result, index|
          result_messages = result.messages
          unless result_messages.empty?
            error_messages << ValidationErrorMessage.new(index + 2, result_messages)
          end
        end
        error_messages
      end

    end
  end
end