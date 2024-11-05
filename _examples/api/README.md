# An example of API feature

The following example demonstrates steps how we describe and test our API using **godog**.

### Requirements
This is a simple server which provide two APIs
#### Requirement for the endpoint /version
1. it is a get request
2. it shall provide the current go version in json format in the response
3. it shall provide error messages if other request type was used for calling this endpoint

#### Requirement for the endpoint /timestamp
1. it is a get request with two query parameter `time` nd `format`
2. the `time` parameter only accept the input in time.RFC3339 e.g. `2023-12-01T10:02:01Z`
3. the `format` parameter is for the needed output time format, it can be any predefined DateOnly format. Format in go (https://pkg.go.dev/time). if the wrong `format` parameter is given, there should be an error message 
4. The given time will be transferred according to the given format layout
    * If `time=2023-12-01T10:02:01Z&format=2006-01-02` is given then the time stamp shown in the response should be `"timestamp": "2023-12-01" ` in json fomat.
	* If `time=2023-12-01T10:02:01Z&format=02/01/2006` then the time stamp shown in the response should be `"timestamp": "01/12/2023"` in json fomat.
5. the `format` can be empty, then the original time format should be displayed in the response.
6. it shall provide error messages if other request type was used for calling this endpoint

### Steps
1. run existing tests
2. the Nr.3 requirement for timestamp endpoint is missing for the moment in the API implementation.

```
var validLayouts = []string{
	"2006-01-02",  // ISO 8601 date format
	"02-Jan-2006", // Common date format
	"Jan 2, 2006", // Another common date format
	"02/01/2006",  // European date format
	"01/02/2006",  // US date format
}

// getLayoutName returns the layout name by given a valid time string in dateonly format
func getLayoutName(timeStr string) (string, error) {
	for _, layout := range validLayouts {
		if _, err := time.Parse(layout, timeStr); err == nil {
			return layout, nil
		}
	}
	return "", fmt.Errorf("no matching layout found for time string: %s", timeStr)
}
```
please put use above given code block to check the format parameter
3. extend the current timestamp.feature file to add at least two scenarios according to the requirements above
4. add the needed step definition in InitializeScenario func
5. run again all tests