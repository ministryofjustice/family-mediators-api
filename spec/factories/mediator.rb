FactoryGirl.define do
  factory :mediator, class: API::Models::Mediator do
    data 'name' => 'Fred'
  end
end