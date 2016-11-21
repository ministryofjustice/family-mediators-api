Feature: A spreadsheet upload is validated against a set of rules. If there are
  validation errors, they are presented on-screen. These errors must be corrected
  in the spreadsheet to successfully upload new data to the database backing the
  API.

  Scenario: Mediator data errors
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid | MD_PPC_ID | FMCA_Cert       |
      | 1234T           |               | Irons        | John          | Y                      | not known | working towards |
      | 3459A           | Y             | Wayne        | Bruce         |                        | not known | unknown         |
      | 5436P           | Y             | Romanova     | Natalia       | Y                      | not known | 18/2015         |
      | 1948A           |               | Kovacs       |               | Y                      | not known | 1992            |
      | 1948A           | Y             |              | Loki          | Y                      | not known | 05/2001         |
    And I should see the following item errors:
      | Row | Field                  | Message                                                        |
      | 2   | md_offers_dcc          | must be one of: Y, N                                           |
      | 3   | md_mediation_legal_aid | must be one of: Y, N                                           |
      | 4   | fmca_cert              | must be one of: unknown, working towards or must be dd/mm/yyyy |
      | 5   | md_offers_dcc          | must be one of: Y, N                                           |
      | 5   | md_first_name          | must be filled                                                 |
      | 6   | md_last_name           | must be filled                                                 |

  Scenario: Duplicate registration number
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid | MD_PPC_ID | FMCA_Cert |
      | 1234T           | Y             | Irons        | John          | Y                      | not known | unknown   |
      | 1234T           | Y             | Wayne        | Bruce         | Y                      | not known | unknown   |
    And I should see the following collection errors:
      | Error                          | Value(s) |
      | Duplicate registration numbers | 1234T    |

  Scenario: MD_PPC_ID not recognised
    Given I upload a spreadsheet like this:
      | Registration No | MD_Offers_DCC | MD_Last_name | MD_First_name | MD_Mediation_legal_aid | MD_PPC_ID | FMCA_Cert |
      | 1234T           | Y             | Irons        | John          | Y                      | 4567E     | unknown   |
      | 4567E           | Y             | Wayne        | Bruce         | Y                      | 5647T     | unknown   |
    And I should see the following collection errors:
      | Error                    | Value(s) |
      | MD_PPC_ID not recognised | 5647T    |


