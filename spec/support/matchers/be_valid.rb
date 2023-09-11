RSpec::Matchers.define :be_valid do
  match do |actual|
    actual.success? == true
  end
end
