module Admin
  module Parsers

    class MediatorParser
      def initialize(hash)
        @hash = hash
      end

      def parse
        parse_practice if @hash[:practices]
        @hash
      end

      def parse_practice
        @hash[:practices] = Practice.parse(@hash[:practices])
      end
    end

    class MediatorsParserCollection

      class << self
        def parse(hashes)
          raise(ArgumentError, ':must be list of hashes') unless valid?(hashes)
          parsed_hashes = hashes.map do |item|
            mediator_parser = MediatorParser.new(item)
            mediator_parser.parse
          end
          parsed_hashes
        end

        def valid?(hashes)
          hashes.all?{ |x| x.is_a? Hash }
        end
      end
    end

  end
end
