Feature: Uploading a valid spreadsheet will change the data in the database backing the API.

  Scenario: Upload file successfully
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid | MD_PPC_ID | FMCA_Cert       |
      | 1234T           | Y             | Irons        | John          | Y                      | not known | working towards |
      | 3456T           | Y             | Irons        | John          | Y                      | not known | working towards |
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
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid | MD_PPC_ID | FMCA_Cert       |
      | 1234T           | Y             | Irons        | John          | Y                      | not known | working towards |
      | 3456T           | Y             | Irons        | John          | Y                      | not known | working towards |
    Then I see 'Check file details before processing the excel file'
    When I click 'Process data and apply updates'
    And I visit '/api/v1/mediators'
    Then the response data should have 2 items
