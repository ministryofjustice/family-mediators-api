Feature: Redirects root path to admin homepage

  Scenario: Visiting /
    When I visit '/'
    Then I am shown the admin homepage
