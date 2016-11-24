module Admin
  module Validators
    class FileValidator
      attr_reader :errors

      def initialize(data)
        @data = data
        @errors = []
      end

      def valid?
        if @data.empty?
          @errors = ['The file contains no data']
          return false
        end
        true
      end
    end
  end
end