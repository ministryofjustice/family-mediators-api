module Admin
  module Services
    describe ProcessFile do

      subject { ProcessFile.new('/fake/file/path') }

      before do
        allow(RubyXL::Parser).to receive(:parse).and_return(nil)
        allow(Parsers::Workbook).to receive(:new).and_return(workbook_parser)
        allow(Validators::FileValidator).to receive(:new).and_return(file_validator)
        allow(Processing::ConfidentialFieldRemover).to receive(:call).and_return({})
      end

      let(:workbook_parser) { double('WorkbookParser', call: [nil, nil]) }
      let(:file_validator)  { double('FileValidator', valid?: true, errors: []) }

      context 'No file given' do
        subject { ProcessFile.new(nil) }

        it 'Raises an error' do
          expect{subject.call}.to raise_error('No file specified')
        end
      end

      context 'Valid file given' do
        it 'Returns true' do
          expect(subject.call).to eq(true)
        end

        it 'Has no errors' do
          subject.call
          expect(subject.errors.size).to eq(0)
        end

        it 'Derives mediator count' do
          subject.call
          expect(subject.mediators_count).to eq(0)
        end

        it 'Derives a dump of mediators' do
          subject.call
          expect(subject.dump).to eq("eJyrrgUAAXUA+Q==\n")
        end
      end

      context 'Invalid file given' do
        let(:file_validator)  { double('FileValidator', valid?: false, errors: %w{ foo bar }) }

        it 'Returns false' do
          expect(subject.call).to eq(false)
        end

        it 'Has errors' do
          subject.call
          expect(subject.errors.size).not_to eq(0)
        end
      end

    end
  end
end
