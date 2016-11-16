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

        it 'is required' do
          valid_input.delete('registration_no')
          result = MediatorValidator.new(valid_input).validate
          expect(result.success?).to eq(false)
        end

        it 'matches pattern ####T' do
          data   = valid_input.merge('registration_no' => '1234T')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'matches pattern ####A' do
          data   = valid_input.merge('registration_no' => '3456A')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'matches pattern ####P' do
          data   = valid_input.merge('registration_no' => '6789P')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'does not match pattern #####P' do
          data   = valid_input.merge('registration_no' => '16789P')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      describe 'md offers dcc' do
        %w{Y N}.each do |val|
          it "is valid when '#{val}'" do
            data   = valid_input.merge('md_offers_dcc' => val)
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        it "is invalid when 'a'" do
          data   = valid_input.merge('md_offers_dcc' => 'a')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_offers_dcc' => '')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it "is invalid when it is 'YN'" do
          data   = valid_input.merge('md_offers_dcc' => 'YN')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

      end

      describe 'first name' do

        it 'valid when it is a non-blank string' do
          data   = valid_input.merge('md_first_name' => 'John')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_first_name' => '')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is a number' do
          data   = valid_input.merge('md_first_name' => 123)
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      describe 'last name' do

        it ' is valid when it is a non-blank string' do
          data   = valid_input.merge('md_last_name' => 'John')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_last_name' => '')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is a number' do
          data   = valid_input.merge('md_last_name' => 123)
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      describe 'MD_Mediation_Legal_Aid' do

        %w{Y N}.each do |val|
          it "is valid when '#{val}'" do
            data   = valid_input.merge('md_mediation_legal_aid' => val)
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        it "is invalid when not 'Y' or 'N'" do
          data   = valid_input.merge('md_mediation_legal_aid' => 'a')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_mediation_legal_aid' => '')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it "is invalid when it is 'YN'" do
          data   = valid_input.merge('md_mediation_legal_aid' => 'YN')
          result = MediatorValidator.new(data).validate
          expect(result.success?).to eq(false)
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