Feature: Uploading a valid spreadsheet will change the data in the database backing the API.

  Scenario: Upload file successfully
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN   | FMCA Date  |
      | 1234T | Yes | Mr    | Irons     | John       | Yes                 | No                  | not known | 01/02/2003 |
      | 3456T | No  | Mr    | Irons     | John       | No                  | Yes                 | not known | 01/02/2003 |
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
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN   | FMCA Date  |
      | 1234T | No  | Mr    | Irons     | John       | No                  | Yes                 | not known | 01/02/2003 |
      | 3456T | Yes | Mr    | Irons     | John       | Yes                 | No                  | not known | 01/02/2003 |
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    And I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: With a blacklist
    Given I have a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid | MD_PPC_ID | FMCA_Cert       |
      | 1234T           | Y             | Irons        | John          | Y                      | not known | working towards |
      | 3456T           | Y             | Irons        | John          | Y                      | not known | working towards |
    And a blacklist of:
      | MD_PPC_ID |
      | FMCA_Cert |
    When I upload the spreadsheet
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    Then I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then I see 'registration_no'
    But I do not see 'md_ppc_id'
    And I do not see 'fmca_cert'
