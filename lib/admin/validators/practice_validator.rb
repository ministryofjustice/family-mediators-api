module Admin
  module Validators
    class PracticeValidator
      include Hanami::Validations

      UK_PHONE_FORMAT = /^(?:(?:\(?(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?(?:\(?0\)?[\s-]?)?)|(?:\(?0))(?:(?:\d{5}\)?[\s-]?\d{4,5})|(?:\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3}))|(?:\d{3}\)?[\s-]?\d{3}[\s-]?\d{3,4})|(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}))(?:[\s-]?(?:x|ext\.?|\#)\d{3,4})?$/
      HTTP_FORMAT = URI.regexp(%w(http https))
      EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP

      predicate(:telephone_number?) do |current|
        current.match(UK_PHONE_FORMAT)
      end

      predicate(:url?, message: 'must be URL') do |current|
        current.match(HTTP_FORMAT)
      end

      predicate(:email?, message: 'must be email address') do |current|
        current.match(EMAIL_FORMAT)
      end

      validations do
        optional(:address) { str? }
        optional(:tel) { telephone_number? }
        optional(:url) { url? }
        optional(:email) { email? }
      end
    end
  end
end
