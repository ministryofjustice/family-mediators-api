module Admin
  module Validators
    class MediatorValidator
      include Hanami::Validations::Form

      validations do
        required('registration_no').filled(:str?, format?: /^\d{4}[TAP]$/)
        required('md_offers_dcc') { included_in?(%w(Y N)) }
        required('md_first_name').filled(:str?)
        required('md_last_name').filled(:str?)
        required('md_mediation_legal_aid') { included_in?(%w(Y N)) }
        required('md_ppc_id').filled(:str?, format?: /^(\d{4}[TAP]|not known)$/)

      end
    end
  end
end