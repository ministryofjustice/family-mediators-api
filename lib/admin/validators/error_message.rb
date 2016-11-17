module Admin
  module Validators
    class ErrorMessage

      attr_reader :heading, :values

      def initialize(heading:, values:)
        @heading= heading
        @values = values
      end

    end
  end
end