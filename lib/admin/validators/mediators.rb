module Admin
  module Validators
    class Mediators
      attr_reader :errors

      YN_REGEX = /^[YN]$/i
      VALIDATIONS = {
          registration_no: [
              [:must_be_populated, :fatal, 'is required'],
              [:must_match, /^\d{4}[TAP]$/, :fatal, 'must be of the format nnnnT, nnnnA, or nnnnP'],
              [:must_occur_once_within, :registration_nos, :fatal, 'is not unique']
          ],
          md_offers_dcc: [
              [:must_be_populated, :fatal, 'is required'],
              [:must_match, YN_REGEX, :fatal, 'must be Y or N']
          ]
      }

      def initialize(mediators)
        @errors = []
        @mediators = mediators
        @indexes = {}
        @indexes[:registration_nos] = get_registration_numbers(mediators)
      end

      def validate
        @mediators.each_with_index do |mediator, index|
          VALIDATIONS.each do |field, rules|
            check_rules(field.to_s, mediator, index + 1, rules)
          end
        end

        errors.empty?
      end

      private

      def check_rules(field, mediator, row_no, rules)
        return unless mediator.has_key?(field)

        rules.each do |args|
          return unless send *args, row_no, field, mediator
        end
      end

      # Return false to stop further rules being checked
      def must_be_populated(level, message, row_no, field, mediator)
        if mediator[field].nil? || mediator[field].gsub(/\W/, '').size == 0
          error(row_no, field, level, message)
          return false
        end
        true
      end

      def must_match(regex, level, message, row_no, field, mediator)
        unless mediator[field] =~ regex
          error(row_no, field, level, message)
        end
        true
      end

      def must_occur_once_within(index_name, level, message, row_no, field, mediator)
        count = @indexes[index_name].select { |e| e == mediator[field] }.size
        unless count == 1
          error(row_no, field, level, message)
          return false
        end
        true
      end

      def error(row_no, field, level, message)
        @errors << {
            row_no: row_no,
            field: field.to_sym,
            level: level,
            message: message
        }
      end

      def get_registration_numbers(mediators)
        mediators.map { |mediator| mediator['registration_no'] }
      end
    end
  end
end