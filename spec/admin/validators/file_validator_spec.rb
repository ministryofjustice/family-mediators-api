module Admin
  module Validators
    describe FileValidator do
      context "when empty file invalidated" do
        subject { described_class.new([], []) }

        it "Deems invalid" do
          expect(subject.valid?).to eq(false)
        end

        it "Error message" do
          subject.valid?
          expect(subject.errors).to eq(["The file contains no mediator data"])
        end
      end

      context "when file has blacklist entry" do
        let(:mediators) { [{ foo: 42, bar: 43 }] }

        context "and found in data" do
          subject { described_class.new(mediators, %w[foo]) }

          it "if deemed valid" do
            expect(subject.valid?).to eq(true)
          end
        end

        context "and not found in data" do
          subject { described_class.new(mediators, %w[bobbins]) }

          it "Deems invalid" do
            expect(subject.valid?).to eq(false)
          end

          it "Error message" do
            subject.valid?
            expect(subject.errors).to eq(["Blacklisted column not found in mediator data: bobbins"])
          end
        end
      end
    end
  end
end
