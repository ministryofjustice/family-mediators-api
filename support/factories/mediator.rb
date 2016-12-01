FactoryGirl.define do
  factory :mediator, class: API::Models::Mediator do
    data 'name' => 'Fred'
  end
end

FactoryGirl.define do
  factory :mediator_hash, class:Hash do
    skip_create

    transient do
      sequence(:registration_no, 1000) { |n| "#{n}T" }
      md_offers_dcc 'Y'
      title 'Mr'
      md_first_name 'John'
      md_last_name 'Smith'
      md_mediation_legal_aid 'Y'
      md_ppc_id { '1001T' }
      fmca_cert '21/11/2016'
    end

    trait :invalid do
      registration_no '1234X'
    end

    initialize_with{{
        registration_no: registration_no,
        md_offers_dcc: md_offers_dcc,
        title: title,
        md_first_name: md_first_name,
        md_last_name: md_last_name,
        md_mediation_legal_aid: md_mediation_legal_aid,
        md_ppc_id: md_ppc_id,
        fmca_cert: fmca_cert
    }}
  end

  factory :mediator_list, class:Array do
    skip_create

    transient do
      mediator_count 3
    end

    initialize_with do
      mediators = []
      mediators << create(:mediator_hash, registration_no: '1000T', md_ppc_id: '1001T')
      (mediator_count - 1).times do |i|
        mediators << create(:mediator_hash, registration_no: "#{1001 + i}T", md_ppc_id: '1000T')
      end
      mediators
    end

    factory :mediator_list_with_invalid_item do

    end

  end

end

