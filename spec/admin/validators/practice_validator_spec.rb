module Admin
  module Validators
    describe PracticeValidator do

      let(:tel) { '020 8123 3456' }

      let(:md_practice) do
        {
            :tel => tel
        }
      end

      subject(:result) do
        PracticeValidator.new(md_practice).validate
      end

      describe 'practices' do

        describe 'telephone number' do

          context 'when nil' do
            let(:tel) { nil }
            it { should be_valid }
          end

          context 'when blank' do
            let(:tel) { '' }
            it { should_not be_valid }
          end

          [
              '07345 123 345',
              '07345123345',
              '+44 7345 123 345',
              '+447345123345',
              '020 8123 5678 ext234'
          ].each do |phone_number|
            context "when #{phone_number}" do
              let(:tel) { phone_number }
              it { should be_valid }
            end
          end

          context 'when too short' do
            let(:tel) { '01234' }
            it { should_not be_valid }
          end

          context 'when alpha' do
            let(:tel) { 'abcdef' }
            it { should_not be_valid }
          end

        end

      end
    end
  end
end