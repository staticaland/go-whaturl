package main

import (
	"context"
	"net/http"
	"strings"
	"testing"
	"time"
)

func TestGetTitle(t *testing.T) {
	client := &http.Client{
		Timeout: 5 * time.Second,
	}
	ctx := context.Background()

	testCases := []struct {
		name     string
		url      string
		expected string
	}{
		{"Valid URL", "https://example.com", "Example Domain"},
		{"Invalid URL", "https://example.invalid", ""},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			title, err := getTitle(ctx, client, tc.url)
			if err != nil && tc.expected != "" {
				t.Fatalf("Expected %q but got an error: %v", tc.expected, err)
			}

			if title != tc.expected {
				t.Errorf("Expected title %q but got %q", tc.expected, title)
			}
		})
	}
}

func TestCreateLink(t *testing.T) {
	testCases := []struct {
		name      string
		url       string
		title     string
		dialect   string
		expected  string
		expectErr bool
	}{
		{
			"Markdown",
			"https://example.com",
			"Example Domain",
			"markdown",
			"[Example Domain](https://example.com)",
			false,
		},
		{
			"Org",
			"https://example.com",
			"Example Domain",
			"org",
			"[[https://example.com][Example Domain]]",
			false,
		},
		{
			"HTML",
			"https://example.com",
			"Example Domain",
			"html",
			`<a href="https://example.com">Example Domain</a>`,
			false,
		},
		{
			"Unsupported Dialect",
			"https://example.com",
			"Example Domain",
			"unsupported",
			"",
			true,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			link, err := createLink(tc.url, tc.title, tc.dialect)

			if tc.expectErr && err == nil {
				t.Fatal("Expected an error but didn't get one")
			}

			if !tc.expectErr && err != nil {
				t.Fatalf("Didn't expect an error but got one: %v", err)
			}

			if link != tc.expected {
				t.Errorf("Expected link %q but got %q", tc.expected, link)
			}
		})
	}
}

func TestProcessUrlsConcurrently(t *testing.T) {
	urls := []string{
		"https://example.com",
		"https://example.org",
	}
	linkFormat := "markdown"

	linksCh := processUrlsConcurrently(urls, linkFormat)

	var result []string
	for link := range linksCh {
		result = append(result, link)
	}

	if len(result) != len(urls) {
		t.Errorf("Expected %d links but got %d", len(urls), len(result))
	}

	for _, link := range result {
		if !strings.HasPrefix(link, "[") || !strings.HasSuffix(link, ")") {
			t.Errorf("Link %q does not have the expected markdown format", link)
		}
	}
}
