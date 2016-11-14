module Admin
  module Validators
    class ValidationError

      attr_reader :row_number, :message

      def initialize(row_number, message)
        @row_number = row_number
        @message = message
      end

    end
  end
end