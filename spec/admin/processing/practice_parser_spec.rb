module Admin
  module Processing
    describe PracticeParser do
      let(:data) do
        '1 Null Way, Wessex        CM2 9AF: 01245 605040 :foo@bar.com:http://www.foobar.com/baz/
  Bish Road, Boshtown  NN17 1TY: 01536 276727:bish@bosh.co.uk:
  -2 Bonkers Blvd, Freaksville  SW19 5EG:2089445290:bonkers@geesh.co.uk
  949 Bloopers Blvd, Normalville  TS1 2RQ'
      end

      let(:alternatively_ordered_data) do
        '01273 678345 : boosh@beesh.com : 77 Waddle Way, Bongtown, Wessex WE45 4TY
  http://www.cribbins.com : 0 Beelk Ave, Oooofville, Oooofshire O99 0PP : 09876 564432 : me@ooof.com
  09876-567773'
      end

      let(:result) { PracticeParser.parse(data) }
      let(:alternatively_ordered_result) { PracticeParser.parse(alternatively_ordered_data) }

      it 'Return 6 elements' do
        expect(result.size).to eq data.split("\n").size
      end

      it 'Each element is a hash with 4 keys' do
        expect(result.first.keys).to eq %w{ address tel email url }
      end

      it 'Trims leading and trailing whitespace' do
        expect(result.first["tel"]).to eq '01245 605040'
      end

      it 'Compresses multiple spaces to one space' do
        expect(result.first["address"]).to eq '1 Null Way, Wessex CM2 9AF'
      end

      it 'Handles missing tokens' do
        expect(result[1]["url"]).to be_nil
      end

      it "Handles absent trailing semicolons" do
        expect(result[2]["address"]).to_not be_nil
        expect(result[2]["tel"]).to_not be_nil
        expect(result[2]["url"]).to be_nil

        expect(result[3]["address"]).to_not be_nil
        expect(result[3]["tel"]).to be_nil
        expect(result[3]["url"]).to be_nil
      end

      %w{ foo@bar.com bish.bosh@bash.co.uk foo99@bish88.org.uk }.each do |email|
        it "Can exclusively identify the email: #{email}" do
          expect(email =~ PracticeParser::EMAIL_REGEX).to eq 0
          expect(email =~ PracticeParser::URL_REGEX).to eq nil
          expect(email =~ PracticeParser::POSTCODE_REGEX).to eq nil
          expect(email =~ PracticeParser::TEL_REGEX).to eq nil
        end
      end

      %w{ www.bar.com https://bash.co.uk http://fbish88.org.uk }.each do |url|
        it "Can exclusively identify the URL: #{url}" do
          expect(url =~ PracticeParser::EMAIL_REGEX).to eq nil
          expect(url =~ PracticeParser::URL_REGEX).to eq 0
          expect(url =~ PracticeParser::POSTCODE_REGEX).to eq nil
          expect(url =~ PracticeParser::TEL_REGEX).to eq nil
        end
      end

      it 'Handles elements in any order' do
        result = alternatively_ordered_result.first
        expect(result["address"]).to eq "77 Waddle Way, Bongtown, Wessex WE45 4TY"
        expect(result["tel"]).to eq "01273 678345"
        expect(result["email"]).to eq "boosh@beesh.com"
        expect(result["url"]).to be_nil
      end
    end
  end
end
