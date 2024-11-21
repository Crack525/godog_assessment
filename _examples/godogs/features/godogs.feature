Feature: eat godogs
  In order to be happy
  As a hungry gopher
  I need to be able to eat godogs

  Scenario Outline: Eating godogs updates the count
    Given there are <INITIAL> godogs
    When I eat <EAT>
    Then there should be <REMAINING> remaining

    Examples:
      | INITIAL | EAT | REMAINING |
      | 20      | 13  | 7         |
      | 12      | 5   | 7         |
      | 20      | 10  | 10        |
      | 10      | 10  | 0         |
      | 20      | 0   | 20        |
      | 10      | 1   | 9         |

  
  Scenario Outline: Error when eating more than available
    Given there are 5 godogs
    When I eat 10
    Then an error should occur with message <ERROR_MESSAGE>

    Examples:
      | ERROR_MESSAGE                                      |
      | "cannot eat more godogs than available"            |

