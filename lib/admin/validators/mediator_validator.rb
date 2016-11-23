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

      predicate :practice?, message: 'must contain practice data' do |current|
        PracticeValidator.new(current).validate.success?
      end

      validations do
        required('registration_no').filled(:str?, format?: /^\d{4}[TAP]$/)
        required('md_offers_dcc') { included_in?(%w(Y N)) }
        required('md_first_name').filled(:str?)
        required('md_last_name').filled(:str?)
        required('md_mediation_legal_aid') { included_in?(%w(Y N)) }
        required('md_ppc_id').filled(:str?, format?: /^(\d{4}[TAP]|not known)$/)
        required('fmca_cert') { filled? & (included_in?(['unknown','working towards']) | date_string?) }
        # required('md_practices') { array? { each { practice? } } }
      end
    end
  end
end