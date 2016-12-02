module Admin
  module Validators
    describe PracticeValidator do

      subject(:result) do
        PracticeValidator.new(practice_hash).validate
      end

      describe 'practices' do
        describe 'telephone number' do
          context 'when nil' do
            let(:practice_hash) { create(:practice_hash, tel: nil) }
            it { should be_valid }
          end

          context 'when blank' do
            let(:practice_hash) { create(:practice_hash, tel: '') }
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
              let(:practice_hash) { create(:practice_hash, tel: phone_number) }
              it { should be_valid }
            end
          end

          context 'when too short' do
            let(:practice_hash) { create(:practice_hash, tel: '01234') }
            it { should_not be_valid }
          end

          context 'when alpha' do
            let(:practice_hash) { create(:practice_hash, tel: 'abcdef') }
            it { should_not be_valid }
          end
        end

        describe 'url' do
          context 'when nil' do
            let(:practice_hash) { create(:practice_hash, url: nil) }
            it { should be_valid }
          end

          %w(http://www.gov.uk
             http://www.gov.uk/mediators
             http://www.gov.uk/mediators/
             http://www.gov.uk/mediators/?type
             http://www.gov.uk/mediators/?type=family
             https://www.gov.uk/mediators/?type=family).each do |url|
            context "when #{url}" do
              let(:practice_hash) { create(:practice_hash, url: url) }
              it { should be_valid }
            end
          end

          context 'when scheme is missing' do
            let(:practice_hash) { create(:practice_hash, url: 'www.gov.uk' ) }
            it { should_not be_valid }
          end

          context 'when scheme is file' do
            let(:practice_hash) { create(:practice_hash, url: 'file://www.gov.uk' ) }
            it { should_not be_valid }
          end
        end

        describe 'address' do
          context 'when nil' do
            let(:practice_hash) { create(:practice_hash, address: nil ) }
            it { should_not be_valid}
          end

          context 'when is filled with a string' do
            let(:practice_hash) { create(:practice_hash, address: '15 Smith Street, London SE19 2SM' ) }
            it { should be_valid}
          end
        end
      end
    end
  end
end