module Admin
  module Validators
    class Mediator
      include Hanami::Validations

      attr_reader :errors

      validations do
        required('registration_no').filled(:str?, format?: /^\d{4}[TAP]$/)
      end
    end
  end
end