module Admin
  module Parsers
    class MediatorsCollection
      def initialize(hashes)
        @hashes = hashes
        raise(ArgumentError, ':must be list of hashes') unless valid?(hashes)
      end

      def valid?(_hashes)
        @hashes.all?{ |x| x.is_a? Hash }
      end

      def parsed_data
        parsed_data = @hashes.map do |hash|
          if hash[:practices]
            hash[:practices] = Practice.parse(hash[:practices])
          end
          hash
        end
        parsed_data
      end
    end
  end
end
