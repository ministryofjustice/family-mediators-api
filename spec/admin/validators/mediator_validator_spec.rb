module Admin
  module Validators
    describe MediatorValidator do

      let(:valid_input) do
        {
          'registration_no' => '1234A',
          'md_offers_dcc' => 'Y',
          'md_first_name' => 'John',
          'md_last_name' => 'Smith',
          'md_mediation_legal_aid' => 'Y',
          'md_ppc_id' => '8297A'
        }
      end

      describe 'registration no' do

        context 'when blank' do
          it 'is invalid' do
            valid_input.delete('registration_no')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('registration_no')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        %w{8297T 3592A 9371P}.each do |val|
          context "when matches pattern #{val}" do
            it 'is valid' do
              data = valid_input.merge('registration_no' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(true)
            end
          end
        end

        context 'when does not match registration format' do
          it 'is invalid' do
            data   = valid_input.merge('registration_no' => '16789P')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end

      describe 'md offers dcc' do

        context 'when blank' do
          it 'is invalid' do
            data   = valid_input.merge('md_offers_dcc' => '')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('md_offers_dcc')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        %w{Y N}.each do |val|
          context "when is '#{val}'" do
            it 'is valid' do
              data   = valid_input.merge('md_offers_dcc' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(true)
            end
          end
        end

        context 'when is not Y or N' do
          it 'is invalid' do
            data   = valid_input.merge('md_offers_dcc' => 'a')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when is not YN' do
          it 'is invalid' do
            data   = valid_input.merge('md_offers_dcc' => 'YN')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end

      describe 'first name' do

        context 'when blank' do
          it 'is invalid' do
            data   = valid_input.merge('md_first_name' => '')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('md_first_name')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when is non-blank string' do
          it 'is valid' do
            data   = valid_input.merge('md_first_name' => 'John')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        context 'when is number' do
          it 'is invalid' do
            data   = valid_input.merge('md_first_name' => 123)
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end

      describe 'last name' do

        context 'when blank' do
          it 'is invalid' do
            data   = valid_input.merge('md_last_name' => '')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('md_last_name')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when is non-blank string' do
          it 'is valid' do
            data   = valid_input.merge('md_last_name' => 'John')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        context 'when is number' do
          it 'is invalid' do
            data   = valid_input.merge('md_last_name' => 123)
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end

      describe 'MD_Mediation_Legal_Aid' do

        context 'when blank' do
          it 'is invalid' do
            data   = valid_input.merge('md_mediation_legal_aid' => '')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('md_mediation_legal_aid')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        %w{Y N}.each do |val|
          context "when is '#{val}'" do
            it 'is valid' do
              data   = valid_input.merge('md_mediation_legal_aid' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(true)
            end
          end
        end

        context 'when is not Y or N' do
          it 'is invalid' do
            data   = valid_input.merge('md_mediation_legal_aid' => 'a')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when is not YN' do
          it 'is invalid' do
            data   = valid_input.merge('md_mediation_legal_aid' => 'YN')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end

      describe 'MD_PPC_ID' do

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('md_ppc_id')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when blank' do
          it 'is invalid' do
            data = valid_input.merge('md_ppc_id' => '')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        %w{8297T 3592A 9371P}.each do |val|
          context "when matches pattern #{val}" do
            it 'is valid' do
              data = valid_input.merge('md_ppc_id' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(true)
            end
          end
        end

        context 'when "not known"' do
          it 'is valid' do
            data = valid_input.merge('md_ppc_id' => 'not known')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

      end
    end
  end
end