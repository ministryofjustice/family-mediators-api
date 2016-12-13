require_relative 'practice_validator'

module Admin
  module Validators
    class MediatorValidator
      include Hanami::Validations

      predicate :date_string?, message: 'must be dd/mm/yyyy' do |current|
        begin
          no_of_parts = current.split('/').length
          Date.strptime(current, '%d/%m/%Y') if no_of_parts == 3
          Date.strptime(current, '%m/%Y') if no_of_parts == 2
          Date.strptime(current, '%Y') if no_of_parts == 1
          true
        rescue ArgumentError
          false
        end
      end

      validations do
        configure do
          def self.messages
            super.merge(
                en: {
                    errors: {
                        tel: 'Must be valid UK phone number',
                        url: 'Must be valid URL',
                        address: 'Must have a single valid address',
                        email: 'Must be valid email address'
                    }
                }
            )
          end
        end
        required(:urn)                 { filled? & format?(/^\d{4}[TAP]$/) }
        required(:ppc_urn)             { filled? & format?(/^(\d{4}[TAP]|not known)$/) }
        required(:first_name)          { filled? & str? }
        required(:last_name)           { filled? & str? }
        required(:title)               { filled? & str? }
        required(:dcc)                 { included_in?(%w(Yes No)) }
        required(:legal_aid_qualified) { included_in?(%w(Yes No)) }
        required(:legal_aid_franchise) { included_in?(%w(Yes No)) }
        required(:fmca_date)           { filled? & (included_in?(['unknown', 'working towards']) | date_string?) }
        optional(:practices)           { array? { each { schema PracticeValidator } } }
      end
    end
  end
end