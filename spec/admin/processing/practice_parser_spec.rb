module Admin
  module Processing
    describe PracticeParser do
      let(:practice) { '1 Null Way, Wessex CM2 9AF| 01245 605040 |foo@bar.com|http://www.foobar.com/baz/|'}
      let(:address_only_practice) { '1 Null Way, Wessex CM2 9AF' }
      let(:multiple_practices) do
        "#{practice}
         #{practice}
         #{practice}
         #{practice}"
      end
      let(:practice_with_undesirable_spaces) do
        '  1 Null Way, Wessex        CM2 9AF| 01245   605040 |  foo@bar.com  | http://www.foobar.com/baz/  '
      end
      let(:reordered_practice_parts) { '01245 605040|http://www.foobar.com/baz/|1 Null Way, Wessex CM2 9AF|foo@bar.com|'}

      describe('#parse') do

        context "URL recognition" do
          it "Does not match an email" do
            expect('andy@foo.com' =~ PracticeParser::URL_REGEX).to be_nil
          end

          %w{ http://foo.com https://foo.com foo.com http://www.bar.co.uk foo.com/a/path/ http://foo.com/a/path/}.each do |url|
            it "Matches URL of the form: #{url}" do
              expect(url =~ PracticeParser::URL_REGEX).to_not be_nil
            end
          end
        end

        context "Tel. number recognition" do
          [ '07974 877182', '0201 308 2097', '0300 4000 636', '123456789', '07977-789786' ].each do |tel|
            it "Matches tel. number of the form: #{tel}" do
              expect(tel =~ PracticeParser::TEL_REGEX).to_not be_nil
            end
          end
        end

        context 'practice with address, tel, email and url parts' do
          subject { PracticeParser.parse(practice).first }

          it { should include('address' => '1 Null Way, Wessex CM2 9AF')}
          it { should include('tel' => '01245 605040')}
          it { should include('email' => 'foo@bar.com')}
          it { should include('url' => 'http://www.foobar.com/baz/')}
        end

        context 'practice with address only' do
          subject { PracticeParser.parse(address_only_practice).first }

          it { should include('address' => '1 Null Way, Wessex CM2 9AF')}
          it { should include('tel' => nil)}
          it { should include('email' => nil)}
        end

        context 'multiple practices' do
          subject { PracticeParser.parse(multiple_practices) }

          it 'returns an array of parsed practice hashes' do
            expect(subject.size).to eq(4)
          end
        end

        context 'trims and compresses multiple spaces to one space for all fields' do
          subject { PracticeParser.parse(practice_with_undesirable_spaces).first }

          it { should include('address' => '1 Null Way, Wessex CM2 9AF')}
          it { should include('tel' => '01245 605040')}
          it { should include('email' => 'foo@bar.com')}
        end

        context 'missing trailing colons' do
          let(:practice_without_trailing_colon) { '1 Null Way, Wessex CM2 9AF| 01245 605040 |foo@bar.com|http://www.foobar.com/baz/'}

          subject { PracticeParser.parse(practice_without_trailing_colon).first }

          it 'should parse' do
            expect(subject.size).to eq(4)
          end

        end

        context 'handles practice parts in any order' do
          subject { PracticeParser.parse(reordered_practice_parts).first }

          it { should include('address' => '1 Null Way, Wessex CM2 9AF')}
          it { should include('tel' => '01245 605040')}
          it { should include('email' => 'foo@bar.com')}
        end
      end
    end
  end
end
