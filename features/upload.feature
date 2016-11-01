Feature: Admin app

  Scenario: Upload file successfully
    Given I upload a well-formed spreadsheet
    And I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then the response data should have 7 items

  Scenario: Delete previous records
    Given there's 10 records in the database
    And I visit '/api/v1/mediators'
    And the response data should have 10 items
    When I upload a well-formed spreadsheet
    And I visit '/api/v1/mediators'
    Then the response data should have 7 items