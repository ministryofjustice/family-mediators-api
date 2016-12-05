FactoryGirl.define do
  factory :mediator, class: API::Models::Mediator do
    data 'name' => 'Fred'
  end
end

FactoryGirl.define do
  factory :mediator_hash, class:Hash do
    skip_create

    sequence(:urn, 1000) { |n| "#{n}T" }
    dcc 'Y'
    title 'Mr'
    first_name 'John'
    last_name 'Smith'
    legal_aid_qualified 'Y'
    ppc_urn { '1001T' }
    fmca_date '21/11/2016'

    trait :invalid do
      urn '1234X'
    end

    trait :include_practice do
      practices { [create(:practice_hash)] }
    end

    initialize_with { attributes }
  end

  factory :mediator_list, class:Array do
    skip_create

    transient do
      mediator_count 3
    end

    initialize_with do
      mediators = []
      mediators << create(:mediator_hash, urn: '1000T', ppc_urn: '1001T')
      (mediator_count - 1).times do |i|
        mediators << create(:mediator_hash, urn: "#{1001 + i}T", ppc_urn: '1000T')
      end
      mediators
    end
  end
end

