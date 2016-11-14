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
        if @duplicate_registration_nos.length > 0
          msg = {
              'registration_no': ["Duplicate registration_no: #{@duplicate_registration_nos}"]
          }
          error_messages << {
              messages: msg,
              row_number: 'n/a'
          }
        end
        error_messages
      end

    end
  end
end