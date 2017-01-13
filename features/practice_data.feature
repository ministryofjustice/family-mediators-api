Feature: The spreadsheet administrator enters practice data for a mediator under a column called 'md_practices'.

  A mediator can practice from multiple practices. A practice can contain:

  - address (required)
  - website
  - phone number
  - email address

  The practice data is entered on a single line, with each part delimited by a |. Multiple practices are delimited by
  a new line \n.

  Scenario Outline: Practice data warnings
    Given I upload a mediator with practice data <PracticeCell>
    Then I see '<Message>'

    Examples: Unmatchable tel
      | PracticeCell                                                                   | Message                                            |
      | 5bobbins \|15 Smith Street, London WC1R 4RL \| bish@bash.com \| http://foo.com | Record 1: Practice 1: Could not identify: 5bobbins |

    Examples: Unmatchable email
      | PracticeCell                                                                        | Message                                                  |
      | 01234-567890 \|15 Smith Street, London WC1R 4RL \| bish(at)bash.com \| http://foo.com | Record 1: Practice 1: Could not identify: bish(at)bash.com |

    Examples: Unmatchable address
      | PracticeCell                                                              | Message                                                           |
      | 01234-567890 \|15 Smith Street, London \| bish@bash.com \| http://foo.com | Record 1: Practice 1: Could not identify: 15 Smith Street, London |


  Scenario Outline: Practice data validation
    Given I upload a mediator with practice data <PracticeCell>
    And I click 'Process data and apply updates'
    Then the validation error message should be <Message>

    Examples: Invalid telephone number
      | PracticeCell                              | Message                                   |
      | 071 23358\|15 Smith Street, London WC1R 4RL | Practice 1: Must be valid UK phone number |

    Examples: Invalid URL
      | PracticeCell                                      | Message                       |
      | 15 Smith Street, London WC1R 4RL \| www.smith.com | Practice 1: Must be valid URL |
    
    Examples: Invalid email
      | PracticeCell                                       | Message                                 |
      | 15 Smith Street, London WC1R 4RL \| invalid@@email | Practice 1: Must be valid email address |
