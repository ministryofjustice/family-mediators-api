module Admin
  module Processing
    describe PracticeParser do
      let(:practice) { '1 Null Way, Wessex CM2 9AF: 01245 605040 :foo@bar.com:http://www.foobar.com/baz/:'}
      let(:address_only_practice) { '1 Null Way, Wessex CM2 9AF' }
      let(:multiple_practices) do
        "#{practice}
         #{practice}
         #{practice}
         #{practice}"
      end
      let(:practice_with_undesirable_spaces) do
        '  1 Null Way, Wessex        CM2 9AF: 01245   605040 :  foo@bar.com  : http://www.foobar.com/baz/  '
      end
      let(:reordered_practice_parts) { '01245 605040:http://www.foobar.com/baz/:1 Null Way, Wessex CM2 9AF:foo@bar.com:'}

      describe('#parse') do

        context 'practice with address, tel, email and url parts' do
          subject { PracticeParser.parse(practice).first }

          it { should include('address' => '1 Null Way, Wessex CM2 9AF')}
          it { should include('tel' => '01245 605040')}
          it { should include('email' => 'foo@bar.com')}
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
          let(:practice_without_trailing_colon) { '1 Null Way, Wessex CM2 9AF: 01245 605040 :foo@bar.com:http://www.foobar.com/baz/'}

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

        context 'identifies URLS' do
          it 'should identify URLs with/without paths'
        end
      end
    end
  end
end
