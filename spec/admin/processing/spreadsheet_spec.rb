module Admin
  module Processing
    describe Spreadsheet do

      let(:workbook) do
        workbook = RubyXL::Workbook.new
        worksheet = workbook[0]
        worksheet.add_cell(0,0, 'First Name')
        worksheet.add_cell(0,1, 'Last Name')
        worksheet.add_cell(1,0, 'John')
        worksheet.add_cell(1,1, 'Smith')
        worksheet.add_cell(2,0, 'Donna')
        worksheet.add_cell(2,1, 'Jones')
        workbook
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
          expect(subject.send(:to_hash)).to eq(expected_data)
        end
      end

      it 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).at_least(:once)
        subject.process
      end
    end
  end
end
