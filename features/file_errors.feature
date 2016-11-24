Feature: When a spreadsheet is empty the file is not processed.

  Scenario: Mediator file errors
    Given I upload a spreadsheet like this:
      ||
    Then I should see the following file errors:
      | Error |
      | The file contains no data |
