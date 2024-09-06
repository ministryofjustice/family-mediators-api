module Admin
  module Services
    describe ProcessFile do
      subject(:valid_file) { described_class.new("/fake/file/path") }

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

      let(:workbook_parser) { instance_double(Parsers::Workbook, call: [mediator_data, blacklist]) }
      let(:file_validator)  { instance_double(Validators::FileValidator, valid?: true, errors: []) }

      context "when no file is given" do
        subject(:no_file) { described_class.new(nil) }

        it "Raises an error" do
          expect { no_file.call }.to raise_error("No file specified")
        end
      end

      context "when a valid file is given" do
        it "Returns true" do
          expect(valid_file.call).to be(true)
        end

        it "Has no errors" do
          valid_file.call
          expect(valid_file.errors.size).to eq(0)
        end

        it "Derives mediator count" do
          valid_file.call
          expect(valid_file.mediators_count).to eq(1)
        end

        it "Derives a dump of mediators" do
          valid_file.call
          expect(valid_file.dump).to eq("eJyLrlZKy89XslJKycxLV9JRSkosAnHyoZwqECcRyKmNBQAU7wzp\n")
        end

        it "Derives list of confidential fields" do
          valid_file.call
          expect(valid_file.confidential_fields).to eq(blacklist)
        end

        it "Derives list of public fields" do
          valid_file.call
          expect(valid_file.public_fields).to eq(public_fields)
        end
      end

      context "when an invalid file is given" do
        let(:file_validator) { instance_double(Validators::FileValidator, valid?: false, errors: %w[foo bar]) }

        it "Returns false" do
          expect(valid_file.call).to be(false)
        end

        it "Has errors" do
          valid_file.call
          expect(valid_file.errors.size).not_to eq(0)
        end
      end
    end
  end
end
