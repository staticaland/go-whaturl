package main

import (
	"fmt"
	"testing"
)

func TestGetTitle(t *testing.T) {
	got := getTitle("https://aftenposten.no")
	want := "Forsiden - Aftenposten"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}

func TestAllLinks(t *testing.T) {

	const u = "https://aftenposten.no"
	const ut = "Forsiden - Aftenposten"

	var tests = []struct {
		url string
		title string
		dialect  string
		want string
	}{
		{u, ut, "markdown", fmt.Sprintf("[%s](%s)", ut, u)},
		{u, ut, "org", fmt.Sprintf("[[%s][%s]]", u, ut)},
		{u, ut, "html", fmt.Sprintf(`<a href="%s">%s</a>`, u, ut)},
	}

	for _, test := range tests {
		if got := createLink(test.url, test.title, test.dialect); got != test.want {
			t.Errorf("createLink(%q, %q, %q) = %v but got %v", test.url, test.title, test.dialect, got, test.want)
		}
	}

}
