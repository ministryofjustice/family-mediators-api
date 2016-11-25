module Admin
  module Validators
    class PracticeValidator
      include Hanami::Validations

      UK_PHONE_FORMAT = /^(?:(?:\(?(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?(?:\(?0\)?[\s-]?)?)|(?:\(?0))(?:(?:\d{5}\)?[\s-]?\d{4,5})|(?:\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3}))|(?:\d{3}\)?[\s-]?\d{3}[\s-]?\d{3,4})|(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}))(?:[\s-]?(?:x|ext\.?|\#)\d{3,4})?$/

      predicate(:telephone_number?, message: 'BLAHDHD') do |current|
        current.nil? || current.match(UK_PHONE_FORMAT)
      end

      validations do
        required(:tel) { telephone_number? }
      end
    end


  end
end