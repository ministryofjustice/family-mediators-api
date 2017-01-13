module Admin
  module Parsers
    describe Practice do
      context 'URL matcher' do
        %w{ http://foo.com https://foo.com foo.com http://www.bar.co.uk foo.com/a/path/ http://foo.com/a/path/}.each do |url|
          it "matches URL of the form: #{url}" do
            expect(url).to match(Practice::MATCHERS[:url])
          end
        end

        it 'does not match an email-like string' do
          expect('andy@foo.com').to_not match(Practice::MATCHERS[:url])
        end
      end

      context 'TEL matcher' do
        [ '07974877182', '0201 3082097', '0300 4000636', '123456789', '07977 789786' ].each do |tel|
          it "matches telephone number of the form: #{tel}" do
            expect(tel).to match(Practice::MATCHERS[:tel])
          end
        end
      end

      context 'POSTCODE matcher' do
        [ 'BN20GB', 'SW17 8LA', 'WC1 R4HA' ].each do |postcode|
          it "matches postcode of the form: #{postcode}" do
            expect(postcode).to match(Practice::MATCHERS[:address])
          end
        end
      end

      context 'null practice data' do
        it 'should return empty array' do
          expect(subject.parse(nil)).to eq([])
        end
      end

      let(:address)  { '1 Null Way, Wessex, BN20GB' }
      let(:tel)      { '012345-909090' }
      let(:email)    { 'foo@bar.com' }
      let(:url)      { 'http://foo.com/bar' }
      let(:practice) { [address, tel, email, url].join(' | ') }

      let(:result)   { subject.parse(unparsed) }

      context 'Single unparsed practice' do
        shared_examples :include_if_match do |part|
          context "When #{part} is present" do
            it "Parsed should have #{part}" do
              expect(result.first).to include(part => parsed[part])
            end
          end
        end

        shared_examples :warn_if_no_match do |part|
          context "When #{part} is unmatchable" do
            it "Parsed should have nil #{part}" do
              expect(result.first).to include(part => nil)
            end

            it 'Should issue a warning' do
              result
              expect(subject.warnings).to eq(["Practice 1: Could not identify: #{parsed[part]}"])
            end
          end
        end

        let(:unparsed) { practice }

        let(:parsed) do
          { address: address, tel: tel, email: email, url: url }
        end

        it_should_behave_like :include_if_match, :address
        it_should_behave_like :include_if_match, :tel
        it_should_behave_like :include_if_match, :email
        it_should_behave_like :include_if_match, :url

        it_should_behave_like :warn_if_no_match, :address do
          let(:address) { '0 Goofyland Ave, Booshire' }
        end

        it_should_behave_like :warn_if_no_match, :tel do
          let(:tel) { '0-90x68-bananas' }
        end

        it_should_behave_like :warn_if_no_match, :email do
          let(:email) { 'ned(at)flip.flap' }
        end

        it_should_behave_like :warn_if_no_match, :url do
          let(:url) { 'httpx://boing.net' }
        end

        context 'when parts are in different order' do
          let(:unparsed) { [tel, url, address, email].join(' | ') }

          it_should_behave_like :include_if_match, :address
          it_should_behave_like :include_if_match, :tel
          it_should_behave_like :include_if_match, :email
          it_should_behave_like :include_if_match, :url
        end

        context 'When parts have whitespace' do
          shared_examples :removes_white_space do |part|
            context "When #{part} has extra whitespace" do
              it "Should remove the extra whitespace" do
                expect(result.first[part]).to eq(expected)
              end
            end
          end

          it_should_behave_like :removes_white_space, :address do
            let(:address)  { '1     Woosh Way,        BN20GB' }
            let(:expected) { '1 Woosh Way, BN20GB' }
          end

          it_should_behave_like :removes_white_space, :tel do
            let(:tel)      { '012345       67890' }
            let(:expected) { '012345 67890' }
          end

          it_should_behave_like :removes_white_space, :email do
            let(:email)    { '       fred@foo.com  ' }
            let(:expected) { 'fred@foo.com' }
          end

          it_should_behave_like :removes_white_space, :url do
            let(:url)      { '       http://bish.com  ' }
            let(:expected) { 'http://bish.com' }
          end
        end
      end

      context 'Missing parts' do
        let(:unparsed) { [address, email].join(' | ') }

        it 'Still has keys but with nil values' do
          expect(result.first).to include(tel: nil)
          expect(result.first).to include(url: nil)
        end

        it 'Raises no warnings' do
          expect(subject.warnings.size).to eq(0)
        end
      end

      context 'Multiple practices' do
        let(:unparsed) { [practice, practice, practice].join("\n") }

        it 'Returns an array of parsed practice hashes' do
          expect(result.size).to eq(3)
        end
      end

    end
  end
end
