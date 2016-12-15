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
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN   | FMCA Date       |
      | 1234T |     | Mr    | Irons     | John       | No                  | No                  | not known | working towards |
      | 3459A | No  | Mr    | Wayne     | Bruce      |                     | No                  | not known | unknown         |
      | 5436P | No  | Mr    | Romanova  | Natalia    | No                  |                     | not known | 18/2015         |
      | 1948A |     | Mr    | Kovacs    |            | No                  | No                  | not known |                 |
      | 1948A | No  |       |           | Loki       | No                  | No                  | not known | 05/2001         |
    And I click 'Process data and apply updates'
    Then I should see the following item errors:
      | Row | Field               | Message                                                                             |
      | 2   | dcc                 | must be one of: Yes, No                                                             |
      | 3   | legal_aid_qualified | must be one of: Yes, No                                                             |
      | 4   | legal_aid_franchise | must be one of: Yes, No                                                             |
      | 4   | fmca_date           | cannot be defined or must be one of: unknown, working towards or must be dd/mm/yyyy |
      | 5   | first_name          | must be filled                                                                      |
      | 5   | dcc                 | must be one of: Yes, No                                                             |
      | 6   | last_name           | must be filled                                                                      |
      | 6   | title               | must be filled                                                                      |

  Scenario: Duplicate registration number
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN   |
      | 1234T | No  | Mrs   | Irons     | John       | No                  | not known |
      | 1234T | No  | Mrs   | Wayne     | Bruce      | No                  | not known |
    And I click 'Process data and apply updates'
    Then I should see the following collection errors:
      | Error         | Value(s) |
      | Duplicate URN | 1234T    |

  Scenario: PPC URN not recognised
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | PPC URN |
      | 1234T | No  | Mr    | Irons     | John       | No                  | 4567E   |
      | 4567E | No  | Mr    | Wayne     | Bruce      | No                  | 5647T   |
    And I click 'Process data and apply updates'
    Then I should see the following collection errors:
      | Error                  | Value(s) |
      | PPC URN not recognised | 5647T    |

