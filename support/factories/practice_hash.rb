FactoryGirl.define do
  factory :practice_hash, class:Hash do
    skip_create

    address '15 Smith Street, London WC1R 4RL'
    tel nil
    url nil

    initialize_with { attributes }
  end
end