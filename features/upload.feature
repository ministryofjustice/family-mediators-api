Feature: Admin app

  Scenario: Upload file successfully
    Given I upload a well-formed spreadsheet
    And I see 'File uploaded'
    When I visit '/api/v1/mediators'
    Then the response data should have 7 items

  Scenario: Replace previous records
    Given I upload a well-formed spreadsheet
    And I see 'File uploaded'
    And I upload a well-formed spreadsheet
    And I see 'File uploaded'
    When I visit '/api/v1/mediators'
    Then the response data should have 7 items