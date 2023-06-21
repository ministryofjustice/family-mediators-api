module Admin
  module Validators
    describe FileValidator do
      context "when an empty file is given" do
        subject(:empty_file) { described_class.new([], []) }

        it "Deems invalid" do
          expect(empty_file.valid?).to eq(false)
        end

        it "Error message" do
          empty_file.valid?
          expect(empty_file.errors).to eq(["The file contains no mediator data"])
        end
      end

      context "when there is a blacklist" do
        let(:mediators) { [{ foo: 42, bar: 43 }] }

        context "but found in data" do
          subject(:blacklist_file) { described_class.new(mediators, %w[foo]) }

          it "Deems valid" do
            expect(blacklist_file.valid?).to eq(true)
          end
        end

        context "but not found in data" do
          subject(:no_blacklist_file) { described_class.new(mediators, %w[bobbins]) }

          it "Deems invalid" do
            expect(no_blacklist_file.valid?).to eq(false)
          end

          it "Error message" do
            no_blacklist_file.valid?
            expect(no_blacklist_file.errors).to eq(["Blacklisted column not found in mediator data: bobbins"])
          end
        end
      end
    end
  end
end
