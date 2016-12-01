module Admin
  module Parsers
    describe MediatorPractices do

      let(:mediators) do
        [
          {:md_practices => '0 Nil Way BN2 0GB|01233-909090'}
        ]
      end

      let(:expected) do
        [
          { :md_practices => [
              {
                  :address => '0 Nil Way BN2 0GB',
                  :tel => '01233-909090',
                  :email => nil,
                  :url => nil
              }
            ]
          }
        ]
      end

      describe '#parse' do

        context 'when no mediators' do

        end

        context 'when empty practice string' do

        end

        it 'Parses practices' do
          expect(MediatorPractices.parse(mediators)).to eq expected
        end
      end

      # describe '#parse_practices' do
      #
      #   let(:mediators) do
      #     [{:name => 'Bob', :md_practices => '' }]
      #   end
      #
      #   let(:expected) do
      #
      #   end
      #
      #   context 'when empty string' do
      #     expect(MediatorPractices.parse(mediators)).to eq()
      #   end
      # end

    end
  end
end
