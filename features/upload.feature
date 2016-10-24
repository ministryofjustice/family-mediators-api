Feature: Admin app

  Scenario: Admin homepage
    Given I visit the Mediators Admin homepage
    When I upload a file
    Then I should see the size of the file
