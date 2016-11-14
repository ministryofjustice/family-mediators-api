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
            expect(validations.error_messages).to eq([])
          end
        end

        context 'when one mediator is invalid' do
          let(:error_messages) do
            data = [valid_input_1, valid_input_2.merge('registration_no' => 'invalid_reg_no')]
            MediatorValidations.new(data).error_messages
          end

          it 'returns 1 message' do
            expect(error_messages.count).to eq(1)
          end

          it 'has row number that is 1-based' do
            expect(error_messages[0][:row_number]).to eq(3)
          end

          it 'has error messages' do
            expect(error_messages[0]).to include(:messages)
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
          expect(validations.error_messages.count).to eq(1)
        end
      end

    end
  end
end