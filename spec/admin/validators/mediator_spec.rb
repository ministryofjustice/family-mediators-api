module Admin
  module Validators
    describe Mediator do

      let(:input) do
        Hash[
          'registration_no' => '1234A'
        ]
      end

      context 'registration no' do

        subject { Mediator.new(data).validate }

        %w{6739T 1112A 3456P}.each do |val|
          it "when registration matches pattern #{val}" do
            data   = input.merge('registration_no' => val)
            result = Mediator.new(data).validate
            expect(result.success?).to eq(true)
          end
        end

        %w{6739AT A1A 1234X}.each do |val|
          it "is invalid when registration matches pattern #{val}" do
            data   = input.merge('registration_no' => val)
            result = Mediator.new(data).validate
            expect(result.success?).to eq(false)
          end
        end

      end

    end
  end
end