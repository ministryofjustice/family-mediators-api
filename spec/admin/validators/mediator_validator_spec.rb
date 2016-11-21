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
          'md_ppc_id' => '8297A',
          'fmca_cert' => '21/11/2016'
        }
      end

      describe 'registration_no' do

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

      describe 'md_offers_dcc' do

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

      describe 'md_first_name' do

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

      describe 'md_last_name' do

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

      describe 'md_mediation_legal_aid' do

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

      describe 'md_ppc_id' do

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

      describe 'fmca_cert' do

        context 'when missing' do
          it 'is invalid' do
            valid_input.delete('fmca_cert')
            result = MediatorValidator.new(valid_input).validate
            expect(result.success?).to eq(false)
          end
        end

        context 'when blank' do
          it 'is invalid' do
            data = valid_input.merge('fmca_cert' => '')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

        ['unknown','working towards'].each do |val|
          context "when '#{val}'" do
            it 'is valid' do
              data = valid_input.merge('fmca_cert' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(true)
            end
          end
        end

        ['2016', '05/2016', '24/07/2016'].each do |val|
          context "when '#{val}'" do
            it 'is valid' do
              data = valid_input.merge('fmca_cert' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(true)
            end
          end
        end

        ['13/2016','32/04/2016'].each do |val|
          context "when '#{val}'" do
            it 'is invalid' do
              data = valid_input.merge('fmca_cert' => val)
              result = MediatorValidator.new(data).validate
              expect(result.success?).to eq(false)
            end
          end
        end

        context "when 'blah'" do
          it 'is invalid' do
            data = valid_input.merge('fmca_cert' => 'blah')
            result = MediatorValidator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end
    end
  end
end