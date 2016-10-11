FactoryGirl.define do
  factory :mediator, class: Mediators::Models::Mediator do
    data '{"name": "Fred"}'
  end
end
