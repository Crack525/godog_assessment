Feature: Timestamp Conversion Endpoint

Scenario: Return original timestamp when no format is provided
  When I send "GET" request to "/timestamp" with time "2023-12-01T10:02:01Z" and format ""
  Then the response code should be 200
  And the response should match json:
    """
    {
      "timestamp": "2023-12-01T10:02:01Z"
    }
    """

Scenario: Handle missing time parameter
  When I send "GET" request to "/timestamp" with time "" and format "2006-01-02"
  Then the response code should be 200

Scenario Outline: Convert timestamp to supported formats
  When I send "GET" request to "/timestamp" with time "2023-12-01T10:02:01Z" and format "<target_format>"
  Then the response code should be 200
  And the response should match json:
    """
    {
      "timestamp": "<expected_timestamp>"
    }
    """

  Examples:
    | target_format   | expected_timestamp |
    | 2006-01-02      | 2023-12-01         |
    | 02-Jan-2006     | 01-Dec-2023        |
    | Jan 2, 2006     | Dec 1, 2023        |
    | 02/01/2006      | 01/12/2023         |
    | 01/02/2006      | 12/01/2023         |

Scenario: Handle unsupported format
  When I send "GET" request to "/timestamp" with time "2023-12-01T10:02:01Z" and format "UNSUPPORTED"
  Then the response code should be 400

Scenario: Ensure format parameter validation
  When I send "GET" request to "/timestamp" with time "2023-12-01T10:02:01Z" and format "invalid-format"
  Then the response code should be 400

Scenario: Handle invalid time format
  When I send "GET" request to "/timestamp" with time "invalid-time" and format "2006-01-02"
  Then the response code should be 400

