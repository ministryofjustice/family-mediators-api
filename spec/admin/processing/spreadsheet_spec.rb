module Admin
  module Processing
    describe Spreadsheet do

      let(:workbook) do
        headings = ['First Name', 'Last Name']
        data = [%w{ John Smith }, %w{ Donna Jones }]
        Support::Factories::Spreadsheet.build(headings, data)
      end

      let(:expected_data) do
        [
          {'first_name' => 'John', 'last_name' => 'Smith'},
          {'first_name' => 'Donna', 'last_name' => 'Jones'}
        ]
      end

      let(:fake_xl_parser) do
        double("FakeXLParser", parse: workbook)
      end

      before do
        allow(API::Models::Mediator).to receive(:create)
        subject.read('fake/path')
      end

      subject do
        Admin::Processing::Spreadsheet.new(
          xl_parser: fake_xl_parser,
          data_parser: nil
        )
      end

      context '#transform_worksheet' do
        it 'Transforms data' do
          expect(subject.send(:transform_worksheet)).to eq(expected_data)
        end
      end

      xit 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).at_least(:once)
        subject.save
      end

      context 'empty workbook' do
        let(:workbook) do
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
