package main

import "testing"

func TestToLink(t *testing.T) {
	got := ToLink("https://aftenposten.no", "markdown")
	want := "[Forsiden - Aftenposten](https://aftenposten.no)"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
