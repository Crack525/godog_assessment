Feature: get timestamp
    Scenario: should get given time in RFC3339 format if no other time format is provided
        When I send "GET" request to "/timestamp" with time "2022-01-01T00:00:00Z" and format ""
        Then the response code should be 200
        And the response should match json:
            """
            {
                "timestamp": "2022-01-01T00:00:00Z"
            }
            """