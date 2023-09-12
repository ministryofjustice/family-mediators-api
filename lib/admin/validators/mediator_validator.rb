require_relative "practice_validator"

module Admin
  module Validators
    class MediatorValidator < Dry::Validation::Contract
      URN_FORMAT = /^\d{4}[TAP]$/
      YES_NO_VALUES = %w[Yes No].freeze

      schema do
        required(:urn).filled(:string) { format?(URN_FORMAT) }
        optional(:ppc_urn) { empty? | format?(URN_FORMAT) }
        required(:first_name).filled(:string)
        required(:last_name).filled(:string)
        required(:title).filled(:string)
        required(:dcc).value(:string) { included_in?(YES_NO_VALUES) }
        required(:legal_aid_qualified).value(:string) { included_in?(YES_NO_VALUES) }
        required(:legal_aid_franchise).value(:string) { included_in?(YES_NO_VALUES) }
        optional(:practices).maybe(:array)
        optional(:fmca_date)
        optional(:training_date)
      end

      register_macro(:date_string) do
        if value.present?
          begin
            no_of_parts = value.split("/").length
            Date.strptime(value, "%d/%m/%Y") if no_of_parts == 3
            Date.strptime(value, "%m/%Y") if no_of_parts == 2
            Date.strptime(value, "%Y") if no_of_parts == 1
          rescue ArgumentError
            key.failure("must be dd/mm/yyyy")
          end
        end
      end

      rule(:practices).each do
        PracticeValidator.new.call(value).errors.each do |error|
          key.failure(error.text)
        end
      end

      rule(:fmca_date).validate(:date_string)
      rule(:training_date).validate(:date_string)

      rule(:training_date) do
        if !values[:fmca_date].present? && !value.present?
          key.failure("FMCA Date or Training Date must be present")
        end
      end
    end
  end
end
