module Admin
  module Parsers

    describe MediatorsParserCollection do
      context 'when empty array' do
        it 'returns empty array' do
          expect(MediatorsParserCollection.parse([])).to eq([])
        end
      end

      context 'when not array of hashes' do
        it 'should raise ArgumentError' do
          expect { MediatorsParserCollection.parse([1]) }.to raise_error(ArgumentError)
        end
      end

      context 'when array of hashes' do
        it 'should not raise ArgumentError' do
          mediator_hash = create(:mediator_hash)
          expect(MediatorParser).to receive(:new).with(mediator_hash)
          MediatorsParserCollection.parse([mediator_hash])
        end
      end

    end

    describe MediatorParser do
      context 'when data does not contain practice data' do
        it 'should return the same hash' do
          mediator_hash = create(:mediator_hash)
          parsed_mediator = MediatorParser.new(mediator_hash).parse
          expect(parsed_mediator).to eq(mediator_hash)
        end
      end

      context 'when data contains practice data' do
        it 'should contain parsed practice hash' do
          mediator_hash = create(:mediator_hash, :include_unparsed_practice)
          parsed_mediator = MediatorParser.new(mediator_hash).parse
          expected = mediator_hash.merge(practices: [{
                                                         address: '1 Null Way, Wessex CM2 9AF',
                                                         email: 'foo@bar.com',
                                                         tel: '01245 605040',
                                                         url: 'http://www.foobar.com/baz/'
                                                     }])
          expect(parsed_mediator).to eq(expected)
        end
      end
    end
  end
end