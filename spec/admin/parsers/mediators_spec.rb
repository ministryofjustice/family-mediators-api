module Admin
  module Parsers
    describe Mediators do

      let(:mediators) do
        [
          { "name" => "Bob", "md_practices" => "0 Nil Way BN2 0GB|01233-909090" },
          { "name" => "Mary" }
        ]
      end

      let(:expected) do
        [
          { "name" => "Bob", "md_practices" => [
              {
                "address" => "0 Nil Way BN2 0GB",
                "tel" => "01233-909090",
                "email" => nil,
                "url" => nil
              }
            ]
          },
          { "name" => "Mary" }
        ]
      end

      context '#parse' do
        it 'Parses practices' do
          expect(subject.parse(mediators)).to eq expected
        end
      end

    end
  end
end
