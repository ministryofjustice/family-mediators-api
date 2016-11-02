module Admin
  module Processing
    describe Spreadsheet do

      let(:filepath) do
        File.expand_path('../../../support/fixtures/spreadsheet.xlsx', __FILE__)
      end

      class FakeCell
        attr_reader :value

        def initialize(val)
          @value = val
        end
      end

      class FakeRow
        def initialize(vals)
          @vals = vals
        end

        def cells
          [
            FakeCell.new(@vals[0]),
            FakeCell.new(@vals[1]),
            FakeCell.new(@vals[2])
          ]
        end
      end

      let(:workbook) do
        [
          FakeRow.new(['name', 'age', 'gender']),
          FakeRow.new(['Bob', 56, 'male'])
        ]
      end

      let(:expected_data) do
        [
          {
            'name' => 'Bob',
            'age' => '56',
            'gender' => 'male'
          }
        ]
      end

      before do
        allow(RubyXL::Parser).to receive(:parse).and_return([workbook])
        allow(API::Models::Mediator).to receive(:create)
      end

      subject do
        Admin::Processing::Spreadsheet.new(filepath)
      end

      context '#extract_data' do
        it 'Transforms data' do
          subject.send :extract_data
          expect(subject.data).to eq(expected_data)
        end
      end

      it 'should process headings' do
        #expect(Admin::Processing::Headings).to receive(:process)
        subject.process
      end

      it 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).at_least(:once)
        subject.process
      end
    end
  end
end
