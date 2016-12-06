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
            expect(url =~ Practice::URL_REGEX).to_not be_nil
          end

          it 'does not match an email-like string' do
            expect('andy@foo.com' =~ Practice::URL_REGEX).to be_nil
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
          let(:unparsed_practice) { create(:unparsed_practice, :tel, :email, :url)}
          let(:parsed_practice) { create(:parsed_practice, :tel, :email, :url) }
          it { should include(address: parsed_practice[:address])}
          it { should include(tel: parsed_practice[:tel])}
          it { should include(email: parsed_practice[:email])}
          it { should include(url: parsed_practice[:url])}
        end

      end


      # describe('#parse') do
      #
      #   context 'URL recognition' do
      #     it 'Does not match an email' do
      #       expect('andy@foo.com' =~ Practice::URL_REGEX).to be_nil
      #     end
      #
      #     %w{ http://foo.com https://foo.com foo.com http://www.bar.co.uk foo.com/a/path/ http://foo.com/a/path/}.each do |url|
      #       it "Matches URL of the form: #{url}" do
      #         expect(url =~ Practice::URL_REGEX).to_not be_nil
      #       end
      #     end
      #   end
      #
      #   context 'Tel. number recognition' do
      #     [ '07974 877182', '0201 308 2097', '0300 4000 636', '123456789', '07977-789786' ].each do |tel|
      #       it "Matches tel. number of the form: #{tel}" do
      #         expect(tel =~ Practice::TEL_REGEX).to_not be_nil
      #       end
      #     end
      #   end
      #
      #   context 'practice with address, tel, email and url parts' do
      #     subject { Practice.parse(practice).first }
      #
      #     it { should include(:address => '1 Null Way, Wessex CM2 9AF')}
      #     it { should include(:tel => '01245 605040')}
      #     it { should include(:email => 'foo@bar.com')}
      #     it { should include(:url => 'http://www.foobar.com/baz/')}
      #   end
      #
      #   context 'practice with address only' do
      #     subject { Practice.parse(address_only_practice).first }
      #
      #     it { should include(:address => '1 Null Way, Wessex CM2 9AF')}
      #     it { should include(:tel => nil)}
      #     it { should include(:email => nil)}
      #   end
      #
      #   context 'multiple practices' do
      #     subject { Practice.parse(multiple_practices) }
      #
      #     it 'returns an array of parsed practice hashes' do
      #       expect(subject.size).to eq(4)
      #     end
      #   end
      #
      #   context 'trims and compresses multiple spaces to one space for all fields' do
      #     subject { Practice.parse(practice_with_undesirable_spaces).first }
      #
      #     it { should include(:address => '1 Null Way, Wessex CM2 9AF')}
      #     it { should include(:tel => '01245 605040')}
      #     it { should include(:email => 'foo@bar.com')}
      #   end
      #
      #   context 'missing trailing colons' do
      #     let(:practice_without_trailing_colon) { '1 Null Way, Wessex CM2 9AF| 01245 605040 |foo@bar.com|http://www.foobar.com/baz/'}
      #
      #     subject { Practice.parse(practice_without_trailing_colon).first }
      #
      #     it 'should parse' do
      #       expect(subject.size).to eq(4)
      #     end
      #
      #   end
      #
      #   context 'handles practice parts in any order' do
      #     subject { Practice.parse(reordered_practice_parts).first }
      #
      #     it { should include(:address => '1 Null Way, Wessex CM2 9AF')}
      #     it { should include(:tel => '01245 605040')}
      #     it { should include(:email => 'foo@bar.com')}
      #   end
      # end
    end
  end
end
