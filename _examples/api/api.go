// Example - demonstrates REST API server implementation tests.
package main

import (
	"encoding/json"
	"net/http"
	"runtime"
	"time"
)

func getVersion(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		fail(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	data := struct {
		Version string `json:"version"`
	}{Version: runtime.Version()}

	ok(w, data)
}

func getTimeStampInRequiredFormat(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		fail(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Extract time and format from query parameters
	timeParam := r.URL.Query().Get("time")
	formatParam := r.URL.Query().Get("format")

	var t time.Time
	var format string
	var err error

	// If time parameter is provided, parse it
	if timeParam != "" {
		t, err = time.Parse(time.RFC3339, timeParam)
		if err != nil {
			fail(w, "Invalid time format", http.StatusBadRequest)
			return
		}
	} else {
		t = time.Now()
	}

	// If format parameter is not provided, use RFC3339
	if formatParam == "" {
		format = time.RFC3339
	} else {
		format = formatParam
	}

	data := struct {
		TimeStamp string `json:"timestamp"`
	}{TimeStamp: t.Format(format)}

	ok(w, data)
}

// fail writes a json response with error msg and status header
func fail(w http.ResponseWriter, msg string, status int) {
	w.WriteHeader(status)

	data := struct {
		Error string `json:"error"`
	}{Error: msg}
	resp, _ := json.Marshal(data)

	w.Header().Set("Content-Type", "application/json")
	w.Write(resp)
}

// ok writes data to response with 200 status
func ok(w http.ResponseWriter, data interface{}) {
	resp, err := json.Marshal(data)
	if err != nil {
		fail(w, "Oops something evil has happened", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(resp)
}

func main() {
	http.HandleFunc("/version", getVersion)
	http.HandleFunc("/timestamp", getTimeStampInRequiredFormat)
	http.ListenAndServe(":8080", nil)
}
