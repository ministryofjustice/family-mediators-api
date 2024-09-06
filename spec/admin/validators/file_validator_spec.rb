module Admin
  module Validators
    describe FileValidator do
      context "when empty file invalidated" do
        subject(:empty_file) { described_class.new([], []) }

        it "Deems invalid" do
          expect(empty_file.valid?).to be(false)
        end

        it "Error message" do
          empty_file.valid?
          expect(empty_file.errors).to eq(["The file contains no mediator data"])
        end
      end

      context "when file has blacklist entry" do
        let(:mediators) { [{ foo: 42, bar: 43 }] }

        context "and found in data" do
          subject(:bad_entry_file) { described_class.new(mediators, %w[foo]) }

          it "if deemed valid" do
            expect(bad_entry_file.valid?).to be(true)
          end
        end

        context "and not found in data" do
          subject(:clean_file) { described_class.new(mediators, %w[bobbins]) }

          it "Deems invalid" do
            expect(clean_file.valid?).to be(false)
          end

          it "Error message" do
            clean_file.valid?
            expect(clean_file.errors).to eq(["Blacklisted column not found in mediator data: bobbins"])
          end
        end
      end
    end
  end
end
