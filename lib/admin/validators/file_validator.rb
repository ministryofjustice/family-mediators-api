module Admin
  module Validators
    class FileValidator
      attr_reader :errors

      def initialize(mediators, blacklist = [])
        @mediators = mediators
        @errors = []
        @blacklist = blacklist
      end

      def valid?
        check_any_data
        check_blacklist
        @errors.empty?
      end

    private

      def check_any_data
        @errors << "The file contains no mediator data" if @mediators.empty?
      end

      def check_blacklist
        @blacklist.each do |col|
          unless @mediators.first.keys.include?(col.to_sym)
            @errors << "Blacklisted column not found in mediator data: #{col}"
          end
        end
      end
    end
  end
end
