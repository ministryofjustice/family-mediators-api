module Admin
  module Parsers
    describe Workbook do

      subject do
        Workbook.new(rubyxl_workbook)
      end

      let(:rubyxl_workbook) do
        headings = ['First Name', 'Last Name']
        data = [%w{ John Smith }, %w{ Donna Jones }]
        Support::Factories::Spreadsheet.build(headings, data, blacklist)
      end

      let(:expected_data) do
        [
          {:first_name => 'John', :last_name => 'Smith'},
          {:first_name => 'Donna', :last_name => 'Jones'}
        ]
      end

      let(:blacklist) { %w{ bish bosh bash } }

      context '#transform_mediators' do

        it 'Transforms data' do
          expect(subject.send(:transform_mediators)).to eq(expected_data)
        end

        context 'with null values for blank cells' do
          let(:rubyxl_workbook) do
            headings = ['First Name', 'Last Name']
            data = [%w{ John Smith }, [nil, 'Baker'], %w{ Donna Jones }]
            Support::Factories::Spreadsheet.build(headings, data)
          end
          let(:expected_data) do
            [
                {:first_name => 'John', :last_name => 'Smith'},
                {:first_name => nil, :last_name => 'Baker'},
                {:first_name => 'Donna', :last_name => 'Jones'}
            ]
          end

          it 'Transforms data' do
            expect(subject.send(:transform_mediators)).to eq(expected_data)
          end
        end

      end

      it 'Returns 2 arrays' do
        expect(subject.call.size).to eq(2)
        expect(subject.call.first).to be_an(Array)
        expect(subject.call.last).to be_an(Array)
      end

      it 'First array is data' do
        expect(subject.call.first).to eq(expected_data)
      end

      it 'Second array is array of blacklisted cols' do
        expect(subject.call.last).to eq(blacklist)
      end

      context 'Empty workbook' do
        let(:rubyxl_workbook) do
          Support::Factories::Spreadsheet.build([], [])
        end

        it 'Returns empty data array' do
          expect(subject.call.first).to eq([])
        end

        it 'Returns empty blacklist array' do
          expect(subject.call.last).to eq([])
        end
      end

    end
  end
end
