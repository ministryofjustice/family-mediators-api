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
        @lookups = {
          registration_nos: get_registration_numbers(mediators)
        }
      end

      def validate
        @mediators.each_with_index do |_mediator, index|
          VALIDATIONS.each do |field, rules|
            check_rules(field.to_s, index, rules)
          end
        end

        errors.empty?
      end

      def valid?
        erros.empty?
      end

      private

      def check_rules(field, index, rules)
        return unless @mediators[index].has_key?(field)
        rules.each { |args| break unless send(*args, index, field) }
      end

      # Return false to stop further rules being checked
      def must_be_populated(level, message, index, field)
        if @mediators[index][field].nil? || @mediators[index][field].gsub(/\W/, '').size == 0
          error(index+1, field, level, message)
          return false
        end
        true
      end

      def must_match(regex, level, message, index, field)
        unless @mediators[index][field] =~ regex
          error(index+1, field, level, message)
        end
        true
      end

      def must_occur_once_within(lookup_name, level, message, index, field)
        count = @lookups[lookup_name].select { |e| e == @mediators[index][field] }.size
        unless count == 1
          error(index+1, field, level, message)
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