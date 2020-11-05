FactoryBot.define do
  factory :mediator, class: API::Models::Mediator do
    data { {'name' => 'Fred'} }
  end
end

FactoryBot.define do
  factory :mediator_hash, class:Hash do
    skip_create

    sequence(:urn, 1000) { |n| "#{n}T" }
    dcc { 'Yes' }
    title { 'Mr' }
    first_name { 'John' }
    last_name { 'Smith' }
    legal_aid_qualified { 'Yes' }
    legal_aid_franchise { 'No' }
    ppc_urn { '1001T' }
    fmca_date { '04/05/2007' }

    trait :invalid do
      urn { '1234X' }
    end

    trait :include_practice do
      practices { [create(:parsed_practice)] }
    end

    trait :include_unparsed_practice do
      practices { create(:unparsed_practice_all_parts) }
    end

    initialize_with { attributes }
  end

  factory :mediator_list, class:Array do
    skip_create

    transient do
      mediator_count { 3 }
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
