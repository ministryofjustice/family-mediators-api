module Admin
  module Services
    describe ProcessFile do
      subject { described_class.new("/fake/file/path") }

      before do
        allow(RubyXL::Parser).to receive(:parse).and_return(nil)
        allow(Parsers::Workbook).to receive(:new).and_return(workbook_parser)
        allow(Validators::FileValidator).to receive(:new).and_return(file_validator)
        allow(Processing::ConfidentialFieldRemover).to receive(:call).and_return(mediator_data)
      end

      let(:blacklist) { %i[bish bosh bash] }
      let(:public_fields) { %i[foo bar baz] }

      let(:mediator_data) do
        [{ foo: "ding", bar: "dong", baz: "dang" }]
      end

      let(:workbook_parser) { instance_double("WorkbookParser", call: [mediator_data, blacklist]) }
      let(:file_validator)  { instance_double("FileValidator", valid?: true, errors: []) }

      context "when there is no file given" do
        subject { described_class.new(nil) }

        it "Raises an error" do
          expect { subject.call }.to raise_error("No file specified")
        end
      end

      context "when a valid file is given" do
        it "Returns true" do
          expect(subject.call).to eq(true)
        end

        it "Has no errors" do
          subject.call
          expect(subject.errors.size).to eq(0)
        end

        it "Derives mediator count" do
          subject.call
          expect(subject.mediators_count).to eq(1)
        end

        it "Derives a dump of mediators" do
          subject.call
          expect(subject.dump).to eq("eJyLrlZKy89XslJKycxLV9JRSkosAnHyoZwqECcRyKmNBQAU7wzp\n")
        end

        it "Derives list of confidential fields" do
          subject.call
          expect(subject.confidential_fields).to eq(blacklist)
        end

        it "Derives list of public fields" do
          subject.call
          expect(subject.public_fields).to eq(public_fields)
        end
      end

      context "when an invalid file is given" do
        let(:file_validator) { instance_double("FileValidator", valid?: false, errors: %w[foo bar]) }

        it "Returns false" do
          expect(subject.call).to eq(false)
        end

        it "Has errors" do
          subject.call
          expect(subject.errors.size).not_to eq(0)
        end
      end
    end
  end
end
