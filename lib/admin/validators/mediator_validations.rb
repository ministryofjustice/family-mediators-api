require_relative 'mediator'
require_relative 'validation_error'

module Admin
  module Validators

    class MediatorValidations

      attr_reader :validations

      def initialize(mediators)
        @validations = mediators.map do |mediator|
          result = Mediator.new(mediator).validate
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
        validations.all? {|result| result.success? }
      end

      def collection_errors
        collection_errors = []
        if @duplicate_registration_nos.length > 0
          msg = {
              'registration_no': ["Duplicate registration_no: #{@duplicate_registration_nos}"]
          }
          collection_errors << {
            messages: msg,
            row_number: 'n/a'
          }
        end
        collection_errors
      end

      def item_errors
        error_messages = []
        validations.each_with_index do |result, index|
          unless result.messages.empty?
            error_messages << ValidationError.new(index + 2, result.messages)
          end
        end
        error_messages
      end

    end
  end
end