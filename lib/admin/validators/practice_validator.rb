module Admin
  module Validators
    class PracticeValidator < Dry::Validation::Contract

      UK_PHONE_FORMAT = /^(?:(?:\(?(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?(?:\(?0\)?[\s-]?)?)|(?:\(?0))(?:(?:\d{5}\)?[\s-]?\d{4,5})|(?:\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3}))|(?:\d{3}\)?[\s-]?\d{3,4}[\s-]?\d{3,4})|(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}))(?:[\s-]?(?:x|ext\.?|\#)\d{3,4})?$/
      HTTP_FORMAT = URI.regexp(%w(http https))
      EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP

      schema do
        optional(:address).value(:string)
        optional(:tel).value(:string)
        optional(:url).value(:string)
        optional(:email).value(:string)
      end

      rule(:tel) do
        key.failure('Must be valid UK phone number') if key? && !UK_PHONE_FORMAT.match?(value)
      end

      rule(:url) do
        key.failure('Must be valid URL') if key? && !HTTP_FORMAT.match?(value)
      end

      rule(:email) do
        key.failure('Must be valid email address') if key? && !EMAIL_FORMAT.match?(value)
      end
    end
  end
end
