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
        it_should_behave_like 'a URN', 'urn'
      end

      describe 'ppc_urn' do
        it_should_behave_like 'a URN', 'ppc_urn'

        context 'when "not known"' do
          let(:data) { create(:mediator_hash, ppc_urn: 'not known') }
          it { should be_valid }
        end
      end

      %w(dcc legal_aid_qualified legal_aid_franchise).each do |field_name|
        describe field_name do
          it_should_behave_like 'a required boolean', field_name
        end
      end

      %w(title first_name last_name).each do |field_name|
        describe field_name do
          it_should_behave_like 'a required string', field_name
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

        keys = FactoryGirl.create(:mediator_hash).keys

        keys.each do |val|
          context "when #{val} missing" do
            let(:missing_data) { create(:mediator_hash).tap { |key| key.delete(val) } }
            it { should_not be_valid }
          end
        end
      end
    end
  end
end