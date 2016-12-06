FactoryGirl.define do
  factory :unparsed_practice, class: String do
    skip_create

    address '15 Smith Street, London WC1R 4RL'
    tel nil
    url nil
    email nil

    trait :email do
      email 'valid@email.com'
    end

    trait :invalid_email do
      email 'invalid@@email.com'
    end

    trait :tel do
      tel '01245 605040'
    end

    trait :url do
      url 'http://www.foobar.com/baz/'
    end

    trait :missing_postcode do
      address '15 Smith Street, London'
    end

    initialize_with { new("#{[address, tel, url, email].compact.join('|')}") }

    factory :parsed_practice do
      initialize_with { attributes }
    end
  end
end