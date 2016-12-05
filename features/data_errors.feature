Feature: A spreadsheet upload is validated against a set of rules. If there are
  validation errors, they are presented on-screen. These errors must be corrected
  in the spreadsheet to successfully upload new data to the database backing the
  API.

  Scenario: Mediator file errors
    Given I upload a spreadsheet like this:
      |  |
    Then I should see the following file errors:
      | Error                     |
      | The file contains no data |

  Scenario: Mediator data errors
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN   | FMCA Date       |
      | 1234T |     | Mr    | Irons     | John       | Y                   | not known | working towards |
      | 3459A | Y   | Mr    | Wayne     | Bruce      |                     | not known | unknown         |
      | 5436P | Y   | Mr    | Romanova  | Natalia    | Y                   | not known | 18/2015         |
      | 1948A |     | Mr    | Kovacs    |            | Y                   | not known | 1992            |
      | 1948A | Y   |       |           | Loki       | Y                   | not known | 05/2001         |
    And I click 'Process data and apply updates'
    Then I should see the following item errors:
      | Row | Field               | Message                                                        |
      | 2   | dcc                 | must be one of: Y, N                                           |
      | 3   | legal_aid_qualified | must be one of: Y, N                                           |
      | 4   | fmca_date           | must be one of: unknown, working towards or must be dd/mm/yyyy |
      | 5   | dcc                 | must be one of: Y, N                                           |
      | 5   | first_name          | must be filled                                                 |
      | 6   | last_name           | must be filled                                                 |
      | 6   | title               | must be filled                                                 |

  Scenario: Duplicate registration number
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN   | FMCA Date |
      | 1234T | Y   | Mrs   | Irons     | John       | Y                   | not known | unknown   |
      | 1234T | Y   | Mrs   | Wayne     | Bruce      | Y                   | not known | unknown   |
    And I click 'Process data and apply updates'
    Then I should see the following collection errors:
      | Error         | Value(s) |
      | Duplicate URN | 1234T    |

  Scenario: PPC URN not recognised
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN | FMCA Date |
      | 1234T | Y   | Mr    | Irons     | John       | Y                   | 4567E   | unknown   |
      | 4567E | Y   | Mr    | Wayne     | Bruce      | Y                   | 5647T   | unknown   |
    And I click 'Process data and apply updates'
    Then I should see the following collection errors:
      | Error                  | Value(s) |
      | PPC URN not recognised | 5647T    |

