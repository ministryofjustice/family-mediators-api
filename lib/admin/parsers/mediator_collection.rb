module Admin
  module Parsers
    class MediatorsCollection
      attr_reader :mediators, :warnings

      def initialize(hashes)
        @hashes = hashes
        raise(ArgumentError, ':must be list of hashes') unless valid?(hashes)
        expand_practices
      end

      def valid?(_hashes)
        @hashes.all? { |hash| hash.is_a? Hash }
      end

      private

      def expand_practices
        parser = Practice.new
        @warnings = []

        @mediators = @hashes.map.each_with_index do |hash, index|
          hash[:practices] = parser.parse(hash[:practices]) if hash.key?(:practices)
          @warnings += prefix_warnings(parser.warnings, index+1)
          hash
        end
      end

      def prefix_warnings(warnings, record_num)
        warnings.map { |warning| "Record #{record_num}: #{warning}" }
      end

    end
  end
end
