module Admin
  module Processing
    describe DataStore do

      # let(:workbook) do
      #   headings = ['First Name', 'Last Name']
      #   data = [%w{ John Smith }, %w{ Donna Jones }]
      #   Support::Factories::Spreadsheet.build(headings, data)
      # end
      #
      let(:data) do
        [
          {'first_name' => 'John', 'last_name' => 'Smith'},
          {'first_name' => 'Donna', 'last_name' => 'Jones'}
        ]
      end
      #
      # let(:fake_xl_parser) do
      #   double("FakeXLParser", parse: workbook)
      # end

      before do
        allow(API::Models::Mediator).to receive(:create)
      end

      # subject do
      #   Admin::Processing::Spreadsheet.new(
      #     xl_parser: fake_xl_parser,
      #     data_parser: nil
      #   )
      # end

      # context '#transform_worksheet' do
      #   xit 'Transforms data' do
      #     expect(subject.send(:transform_worksheet)).to eq(expected_data)
      #   end
      # end

      it 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).once
        DataStore.save(data)
      end

      # context 'empty workbook' do
      #   let(:workbook) do
      #     headings = []
      #     data = []
      #     Support::Factories::Spreadsheet.build(headings, data)
      #   end
      #
      #   context '#extract_data' do
      #     xit 'Transforms data' do
      #       expect(subject.send(:transform_worksheet)).to eq([])
      #     end
      #   end
      # end

    end
  end
end
