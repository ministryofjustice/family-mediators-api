module Admin
  module Validators
    describe MediatorValidator do

      subject(:result) do
        MediatorValidator.new(data).validate
      end

      describe('practices') do
        context 'when 1 practices' do
          let(:data) do
            create(:mediator_hash, :include_practice)
          end
          it { should be_valid }

          it 'should include practices' do
            expect(data).to include(:practices)
          end

        end
      end

      describe 'urn' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, urn: '')}
          it { should_not be_valid }
        end

        context "when matches pattern ####T" do
          let(:data) { create(:mediator_hash, urn: '9371T') }
          it { should be_valid }
        end

        context "when matches pattern ####A" do
          let(:data) { create(:mediator_hash, urn: '9371A') }
          it { should be_valid }
        end

        context "when matches pattern ####P" do
          let(:data) { create(:mediator_hash, urn: '9371P') }
          it { should be_valid }
        end

        context 'when does not match registration format' do
          let(:data) { create(:mediator_hash, urn: '16789P') }
          it { should_not be_valid }
        end
      end

      describe 'dcc' do

        context 'when blank' do
          let(:data) { create(:mediator_hash, dcc: '') }
          it { should_not be_valid }
        end

        context "when is 'Y'" do
          let(:data) { create(:mediator_hash, dcc: 'Y') }
          it { should be_valid }
        end

        context "when is 'N'" do
          let(:data) { create(:mediator_hash, dcc: 'N') }
          it { should be_valid }
        end

        context 'when is not Y or N' do
          let(:data) { create(:mediator_hash, dcc: 'a') }
          it { should_not be_valid }
        end

        context 'when is not YN' do
          let(:data) { create(:mediator_hash, dcc: 'YN') }
          it { should_not be_valid }
        end

      end

      describe 'title' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, title: '') }
          it { should_not be_valid }
        end

        context 'when filled' do
          let(:data) { create(:mediator_hash, title: 'Miss') }
          it { should be_valid }
        end
      end

      describe 'first_name' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, first_name: '') }
          it { should_not be_valid }
        end

        context 'when is non-blank string' do
          let(:data) { create(:mediator_hash, first_name: 'John') }
          it { should be_valid }
        end

        context 'when is number' do
          let(:data) { create(:mediator_hash, first_name: 123 ) }
          it { should_not be_valid }
        end
      end

      describe 'last_name' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, last_name: '') }
          it { should_not be_valid }
        end

        context 'when is non-blank string' do
          let(:data) { create(:mediator_hash, last_name: 'John') }
          it { should be_valid }
        end

        context 'when is number' do
          let(:data) { create(:mediator_hash, last_name: 123) }
          it { should_not be_valid }
        end
      end

      describe 'legal_aid_qualified' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, legal_aid_qualified: '') }
          it { should_not be_valid }
        end

        context "when is 'Y'" do
          let(:data) { create(:mediator_hash, legal_aid_qualified: 'Y') }
          it { should be_valid }
        end

        context "when is 'N'" do
          let(:data) { create(:mediator_hash, legal_aid_qualified: 'N') }
          it { should be_valid }
        end

        context 'when is not YN' do
          let(:data) { create(:mediator_hash, legal_aid_qualified: 'YN') }
          it { should_not be_valid }
        end
      end

      describe 'ppc_urn' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, ppc_urn: '') }
          it { should_not be_valid }
        end

        context 'when matches pattern ####T' do
          let(:data) { create(:mediator_hash, ppc_urn: '8297T') }
          it { should be_valid }
        end

        context 'when matches pattern ####A' do
          let(:data) { create(:mediator_hash, ppc_urn: '8297A') }
          it { should be_valid }
        end

        context 'when matches pattern ####P' do
          let(:data) { create(:mediator_hash, ppc_urn: '8297P') }
          it { should be_valid }
        end

        context 'when "not known"' do
          let(:data) { create(:mediator_hash, ppc_urn: 'not known') }
          it { should be_valid }
        end

        context 'when does not match registration format' do
          let(:data) { create(:mediator_hash, ppc_urn: '16789P') }
          it { should_not be_valid }
        end
      end

      describe 'fmca_date' do
        context 'when blank' do
          let(:data) { create(:mediator_hash, fmca_date: '') }
          it { should_not be_valid }
        end

        ['unknown', 'working towards','2016', '05/2016', '24/07/2016'].each do |val|
          context "when #{val}" do
            let(:data) { create(:mediator_hash, fmca_date: val) }
            it { should be_valid }
          end
        end

        %w(13/2016 32/04/2016).each do |val|
          context "when '#{val}'" do
            let(:data) { create(:mediator_hash, fmca_date: val) }
            it { should_not be_valid }
          end
        end

        context 'when any other content' do
          let(:data) { create(:mediator_hash, fmca_date: 'blah') }
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