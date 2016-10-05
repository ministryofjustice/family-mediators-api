describe Mediators::Models::Mediator do

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :phone }
  it { is_expected.to respond_to :website }

end