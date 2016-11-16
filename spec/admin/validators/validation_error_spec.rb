module Admin
  module Validators
    describe ValidationError do

      let(:message) do
        {
            'field_name': 'field value'
        }
      end

      subject(:validation_error) { Admin::Validators::ValidationError.new(1, message)}

      it 'has row number that is 1-based' do
        expect(validation_error.row_number).to eq(1)
      end

      it 'has error messages' do
        expect(validation_error.message).to eq(message)
      end

    end
  end
end
