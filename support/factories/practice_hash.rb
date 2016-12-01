FactoryGirl.define do
  factory :practice_hash, class:Hash do
    skip_create

    address '15 Smith Street, London WC1R 4RL'
    tel nil
    url nil

    # trait :tel do
    #   tel '020 8123 3456'
    # end
    #
    # trait :url do
    #   url 'http://www.gov.uk/'
    # end

    initialize_with { attributes }
  end
end