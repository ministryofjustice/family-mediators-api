module Admin
  module Parsers
    describe MediatorsCollection do
      context 'when empty array' do
        it 'returns empty array' do
          expect(MediatorsCollection.new([]).parsed_data).to eq([])
        end
      end

      context 'when not array of hashes' do
        it 'should raise ArgumentError' do
          expect { MediatorsCollection.new([1]) }.to raise_error(ArgumentError)
        end
      end

      context 'when data does not contain practice data' do
        it 'should return the same hash' do
          mediator_hash = create(:mediator_hash)
          parsed_mediator = MediatorsCollection.new([mediator_hash]).parsed_data
          expect(parsed_mediator).to eq([mediator_hash])
        end
      end

      context 'when data contains practice data' do
        it 'should contain parsed practice hash' do
          mediator_hash = create(:mediator_hash, :include_unparsed_practice)
          parsed_mediator = MediatorsCollection.new([mediator_hash]).parsed_data
          expected = mediator_hash.merge(practices: [{
                                                         address: ['15 Smith Street, London WC1R 4RL'],
                                                         email: 'valid@email.com',
                                                         tel: '01245 605040',
                                                         url: 'http://www.foobar.com/baz/'
                                                     }])
          expect(parsed_mediator).to eq([expected])
        end
      end
    end
  end
end