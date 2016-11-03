module Admin
  module Processing
    describe Spreadsheet do

      let(:filepath) do
        File.expand_path('../../../support/fixtures/spreadsheet.xlsx', __FILE__)
      end

      let(:expected_data) do
        [
          {"month_number"=>"1.0", "month_name"=>"January"},
          {"month_number"=>"2.0", "month_name"=>"February"},
          {"month_number"=>"3.0", "month_name"=>"March"}
        ]
      end

      before do
        # allow(RubyXL::Parser).to receive(:parse).and_return([workbook])
        allow(API::Models::Mediator).to receive(:create)
      end

      subject do
        Admin::Processing::Spreadsheet.new(filepath)
      end

      context '#extract_data' do
        it 'Transforms data' do
          expect(subject.send(:extract_data)).to eq(expected_data)
        end
      end

      it 'should process headings' do
        subject.process
      end

      it 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).at_least(:once)
        subject.process
      end
    end
  end
end
