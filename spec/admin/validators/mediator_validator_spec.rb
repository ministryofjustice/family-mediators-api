module Admin
  module Validators
    describe MediatorValidator do

      let(:registration_no) { '1234A' }
      let(:md_offers_dcc) { 'Y' }
      let(:title) { 'Mr' }
      let(:md_first_name) { 'John' }
      let(:md_last_name) { 'Smith' }
      let(:md_mediation_legal_aid) { 'Y' }
      let(:md_ppc_id) { '8297A' }
      let(:fmca_cert) { '21/11/2016' }
      let(:md_practices) do
        [{
             :tel => '020 8123 3456',
             :url => 'https://www.gov.uk/',
             :address => '15 Smith Street, London WC1R 4RL'
        }]
      end

      let(:data) do
        create(:mediator_hash)
        # {
        #     :registration_no => registration_no,
        #     :md_offers_dcc => md_offers_dcc,
        #     :title => title,
        #     :md_first_name => md_first_name,
        #     :md_last_name => md_last_name,
        #     :md_mediation_legal_aid => md_mediation_legal_aid,
        #     :md_ppc_id => md_ppc_id,
        #     :fmca_cert => fmca_cert,
        #     :md_practices => md_practices
        # }
      end

      subject(:result) do
        MediatorValidator.new(data).validate
      end

      describe('md_practices') do
        context 'when 0 practices' do
          let(:md_practices) { [] }
          it { should be_valid }
        end
      end

      describe 'registration_no' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, registration_no: '')}
          it { should_not be_valid }
        end


        context "when matches pattern ####T" do
          let(:data) { create(:mediator_hash, registration_no: '9371T') }
          it { should be_valid }
        end

        context "when matches pattern ####A" do
          let(:data) { create(:mediator_hash, registration_no: '9371A') }
          it { should be_valid }
        end

        context "when matches pattern ####P" do
          let(:data) { create(:mediator_hash, registration_no: '9371P') }
          it { should be_valid }
        end

        context 'when does not match registration format' do
          let(:data) { create(:mediator_hash, registration_no: '16789P') }
          it { should_not be_valid }
        end

      end

      describe 'md_offers_dcc' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, md_offers_dcc: '') }
          it { should_not be_valid }
        end

        context "when is 'Y'" do
          let(:data) { create(:mediator_hash, md_offers_dcc: 'Y') }
          it { should be_valid }
        end

        context "when is 'N'" do
          let(:data) { create(:mediator_hash, md_offers_dcc: 'N') }
          it { should be_valid }
        end

        context 'when is not Y or N' do
          let(:data) { create(:mediator_hash, md_offers_dcc: 'a') }
          it { should_not be_valid }
        end

        context 'when is not YN' do
          let(:data) { create(:mediator_hash, md_offers_dcc: 'YN') }
          it { should_not be_valid }
        end

      end

      describe 'Title' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, title: '') }
          it { should_not be_valid }
        end

        context 'when filled' do
          let(:data) { create(:mediator_hash, title: 'Miss') }
          it { should be_valid }
        end

      end

      describe 'md_first_name' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, md_first_name: '') }
          it { should_not be_valid }
        end

        context 'when is non-blank string' do
          let(:data) { create(:mediator_hash, md_first_name: 'John') }
          it { should be_valid }
        end

        context 'when is number' do
          let(:data) { create(:mediator_hash, md_first_name: 123 ) }
          it { should_not be_valid }
        end

      end

      describe 'md_last_name' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, md_last_name: '') }
          it { should_not be_valid }
        end

        context 'when is non-blank string' do
          let(:data) { create(:mediator_hash, md_last_name: 'John') }
          it { should be_valid }
        end

        context 'when is number' do
          let(:data) { create(:mediator_hash, md_last_name: 123) }
          it { should_not be_valid }
        end

      end

      describe 'md_mediation_legal_aid' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, md_mediation_legal_aid: '') }
          it { should_not be_valid }
        end

        context "when is 'Y'" do
          let(:data) { create(:mediator_hash, md_mediation_legal_aid: 'Y') }
          it { should be_valid }
        end

        context "when is 'N'" do
          let(:data) { create(:mediator_hash, md_mediation_legal_aid: 'N') }
          it { should be_valid }
        end

        context 'when is not YN' do
          let(:data) { create(:mediator_hash, md_mediation_legal_aid: 'YN') }
          it { should_not be_valid }
        end

      end

      describe 'md_ppc_id' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, md_ppc_id: '') }
          it { should_not be_valid }
        end

        context 'when matches pattern ####T' do
          let(:data) { create(:mediator_hash, md_ppc_id: '8297T') }
          it { should be_valid }
        end

        context 'when matches pattern ####A' do
          let(:data) { create(:mediator_hash, md_ppc_id: '8297A') }
          it { should be_valid }
        end

        context 'when matches pattern ####P' do
          let(:data) { create(:mediator_hash, md_ppc_id: '8297P') }
          it { should be_valid }
        end

        context 'when "not known"' do
          let(:data) { create(:mediator_hash, md_ppc_id: 'not known') }
          it { should be_valid }
        end

        context 'when does not match registration format' do
          let(:data) { create(:mediator_hash, md_ppc_id: '16789P') }
          it { should_not be_valid }
        end

      end

      describe 'fmca_cert' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, fmca_cert: '') }
          it { should_not be_valid }
        end

        ['unknown', 'working towards','2016', '05/2016', '24/07/2016'].each do |val|
          context "when #{val}" do
            let(:data) { create(:mediator_hash, fmca_cert: val) }
            it { should be_valid }
          end
        end

        %w(13/2016 32/04/2016).each do |val|
          context "when '#{val}'" do
            let(:data) { create(:mediator_hash, fmca_cert: val) }
            it { should_not be_valid }
          end
        end

        context 'when any other content' do
          let(:data) { create(:mediator_hash, fmca_cert: 'blah') }
          it { should_not be_valid }
        end

      end

      describe('missing properties') do
        subject(:result) do
          MediatorValidator.new(missing_data).validate
        end

        keys = FactoryGirl.create(:mediator_hash).keys

        keys.each do |val|
          context "when #{val} missing" do
            let(:missing_data) { data.tap { |key| key.delete(val) } }
            it { should_not be_valid }
          end
        end
      end

    end
  end
end