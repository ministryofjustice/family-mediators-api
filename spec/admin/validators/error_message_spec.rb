module Admin
  module Validators
    describe ErrorMessage do
      let(:message) do
        { 'field_name': "field value" }
      end

      subject(:validation_error) { Admin::Validators::ErrorMessage.new(heading: "heading", values: message) }

      it "has heading" do
        expect(validation_error.heading).to eq("heading")
      end

      it "has vales" do
        expect(validation_error.values).to eq(message)
      end
    end
  end
end
