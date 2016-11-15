Feature: Admin app

  Scenario: Upload file successfully
    Given I upload a spreadsheet with 2 valid mediators
    And I see 'Spreadsheet upload complete'
    When I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: Delete previous records
    Given there's 10 records in the database
    And I visit '/api/v1/mediators'
    And the response data should have 10 items
    When I upload a spreadsheet with 2 valid mediators
    And I visit '/api/v1/mediators'
    Then the response data should have 2 items

  Scenario: Display mediator errors
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid |
      | 1234T           |               | Irons        | John          | Y                      |
      | 3459A           | Y             | Wayne        | Bruce         |                        |
      | 5436P           | Y             | Romanova     | Natalia       | Y                      |
      | 1948A           |               | Kovacs       |               | Y                      |
      | 1948A           | Y             |              | Loki          | Y                      |
    Then I see 'There were 4 item errors'

  Scenario: Display collection errors
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid |
      | 1234T           | Y             | Irons        | John          | Y                      |
      | 1234T           | Y             | Wayne        | Bruce         | Y                      |
    Then I see 'There were 1 collection errors'
    And I should see the following collection errors:
      | Error                          | Value(s) |
      | Duplicate registration numbers | 1234T    |