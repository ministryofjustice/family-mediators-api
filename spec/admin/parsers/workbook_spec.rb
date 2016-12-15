module Admin
  module Parsers
    describe Workbook do

      subject do
        Workbook.new(rubyxl_workbook)
      end

      context '#transform_worksheet' do

        let(:rubyxl_workbook) do
          headings = ['First Name', 'Last Name']
          data = [%w{ John Smith }, %w{ Donna Jones }]
          Support::Factories::Spreadsheet.build(headings, data)
        end

        let(:expected_data) do
          [
              {:first_name => 'John', :last_name => 'Smith'},
              {:first_name => 'Donna', :last_name => 'Jones'}
          ]
        end

        it 'Transforms data' do
          expect(subject.send(:transform_worksheet)).to eq(expected_data)
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
            expect(subject.send(:transform_worksheet)).to eq(expected_data)
          end
        end

      end

      context 'empty workbook' do
        let(:rubyxl_workbook) do
          headings = []
          data = []
          Support::Factories::Spreadsheet.build(headings, data)
        end

        context '#extract_data' do
          it 'Transforms data' do
            expect(subject.send(:transform_worksheet)).to eq([])
          end
        end
      end



    end
  end
end