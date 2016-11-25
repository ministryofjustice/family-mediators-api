Feature: The spreadsheet administrator enters practice data for a mediator under a column called 'md_practices'.

  A mediator can practice from multiple practices. A practice can contain:

  - address (required)
  - website
  - phone number
  - email address

  The practice data is entered on a single line, with each part delimited by a |. Multiple practices are delimited by
  a new line \n.

  Scenario: Practice validation
    Given I upload a valid mediator with the following practice data:
      """
      0712335|15 Smith Street, London SE19 2SM|john@smith.com|www.smith.com
      """
    And I click 'Process data and apply updates'
    Then I should see these error messages:
      | Practice 1: Phone number must be valid UK number |
