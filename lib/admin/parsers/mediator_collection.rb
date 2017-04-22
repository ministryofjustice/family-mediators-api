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

        @mediators = @hashes.map.each_with_index do |mediator, index|
          expand_practice(mediator, parser, index+1)
        end
      end

      def expand_practice(mediator, parser, record_num)
        mediator[:practices] = parser.parse(mediator[:practices]) if mediator.key?(:practices)
        @warnings += prefix_warnings(parser.warnings, record_num)
        mediator
      end

      def prefix_warnings(warnings, record_num)
        warnings.map { |warning| "Record #{record_num}: #{warning}" }
      end

    end
  end
end
