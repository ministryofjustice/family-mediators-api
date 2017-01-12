Feature: Uploading un-parsable practices will raise warnings

  Scenario: Upload file successfully
    Given I upload a spreadsheet like this:
      | URN   | DCC | Title | Last Name | First Name | Legal Aid Qualified | Legal Aid Franchise | PPC URN   | FMCA Date  | Practices                                                             |
      | 1234T | Yes | Mr    | Irons     | John       | Yes                 | No                  | not known | 01/02/2003 | 999 \| 1 Pooh St, Wessex \| bish@bosh.com \| \n \|\|\| |
    Then I see 'Check file details before processing the excel file'
    And I see 'Record 1, practice 1: Unable to identify: 999'
    And I see 'Record 1, practice 1: Unable to identify: 1 Pooh St, Wessex'

