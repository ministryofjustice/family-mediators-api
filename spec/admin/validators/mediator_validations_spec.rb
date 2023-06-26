module Admin
  module Validators
    describe MediatorValidations do
      describe "#valid?" do
        context "when mediators are valid" do
          it "returns true" do
            data = create(:mediator_list)
            validations = described_class.new(data)
            expect(validations.valid?).to eq(true)
          end
        end

        context "when one mediator is invalid" do
          it "returns false" do
            data = [create(:mediator_hash), create(:mediator_hash, :invalid)]
            validations = described_class.new(data)
            expect(validations.valid?).to eq(false)
          end
        end
      end

      describe "#item_errors" do
        context "when all mediators are valid" do
          it "is returns no item messages" do
            validations = described_class.new(create(:mediator_list))
            expect(validations.item_errors).to eq([])
          end
        end

        context "when one mediator is invalid" do
          let(:item_errors) do
            data = [create(:mediator_hash), create(:mediator_hash, :invalid)]
            described_class.new(data).item_errors
          end

          it "returns 1 message" do
            expect(item_errors.count).to eq(1)
          end

          it "returns ValidationErrorMessage class" do
            expect(item_errors[0]).to be_kind_of(Admin::Validators::ErrorMessage)
          end
        end
      end

      describe "#item_errors" do
        context "when all mediators are valid" do
          it "is returns no collection messages" do
            validations = described_class.new(create(:mediator_list))
            expect(validations.collection_errors).to eq([])
          end
        end
      end
    end
  end
end
