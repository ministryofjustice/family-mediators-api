module Admin
  module Parsers
    class MediatorsCollection
      def initialize(hashes)
        @hashes = hashes
        raise(ArgumentError, ':must be list of hashes') unless valid?(hashes)
      end

      def valid?(_hashes)
        @hashes.all?{ |hash| hash.is_a? Hash }
      end

      def parsed_data
        parsed_data = @hashes.map do |hash|
          hash[:practices] = Practice.parse(hash[:practices]) if hash[:practices]
          hash
        end
        parsed_data
      end
    end
  end
end
