module Admin
  module Parsers
    describe Practice do
      # let(:practice) { '1 Null Way, Wessex CM2 9AF| 01245 605040 |foo@bar.com|http://www.foobar.com/baz/|'}
      # let(:address_only_practice) { '1 Null Way, Wessex CM2 9AF' }
      # let(:multiple_practices) do
      #   "#{practice}
      #    #{practice}
      #    #{practice}
      #    #{practice}"
      # end
      # let(:practice_with_undesirable_spaces) do
      #   '  1 Null Way, Wessex        CM2 9AF| 01245   605040 |  foo@bar.com  | http://www.foobar.com/baz/  '
      # end
      # let(:reordered_practice_parts) { '01245 605040|http://www.foobar.com/baz/|1 Null Way, Wessex CM2 9AF|foo@bar.com|'}

      context 'URL_REGEX' do
        %w{ http://foo.com https://foo.com foo.com http://www.bar.co.uk foo.com/a/path/ http://foo.com/a/path/}.each do |url|
          it "matches URL of the form: #{url}" do
            expect(url).to match(Practice::URL_REGEX)
          end
        end

        it 'does not match an email-like string' do
          expect('andy@foo.com').to_not match(Practice::URL_REGEX)
        end
      end

      context 'TEL_REGEX' do
        [ '07974 877182', '0201 308 2097', '0300 4000 636', '123456789', '07977-789786' ].each do |tel|
          it "matches telephone number of the form: #{tel}" do
            expect(tel).to match(Practice::TEL_REGEX)
          end
        end
      end

      context 'single unparsed practice' do
        subject { Practice.parse(unparsed_practice)[0] }

        context 'when postcode is present' do
          let(:unparsed_practice) { create(:unparsed_practice) }
          it { should include(address: create(:parsed_practice)[:address]) }
        end

        context 'when postcode is missing' do
          let(:unparsed_practice) { create(:unparsed_practice, :missing_postcode) }
          it { should include(address: nil)}
        end

        context 'when phonenumber-like string is present' do
          let(:unparsed_practice) { create(:unparsed_practice, :tel) }
          it { should include(tel: create(:parsed_practice, :tel)[:tel])}
        end

        context 'when phonenumber-like string is not present' do
          let(:unparsed_practice) { create(:unparsed_practice) }
          it { should include(tel: nil)}
        end

        context 'when email-like string is present' do
          let(:unparsed_practice) { create(:unparsed_practice, :email) }
          it { should include(email: create(:parsed_practice, :email)[:email])}
        end

        context 'when email-like string is not present' do
          let(:unparsed_practice) { create(:unparsed_practice) }
          it { should include(email: nil)}
        end

        context 'when url-like string is present' do
          let(:unparsed_practice) { create(:unparsed_practice, :url) }
          it { should include(url: create(:parsed_practice, :url)[:url])}
        end

        context 'when url-like string is not present' do
          let(:unparsed_practice) { create(:unparsed_practice) }
          it { should include(url: nil)}
        end

        context 'when all parts present' do
          let(:unparsed_practice) { create(:unparsed_practice, :all_parts)}
          let(:parsed_practice) { create(:parsed_practice, :all_parts) }
          it { should include(address: parsed_practice[:address])}
          it { should include(tel: parsed_practice[:tel])}
          it { should include(email: parsed_practice[:email])}
          it { should include(url: parsed_practice[:url])}
        end

        context 'when parts are in different order' do
          let(:unparsed_practice) { create(:shuffled_unparsed_practice, :all_parts)}
          let(:parsed_practice) { create(:parsed_practice, :all_parts) }
          it { should include(address: parsed_practice[:address])}
          it { should include(tel: parsed_practice[:tel])}
          it { should include(email: parsed_practice[:email])}
          it { should include(url: parsed_practice[:url])}
        end

        context 'when parts have whitespace' do
          let(:unparsed_practice) { create(:whitespaced_unparsed_practice, :all_parts)}
          let(:parsed_practice) { create(:parsed_practice, :all_parts) }
          it 'should remove excess whitespace for address' do
            expect(subject).to include(address: parsed_practice[:address])
          end

          it 'should remove excess whitespace for tel' do
            expect(subject).to include(tel: parsed_practice[:tel])
          end

          it 'should remove excess whitespace for email' do
            expect(subject).to include(email: parsed_practice[:email])
          end

          it 'should remove excess whitespace for url' do
            expect(subject).to include(url: parsed_practice[:url])
          end
        end


      end

      context 'multiple practices' do
        subject { Practice.parse(unparsed_practices) }
        let(:unparsed_practices) do
          "#{create(:unparsed_practice)}
          #{create(:unparsed_practice)}
          #{create(:unparsed_practice)}"
        end

        it 'returns an array of parsed practice hashes' do
          expect(subject.size).to eq(3)
        end
      end
    end
  end
end
