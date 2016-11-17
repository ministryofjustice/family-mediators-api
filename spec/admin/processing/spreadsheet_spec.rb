module Admin
  module Processing
    describe Spreadsheet do

      let(:workbook) do
        headings = ['First Name', 'Last Name']
        data = [ %w{ John Smith }, %w{ Donna Jones } ]
        Support::Factories::Spreadsheet.build(headings, data)
      end

      let(:expected_data) do
        [
          {'first_name' => 'John', 'last_name' => 'Smith'},
          {'first_name' => 'Donna', 'last_name' => 'Jones'}
        ]
      end

      before do
        allow(API::Models::Mediator).to receive(:create)
      end

      subject do
        Admin::Processing::Spreadsheet.new(workbook)
      end

      context '#extract_data' do
        it 'Transforms data' do
          expect(subject.send(:to_array)).to eq(expected_data)
        end
      end

      it 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).at_least(:once)
        subject.save expected_data
      end

      context 'empty workbook' do
        let(:workbook) do
          headings = []
          data = []
          Support::Factories::Spreadsheet.build(headings, data)
        end

        context '#extract_data' do
          it 'Transforms data' do
            expect(subject.send(:to_array)).to eq([])
          end
        end

      end
    end
  end
end
