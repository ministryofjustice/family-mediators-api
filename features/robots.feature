Feature: Site blocks web spiders

  Scenario: Web spider looks for /robots.txt 
    Given I am an unauthenticated user
    When I visit '/robots.txt'
    Then I see 'User-Agent: *'
    And I see 'Disallow: /'
