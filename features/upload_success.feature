Feature: Uploading a valid spreadsheet will change the data in the database backing the API.

  Scenario: Upload file successfully
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN   | FMCA Date       |
      | 1234T | Y   | Mr    | Irons     | John       | Y                   | not known | working towards |
      | 3456T | Y   | Mr    | Irons     | John       | Y                   | not known | working towards |
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    Then I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: Delete previous records
    Given there's 10 records in the database
    And I visit '/api/v1/mediators'
    And the response data should have 10 items
    When I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN   | FMCA Date       |
      | 1234T | Y   | Mr    | Irons     | John       | Y                   | not known | working towards |
      | 3456T | Y   | Mr    | Irons     | John       | Y                   | not known | working towards |
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    And I visit '/api/v1/mediators'
    Then the response data should have 2 items
