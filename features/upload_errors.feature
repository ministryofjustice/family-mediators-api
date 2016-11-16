Feature: A spreadsheet upload is validated against a set of rules. If there are validation errors, they
  are presented on-screen. These errors must be corrected in the spreadsheet to successfully upload new data to the
  database backing the API.

  Scenario: Mediator data errors
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid |
      | 1234T           |               | Irons        | John          | Y                      |
      | 3459A           | Y             | Wayne        | Bruce         |                        |
      | 5436P           | Y             | Romanova     | Natalia       | Y                      |
      | 1948A           |               | Kovacs       |               | Y                      |
      | 1948A           | Y             |              | Loki          | Y                      |
    Then I see 'There were 4 item errors'

  Scenario: Duplicate registration number
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid |
      | 1234T           | Y             | Irons        | John          | Y                      |
      | 1234T           | Y             | Wayne        | Bruce         | Y                      |
    Then I see 'There were 1 collection errors'
    And I should see the following collection errors:
      | Error                          | Value(s) |
      | Duplicate registration numbers | 1234T    |