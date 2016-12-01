module Admin
  module Validators
    describe MediatorValidator do

      subject(:result) do
        MediatorValidator.new(data).validate
      end

      describe('md_practices') do
        context 'when 1 practices' do
          let(:data) do
            create(:mediator_hash, :include_practice)
          end
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

        # let(:data) { create(:mediator_hash) }
        keys = FactoryGirl.create(:mediator_hash).keys

        keys.each do |val|
          context "when #{val} missing" do
            # data = create(:mediator_hash)
            let(:missing_data) { create(:mediator_hash).tap { |key| key.delete(val) } }
            it { should_not be_valid }
          end
        end
      end
    end
  end
end