module Admin
  module Parsers

    describe PracticeLine do
      context 'URL matcher' do
        %w{ http://foo.com https://foo.com foo.com http://www.bar.co.uk foo.com/a/path/ http://foo.com/a/path/}.each do |url|
          it "matches URL of the form: #{url}" do
            expect(url).to match(PracticeLine::MATCHERS[:url])
          end
        end

        it 'does not match an email-like string' do
          expect('andy@foo.com').to_not match(PracticeLine::MATCHERS[:url])
        end
      end

      context 'TEL matcher' do
        [ '01727 869293', '07889187381', '07974 877182', '0201 308 2097', '0300 4000 636', '123456789', '07977-789786' ].each do |tel|
          it "matches telephone number of the form: #{tel}" do
            expect(tel).to match(PracticeLine::MATCHERS[:tel])
          end
        end
      end

      context 'POSTCODE matcher' do
        [ 'BN20GB', 'SW17 8LA', 'WC1 R4HA' ].each do |postcode|
          it "matches postcode of the form: #{postcode}" do
            expect(postcode).to match(PracticeLine::MATCHERS[:address])
          end
        end
      end

      let(:address)  { '1 Null Way, Wessex, BN20GB' }
      let(:tel)      { '012345-909090' }
      let(:email)    { 'foo@bar.com' }
      let(:url)      { 'http://foo.com/bar' }
      let(:practice) { [address, tel, email, url].join(' | ') }

      let(:expected) do
        { address: address, tel: tel, email: email, url: url }
      end

      let(:result)   { subject.to_h(practice, 1) }

      shared_examples :include_if_match do |part|
        context "When #{part} is present" do
          it "Parsed should have #{part}" do
            expect(result).to include(part => expected[part])
          end
        end
      end

      shared_examples :warn_if_no_match do |part|
        context "When #{part} is unmatchable" do
          it "Parsed should have nil #{part}" do
            expect(result).to include(part => nil)
          end

          it 'Should issue a warning' do
            result
            expect(subject.warnings).to eq(["Practice 1: Could not identify: #{expected[part]}"])
          end
        end
      end

      shared_examples :not_warn_if_blank do |part|
        context "When #{part} is blank" do
          it "Parsed should have nil #{part}" do
            expect(result).to include(part => nil)
          end

          it 'Should not issue a warning' do
            result
            expect(subject.warnings).to eq([])
          end
        end
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

      it_should_behave_like :not_warn_if_blank, :address do
        let(:address) { '' }
      end

      it_should_behave_like :not_warn_if_blank, :tel do
        let(:tel) { '' }
      end

      it_should_behave_like :not_warn_if_blank, :email do
        let(:email) { '' }
      end

      it_should_behave_like :not_warn_if_blank, :url do
        let(:url) { '' }
      end

      context 'when parts are in different order' do
        let(:practice) { [tel, url, address, email].join(' | ') }

        it_should_behave_like :include_if_match, :address
        it_should_behave_like :include_if_match, :tel
        it_should_behave_like :include_if_match, :email
        it_should_behave_like :include_if_match, :url
      end

      context 'When parts have whitespace' do
        shared_examples :removes_white_space do |part|
          context "When #{part} has extra whitespace" do
            it "Should remove the extra whitespace" do
              expect(result[part]).to eq(expected)
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

      context 'Missing parts' do
        let(:practice) { [address, email].join(' | ') }

        it 'Still has keys but with nil values' do
          expect(result).to include(tel: nil)
          expect(result).to include(url: nil)
        end

        it 'Raises no warnings' do
          expect(subject.warnings.size).to eq(0)
        end
      end

    end

  end
end
