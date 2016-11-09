Feature: Admin app

  Scenario: Upload file successfully
    Given I upload a spreadsheet with 0 warnings and 0 errors
    And I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: Delete previous records
    Given there's 10 records in the database
    And I visit '/api/v1/mediators'
    And the response data should have 10 items
    When I upload a spreadsheet with 0 warnings and 0 errors
    And I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: Display fatal errors
    Given I upload a spreadsheet with 0 warnings and 4 errors
    Then I see 'There were 4 fatal errors'