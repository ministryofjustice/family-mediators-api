module Admin
  module Validators
    class Mediator
      include Hanami::Validations

      validations do
        required('registration_no').filled(:str?, format?: /^\d{4}[TAP]$/)
        required('md_offers_dcc') { included_in?(%w(Y N)) }
        required('md_first_name').filled(:str?)
        required('md_last_name').filled(:str?)
      end
    end
  end
end