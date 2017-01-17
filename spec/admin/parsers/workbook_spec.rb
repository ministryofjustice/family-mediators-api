module Admin
  module Parsers
    describe Workbook do

      subject { Workbook.new(rubyxl_workbook) }

      let(:headings) { ['First Name', 'Last Name'] }

      let(:rubyxl_workbook) do
        Support::Factories::Spreadsheet.build(headings, data, blacklist)
      end

      context 'normal data' do
        let(:data) { [%w{ John Smith }, %w{ Donna Jones }] }
        let(:blacklist) { [ 'Bish bosh', 'bash' ] }

        let(:expected_data) do
          [
            { first_name: 'John', last_name: 'Smith' },
            { first_name: 'Donna', last_name: 'Jones' }
          ]
        end

        let(:expected_blacklist) { [ :bish_bosh, :bash ] }

        it 'Parses mediators' do
          expect(subject.mediators).to eq(expected_data)
        end

        it 'Parses blacklist' do
          expect(subject.blacklist).to eq(expected_blacklist)
        end
      end

      context 'with null values for blank cells' do
        let(:data) { [%w{ John Smith }, [nil, 'Baker'], %w{ Donna Jones }] }
        let(:blacklist) { [] }

        let(:expected_data) do
          [
            {:first_name => 'John', :last_name => 'Smith'},
            {:first_name => nil, :last_name => 'Baker'},
            {:first_name => 'Donna', :last_name => 'Jones'}
          ]
        end

        it 'Transforms data' do
          expect(subject.mediators).to eq(expected_data)
        end
      end

      context 'empty rows' do
        let(:data) { [ %w{ Bob Bobbins }, [ nil, '' ] ] }
        let(:blacklist) { [] }

        let(:expected_data) do
          [ {:first_name => 'Bob', :last_name => 'Bobbins'} ]
        end

        it 'Ignores empty rows' do
          expect(subject.mediators).to eq(expected_data)
        end
      end

      context 'empty workbook' do
        let(:headings) { [] }
        let(:data) { [] }
        let(:blacklist) { [] }

        it 'Returns empty data array' do
          expect(subject.mediators).to eq([])
        end

        it 'Returns empty blacklist array' do
          expect(subject.blacklist).to eq([])
        end
      end

    end
  end
end
