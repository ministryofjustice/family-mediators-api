module Admin
  module Validators
    describe MediatorValidator do

      let(:registration_no) { '1234A' }
      let(:md_offers_dcc) { 'Y' }
      let(:md_first_name) { 'John' }
      let(:md_last_name) { 'Smith' }
      let(:md_mediation_legal_aid) { 'Y' }
      let(:md_ppc_id) { '8297A' }
      let(:fmca_cert) { '21/11/2016' }

      let(:data) do
        {
            'registration_no'        => registration_no,
            'md_offers_dcc'          => md_offers_dcc,
            'md_first_name'          => md_first_name,
            'md_last_name'           => md_last_name,
            'md_mediation_legal_aid' => md_mediation_legal_aid,
            'md_ppc_id'              => md_ppc_id,
            'fmca_cert'              => fmca_cert
        }
      end

      subject(:result) do
        MediatorValidator.new(data).validate
      end

      describe 'registration_no' do

        context 'when blank' do
          let(:registration_no) { '' }
          it { should_not be_valid }
        end

        %w{8297T 3592A 9371P}.each do |val|
          context "when matches pattern #{val}" do
            let(:registration_no) { val }
            it { should be_valid }
          end
        end

        context 'when does not match registration format' do
          let(:registration_no) { '16789P' }
          it { should_not be_valid }
        end

      end

      describe 'md_offers_dcc' do

        context 'when blank' do
          let(:md_offers_dcc) { '' }
          it { should_not be_valid }
        end

        %w{Y N}.each do |val|
          context "when is '#{val}'" do
            let(:md_offers_dcc) { val }
            it { should be_valid }
          end
        end

        context 'when is not Y or N' do
          let(:md_offers_dcc) { 'a' }
          it { should_not be_valid }
        end

        context 'when is not YN' do
          let(:md_offers_dcc) { 'YN' }
          it { should_not be_valid }
        end

      end

      describe 'md_first_name' do

        context 'when blank' do
          let(:md_first_name) { '' }
          it { should_not be_valid }
        end

        context 'when is non-blank string' do
          let(:md_first_name) { 'John' }
          it { should be_valid }
        end

        context 'when is number' do
          let(:md_first_name) { 123 }
          it { should_not be_valid }
        end

      end

      describe 'md_last_name' do

        context 'when blank' do
          let(:md_last_name) { '' }
          it { should_not be_valid }
        end

        context 'when is non-blank string' do
          let(:md_last_name) { 'John' }
          it { should be_valid }
        end

        context 'when is number' do
          let(:md_last_name) { 123 }
          it { should_not be_valid }
        end

      end

      describe 'md_mediation_legal_aid' do

        context 'when blank' do
          let(:md_mediation_legal_aid) { '' }
          it { should_not be_valid }
        end

        %w{Y N}.each do |val|
          context "when is '#{val}'" do
            let(:md_mediation_legal_aid) { val }
            it { should be_valid }
          end
        end

        context 'when is not Y or N' do
          let(:md_mediation_legal_aid) { 'a' }
          it { should_not be_valid }
        end

        context 'when is not YN' do
          let(:md_mediation_legal_aid) { 'YN' }
          it { should_not be_valid }
        end

      end

      describe 'md_ppc_id' do

        context 'when blank' do
          let(:md_ppc_id) { '' }
          it { should_not be_valid }
        end

        %w{8297T 3592A 9371P}.each do |val|
          context "when matches pattern #{val}" do
            let(:md_ppc_id) { val }
            it { should be_valid }
          end
        end

        context 'when "not known"' do
          let(:md_ppc_id) { 'not known' }
          it { should be_valid }
        end

        context 'when does not match registration format' do
          let(:md_ppc_id) { '16789P' }
          it { should_not be_valid }
        end

      end

      describe 'fmca_cert' do

        context 'when blank' do
          let(:fmca_cert) { '' }
          it { should_not be_valid }
        end

        ['unknown', 'working towards','2016', '05/2016', '24/07/2016'].each do |val|
          context "when '#{val}'" do
            let(:fmca_cert) { val }
            it { should be_valid }
          end
        end

        %w(13/2016 32/04/2016).each do |val|
          context "when '#{val}'" do
            let(:fmca_cert) { val }
            it { should_not be_valid }
          end
        end

        context 'when any other content' do
          let(:fmca_cert) { 'blah' }
          it { should_not be_valid }
        end

      end

      describe('missing properties') do
        subject(:result) do
          MediatorValidator.new(missing_data).validate
        end

        keys = %w(registration_no md_offers_dcc md_first_name md_last_name md_mediation_legal_aid md_ppc_id fmca_cert)

        keys.each do |val|
          context "when #{val} missing" do
            let(:missing_data) { data.tap { |k| k.delete(val) } }
            it { should_not be_valid }
          end
        end
      end

    end
  end
end