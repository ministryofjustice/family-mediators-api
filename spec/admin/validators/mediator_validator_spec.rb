
RSpec::Matchers.define :be_valid do
  match do |actual|
    actual.success? == true
  end
end

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

      subject(:result) do
        MediatorValidator.new(data).validate
      end

      describe 'registration_no' do

        context 'when blank' do
          let(:data) { valid_input.merge('registration_no' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('registration_no') } }
          it { should_not be_valid}
        end

        %w{8297T 3592A 9371P}.each do |val|
          context "when matches pattern #{val}" do
            let(:data) { valid_input.merge('registration_no' => val) }
            it { should be_valid}
          end
        end

        context 'when does not match registration format' do
          let(:data) { valid_input.merge('registration_no' => '16789P') }
          it { should_not be_valid}
        end

      end

      describe 'md_offers_dcc' do

        context 'when blank' do
          let(:data) { valid_input.merge('md_offers_dcc' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('md_offers_dcc') } }
          it { should_not be_valid}
        end

        %w{Y N}.each do |val|
          context "when is '#{val}'" do
            let(:data) { valid_input.merge('md_offers_dcc' => val) }
            it { should be_valid}
          end
        end

        context 'when is not Y or N' do
          let(:data) { valid_input.merge('md_offers_dcc' => 'a') }
          it { should_not be_valid}
        end

        context 'when is not YN' do
          let(:data) { valid_input.merge('md_offers_dcc' => 'YN') }
          it { should_not be_valid}
        end

      end

      describe 'md_first_name' do

        context 'when blank' do
          let(:data) { valid_input.merge('md_first_name' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('md_first_name') } }
          it { should_not be_valid}
        end

        context 'when is non-blank string' do
          let(:data) { valid_input.merge('md_first_name' => 'John') }
          it { should be_valid}
        end

        context 'when is number' do
          let(:data) { valid_input.merge('md_first_name' => 123) }
          it { should_not be_valid}
        end

      end

      describe 'md_last_name' do

        context 'when blank' do
          let(:data) { valid_input.merge('md_last_name' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('md_last_name') } }
          it { should_not be_valid}
        end

        context 'when is non-blank string' do
          let(:data) { valid_input.merge('md_last_name' => 'John') }
          it { should be_valid}
        end

        context 'when is number' do
          let(:data) { valid_input.merge('md_last_name' => 123) }
          it { should_not be_valid}
        end

      end

      describe 'md_mediation_legal_aid' do

        context 'when blank' do
          let(:data) { valid_input.merge('md_mediation_legal_aid' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('md_mediation_legal_aid') } }
          it { should_not be_valid}
        end

        %w{Y N}.each do |val|
          context "when is '#{val}'" do
            let(:data) { valid_input.merge('md_mediation_legal_aid' => val) }
            it { should be_valid}
          end
        end

        context 'when is not Y or N' do
          let(:data) { valid_input.merge('md_mediation_legal_aid' => 'a') }
          it { should_not be_valid}
        end

        context 'when is not YN' do
          let(:data) { valid_input.merge('md_mediation_legal_aid' => 'YN') }
          it { should_not be_valid}
        end

      end

      describe 'md_ppc_id' do

        context 'when blank' do
          let(:data) { valid_input.merge('md_ppc_id' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('md_ppc_id') } }
          it { should_not be_valid}
        end

        %w{8297T 3592A 9371P}.each do |val|
          context "when matches pattern #{val}" do
            let(:data) { valid_input.merge('md_ppc_id' => val) }
            it { should be_valid}
          end
        end

        context 'when "not known"' do
          let(:data) { valid_input.merge('md_ppc_id' => 'not known') }
          it { should be_valid}
        end

      end

      describe 'fmca_cert' do

        context 'when blank' do
          let(:data) { valid_input.merge('fmca_cert' => '') }
          it { should_not be_valid}
        end

        context 'when missing' do
          let(:data) { valid_input.tap { |k| k.delete('fmca_cert') } }
          it { should_not be_valid}
        end

        ['unknown','working towards'].each do |val|
          context "when '#{val}'" do
            let(:data) { valid_input.merge('fmca_cert' => val) }
            it { should be_valid}
          end
        end

        ['2016', '05/2016', '24/07/2016'].each do |val|
          context "when '#{val}'" do
            let(:data) { valid_input.merge('fmca_cert' => val) }
            it { should be_valid}
          end
        end

        ['13/2016','32/04/2016'].each do |val|
          context "when '#{val}'" do
            let(:data) { valid_input.merge('fmca_cert' => val) }
            it { should_not be_valid}
          end
        end

        context "when 'blah'" do
          let(:data) { valid_input.merge('fmca_cert' => 'blah') }
          it { should_not be_valid}
        end

      end
    end
  end
end