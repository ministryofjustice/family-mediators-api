RSpec.shared_examples 'a required boolean' do |field_name|
  context 'when blank' do
    let(:data) { create(:mediator_hash, {field_name => ''}) }
    it { should_not be_valid }
  end

  context "when is 'Y'" do
    let(:data) { create(:mediator_hash, {field_name => 'Y'}) }
    it { should be_valid }
  end

  context "when is 'N'" do
    let(:data) { create(:mediator_hash, {field_name => 'N'}) }
    it { should be_valid }
  end

  context 'when is not Y or N' do
    let(:data) { create(:mediator_hash, {field_name => 'a'}) }
    it { should_not be_valid }
  end

  context 'when is not YN' do
    let(:data) { create(:mediator_hash, {field_name => 'YN'} ) }
    it { should_not be_valid }
  end
end

RSpec.shared_examples 'a URN' do |field_name|
  context 'when blank' do
    let(:data) { create(:mediator_hash, {field_name => ''}) }
    it { should_not be_valid }
  end

  %w(1234T 1234A 1234P).each do |val|
    context "when matches pattern #{val}" do
      let(:data) { create(:mediator_hash, {field_name => val}) }
      it { should be_valid }
    end
  end

  context 'when does not match registration format' do
    let(:data) { create(:mediator_hash, {field_name => '16789P'}) }
    it { should_not be_valid }
  end
end

RSpec.shared_examples 'a required string' do |field_name|
  context 'when blank' do
    let(:data) { create(:mediator_hash, {field_name => ''}) }
    it { should_not be_valid }
  end

  context 'when is non-blank string' do
    let(:data) { create(:mediator_hash, {field_name => 'string'}) }
    it { should be_valid }
  end

  context 'when is number' do
    let(:data) { create(:mediator_hash, {field_name => 123}) }
    it { should_not be_valid }
  end
end