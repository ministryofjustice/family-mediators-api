RSpec.shared_examples "a required boolean" do |field_name|
  context "when blank" do
    let(:data) { create(:mediator_hash, { field_name => "" }) }
    it { should_not be_valid }
  end

  context "when is 'Yes'" do
    let(:data) { create(:mediator_hash, { field_name => "Yes" }) }
    it { should be_valid }
  end

  context "when is 'No'" do
    let(:data) { create(:mediator_hash, { field_name => "No" }) }
    it { should be_valid }
  end

  context "when is not Y or N" do
    let(:data) { create(:mediator_hash, { field_name => "Y" }) }
    it { should_not be_valid }
  end
end

RSpec.shared_examples "a URN" do |field_name|
  %w[1234T 1234A 1234P].each do |val|
    context "when matches pattern #{val}" do
      let(:data) { create(:mediator_hash, { field_name => val }) }
      it { should be_valid }
    end
  end

  context "when does not match registration format" do
    let(:data) { create(:mediator_hash, { field_name => "16789P" }) }
    it { should_not be_valid }
  end
end

RSpec.shared_examples "a required field" do |field_name, value = "string"|
  context "when blank" do
    let(:data) { create(:mediator_hash, { field_name => "" }) }
    it { should_not be_valid }
  end

  context "when is non-blank string" do
    let(:data) { create(:mediator_hash, { field_name => value }) }
    it { should be_valid }
  end
end

RSpec.shared_examples "a string" do |field_name|
  context "when is number" do
    let(:data) { create(:mediator_hash, { field_name => 123 }) }
    it { should_not be_valid }
  end
end

RSpec.shared_examples "an optional date" do |field_name|
  context "when not present" do
    let(:data) { create(:mediator_hash) }
    it { should be_valid }
  end

  context "when blank" do
    let(:data) { create(:mediator_hash, field_name => "", training_date: "01/02/2016") }
    it { should be_valid }
  end

  %w[2016 05/2016 24/07/2016].each do |val|
    context "when #{val}" do
      let(:data) { create(:mediator_hash, { field_name => val }) }
      it { should be_valid }
    end
  end

  %w[13/2016 32/04/2016].each do |val|
    context "when #{val}" do
      let(:data) { create(:mediator_hash, { field_name => val }) }
      it { should_not be_valid }
    end
  end

  context "when any other content" do
    let(:data) { create(:mediator_hash, field_name => "blah") }
    it { should_not be_valid }
  end
end
