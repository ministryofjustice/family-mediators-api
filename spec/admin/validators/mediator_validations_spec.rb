module Admin
  module Validators
    describe MediatorValidations do

      let(:valid_input_1) do
        {
            'registration_no' => '1234A',
            'md_offers_dcc' => 'Y',
            'md_first_name' => 'John',
            'md_last_name' => 'Smith',
            'md_mediation_legal_aid' => 'Y'
        }
      end

      let(:valid_input_2) do
        {
            'registration_no' => '1456T',
            'md_offers_dcc' => 'Y',
            'md_first_name' => 'Jane',
            'md_last_name' => 'Doe',
            'md_mediation_legal_aid' => 'Y'
        }
      end

      describe '#valid?' do
        context 'when all mediators are valid' do
          it 'returns true' do
            data = [valid_input_1, valid_input_2]
            validations = MediatorValidations.new(data)
            expect(validations.valid?).to eq(true)
          end
        end

        context 'when one mediator is invalid' do
          it 'returns false' do
            data = [valid_input_1, valid_input_2.merge('registration_no' => 'invalid_reg_no')]
            validations = MediatorValidations.new(data)
            expect(validations.valid?).to eq(false)
          end
        end
      end

      describe '#error_messages' do

        context 'when all mediators are valid' do
          it 'returns an empty array' do
            data = [valid_input_1, valid_input_2]
            validations = MediatorValidations.new(data)
            expect(validations.item_errors).to eq([])
          end
        end

        context 'when one mediator is invalid' do
          let(:item_errors) do
            data = [valid_input_1, valid_input_2.merge('registration_no' => 'invalid_reg_no')]
            MediatorValidations.new(data).item_errors
          end

          it 'returns 1 message' do
            expect(item_errors.count).to eq(1)
          end

          it 'has row number that is 1-based' do
            expect(item_errors[0][:row_number]).to eq(3)
          end

          it 'has error messages' do
            expect(item_errors[0]).to include(:messages)
          end
        end

      end

      describe '#unique' do
        let(:validations) do
          data = [valid_input_1, valid_input_2]
          data[1] = data[1].merge('registration_no' => data[0]['registration_no'])
          MediatorValidations.new(data)
        end

        it 'returns 1 message' do
          expect(validations.item_errors.count).to eq(1)
        end
      end

    end
  end
end