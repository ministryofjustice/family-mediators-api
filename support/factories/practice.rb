FactoryBot.define do
  factory :unparsed_practice, class: String do
    skip_create

    address { '15 Smith Street, London WC1R 4RL' }

    trait :missing_postcode do
      address { '15 Smith Street, London' }
    end

    initialize_with { new("#{address}") }

    factory :parsed_practice, class: Hash do
      initialize_with { attributes }
    end

    factory :unparsed_practice_all_parts do
      tel { '01245 605040' }
      url { 'http://www.foobar.com/baz/' }
      email { 'valid@email.com' }

      initialize_with { new("#{[address, tel, url, email].compact.join('|')}") }

      factory :shuffled_unparsed_practice do
        initialize_with { new("#{[address, tel, url, email].shuffle.compact.join('|')}") }
      end

      factory :whitespaced_unparsed_practice do
        initialize_with { new("#{[address, tel, url, email].compact.join('  |  ')}") }
      end

      factory :parsed_practice_all_parts do
        initialize_with { attributes }
      end
    end
  end
end
