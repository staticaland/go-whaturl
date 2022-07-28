package main

import "testing"

func TestGetTitle(t *testing.T) {
	got := GetTitle("https://aftenposten.no")
	want := "Forsiden - Aftenposten"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}

func TestCreateMarkdownLink(t *testing.T) {
	got := CreateLink("https://aftenposten.no", "Forsiden - Aftenposten", "markdown")
	want := "[Forsiden - Aftenposten](https://aftenposten.no)"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}

func TestCreateOrgLink(t *testing.T) {
	got := CreateLink("https://aftenposten.no", "Forsiden - Aftenposten", "org")
	want := "[[https://aftenposten.no][Forsiden - Aftenposten]]"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}

func TestToLink(t *testing.T) {
	got := ToLink("https://aftenposten.no", "markdown")
	want := "[Forsiden - Aftenposten](https://aftenposten.no)"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
