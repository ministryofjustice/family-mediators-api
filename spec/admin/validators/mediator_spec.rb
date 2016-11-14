module Admin
  module Validators
    describe Mediator do

      let(:input) do
        {
          'registration_no' => '1234A',
          'md_offers_dcc' => 'Y'
        }
      end

      describe 'registration no' do

        it 'is required' do
          result = Mediator.new({}).validate
          expect(result.success?).to eq(false)
        end

        it 'matches pattern ####T' do
          data   = input.merge('registration_no' => '1234T')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'matches pattern ####A' do
          data   = input.merge('registration_no' => '3456A')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'matches pattern ####P' do
          data   = input.merge('registration_no' => '6789P')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(true)
        end

        it 'does not match pattern #####P' do
          data   = input.merge('registration_no' => '16789P')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end
      end

      context 'md offers dcc' do
        %w{Y N}.each do |val|
          it "is valid when '#{val}'" do
            data   = input.merge('md_offers_dcc' => val)
            result = Mediator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        it "is invalid when 'a'" do
          data   = input.merge('md_offers_dcc' => 'a')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

        it 'is invalid when it is missing' do
          data   = input.merge('md_offers_dcc' => '')
          result = Mediator.new(data).validate
          expect(result.success?).to eq(false)
        end

      end
    end
  end
end