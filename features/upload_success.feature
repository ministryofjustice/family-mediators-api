Feature: Uploading a valid spreadsheet will change the data in the database backing the API.

  Scenario: Upload file successfully
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN | FMCA Date  |
      | 1234T | Yes | Mr    | Irons     | John       | Yes                 | No                  |         | 01/02/2003 |
      | 3456T | No  | Mr    | Irons     | John       | No                  | Yes                 |         | 01/02/2003 |
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    Then I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then the response data should have 2 items
    And the ids should be:
      | 1234 |
      | 3456 |
    When I visit '/api/v1/mediators/1234'
    Then the response should be mediator '1234T'

  Scenario: Delete previous records
    Given there's 10 records in the database
    And I visit '/api/v1/mediators'
    And the response data should have 10 items
    When I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN | FMCA Date  |
      | 1234T | No  | Mr    | Irons     | John       | No                  | Yes                 |         | 01/02/2003 |
      | 3456T | Yes | Mr    | Irons     | John       | Yes                 | No                  |         | 01/02/2003 |
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    And I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: With a blacklist
    Given I have a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN | FMCA Date  | Secret1 | Secret2 |
      | 1234T | Yes | Mr    | Irons     | John       | Yes                 | Yes                 |         | 01/02/2003 | 41      | 42      |
      | 3456T | Yes | Mr    | Irons     | John       | Yes                 | Yes                 |         | 01/02/2003 | 42      | 43      |
    And a blacklist of:
      | Secret1 |
      | Secret2 |
    When I upload the spreadsheet
    Then I see 'urn'
    And I see 'secret1'
    And I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    Then I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then I see 'urn'
    But I do not see 'secret1'
    And I do not see 'secret2'
