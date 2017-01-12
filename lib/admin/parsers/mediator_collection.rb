module Admin
  module Parsers
    class MediatorsCollection
      def initialize(hashes)
        @hashes = hashes
        raise(ArgumentError, ':must be list of hashes') unless valid?(hashes)
      end

      def valid?(_hashes)
        @hashes.all? { |hash| hash.is_a? Hash }
      end

      def expand_practices
        parser = Practice.new
        warnings = []

        expanded = @hashes.map.each_with_index do |hash, index|
          hash[:practices] = parser.parse(hash[:practices]) if hash.key?(:practices)
          warnings += parser.warnings.map do |warning|
            "Record #{index+1}: #{warning}"
          end

          hash
        end

        [ expanded, warnings ]
      end
    end
  end
end
