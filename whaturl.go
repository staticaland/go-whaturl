package main

import (
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

func GetTitle(url string) string {

	client := &http.Client{}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatalln(err)
	}

	req.Header.Set("User-Agent", "Golang_Whaturl/1.0")

	resp, err := client.Do(req)
	if err != nil {
		log.Fatalln(err)
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return "Error fetching link"
	}

	doc, err := goquery.NewDocumentFromReader(resp.Body)

	if err != nil {
		log.Fatal(err)
	}

	title := doc.Find("title").Text()

	return title

}

func CreateLink(url, title, dialect string) string {

	switch dialect {
	case "markdown":
		return fmt.Sprintf("[%s](%s)", title, url)
	case "org":
		return fmt.Sprintf("[[%s][%s]]", url, title)
	case "html":
		return fmt.Sprintf(`<a href="%s">%s</a>`, url, title)
	}

	return url

}

func main() {

	re := regexp.MustCompile(`(?i)(?:\[(?P<title>[^\]]*)\]\(|\b)(?P<url>(?:(?:https?)://|(?:www)\.)[-A-Z0-9+&@/%?=~_|$!:,.;]*[A-Z0-9+&@#/%=~_|$])\)?`)

	s := "Hello https://vg.no and https://reddit.com"

	matches := re.FindAllString(s, -1)

	for _, url := range matches {
		title := GetTitle(url)
		fmt.Println(strings.Replace(s, url, CreateLink(url, title, "markdown"), -1))
	}

}
