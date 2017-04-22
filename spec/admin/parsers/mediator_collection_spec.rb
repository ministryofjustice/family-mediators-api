module Admin
  module Parsers

    describe MediatorsCollection do
      subject { MediatorsCollection.new(mediator_hashes) }

      context 'when empty array' do
        let(:mediator_hashes) { [] }

        it 'returns empty array' do
          expect(subject.mediators).to eq([])
          expect(subject.warnings).to eq([])
        end
      end

      context 'when not array of hashes' do
        let(:mediator_hashes) { [:not_a_hash] }

        it 'should raise ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when data does not contain practice data' do
        let(:mediator_hashes) { [create(:mediator_hash)] }

        it 'should return the same hash' do
          expect(subject.mediators).to eq(mediator_hashes)
        end
      end

      context 'when practice value data is null' do
        let(:mediator_hashes) { [create(:mediator_hash, practices: nil)] }

        it 'should return empty same hash with no practice key' do
          expect(subject.mediators.first).to eq(mediator_hashes.first.except!(:practices))
        end
      end

      context 'when data contains practice data' do
        let(:mediator_hashes) do
          [create(:mediator_hash, :include_unparsed_practice)]
        end

        let(:practices) do
          [{
            address: '15 Smith Street, London WC1R 4RL',
            email: 'valid@email.com',
            tel: '01245 605040',
            url: 'http://www.foobar.com/baz/'
          }]
        end

        it 'should contain parsed practice hash' do
          expect(subject.mediators.first[:practices]).to eq(practices)
        end
      end
    end

  end
end
