module Admin
  module Validators
    describe Mediator do

      let(:valid_input) do
        {
          'registration_no' => '1234A',
          'md_offers_dcc' => 'Y',
          'md_first_name' => 'John',
          'md_last_name' => 'Smith',
          'md_mediation_legal_aid' => 'Y'
        }
      end

      describe 'registration no' do

        it 'is required' do
          result = Mediator.new({}).validate
          expect(result.success?).to eq(false)
        end

        it 'matches pattern ####T' do
          data   = valid_input.merge('registration_no' => '1234T')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'matches pattern ####A' do
          data   = valid_input.merge('registration_no' => '3456A')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'matches pattern ####P' do
          data   = valid_input.merge('registration_no' => '6789P')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'does not match pattern #####P' do
          data   = valid_input.merge('registration_no' => '16789P')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      describe 'md offers dcc' do
        %w{Y N}.each do |val|
          it "is valid when '#{val}'" do
            data   = valid_input.merge('md_offers_dcc' => val)
            result = Mediator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        it "is invalid when 'a'" do
          data   = valid_input.merge('md_offers_dcc' => 'a')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_offers_dcc' => '')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it "is invalid when it is 'YN'" do
          data   = valid_input.merge('md_offers_dcc' => 'YN')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

      end

      describe 'first name' do

        it 'valid when it is a non-blank string' do
          data   = valid_input.merge('md_first_name' => 'John')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_first_name' => '')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is a number' do
          data   = valid_input.merge('md_first_name' => 123)
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      describe 'last name' do

        it ' is valid when it is a non-blank string' do
          data   = valid_input.merge('md_last_name' => 'John')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_last_name' => '')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is a number' do
          data   = valid_input.merge('md_last_name' => 123)
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      describe 'MD_Mediation_Legal_Aid' do

        %w{Y N}.each do |val|
          it "is valid when '#{val}'" do
            data   = valid_input.merge('md_mediation_legal_aid' => val)
            result = Mediator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        it "is invalid when not 'Y' or 'N'" do
          data   = valid_input.merge('md_mediation_legal_aid' => 'a')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is missing' do
          data   = valid_input.merge('md_mediation_legal_aid' => '')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it "is invalid when it is 'YN'" do
          data   = valid_input.merge('md_mediation_legal_aid' => 'YN')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

      end

    end
  end
end