FactoryGirl.define do
  factory :practice_hash, class:Hash do
    skip_create

    address '15 Smith Street, London WC1R 4RL'
    tel nil
    url nil
    email nil

    trait :valid_email do
      email 'valid@email.com'
    end

    trait :invalid_email do
      email 'invalidemail.com'
    end

    initialize_with { attributes }
  end
end