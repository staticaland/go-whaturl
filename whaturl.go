package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"

	"github.com/PuerkitoBio/goquery"
	"github.com/google/uuid"
)

type link struct {
	url   string
	id    string
	title string
}

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

	var linkFormat string
	flag.StringVar(&linkFormat, "format", "markdown", "Specify link format")
	flag.Parse()
	fmt.Println(linkFormat)

	re := regexp.MustCompile(`(?i)(?:\[(?P<title>[^\]]*)\]\(|\b)(?P<url>(?:(?:https?)://|(?:www)\.)[-A-Z0-9+&@/%?=~_|$!:,.;]*[A-Z0-9+&@#/%=~_|$])\)?`)

	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {

		s := scanner.Text()

		matches := re.FindAllString(s, -1)

		matchesEnriched := make([]link, 0, len(matches))

		for _, url := range matches {

			id := uuid.New()

			l := link{url: url, id: id.String()}

			matchesEnriched = append(matchesEnriched, l)

		}

		for _, link := range matchesEnriched {
			title := GetTitle(link.url)
			s = strings.Replace(s, link.url, CreateLink(link.url, title, linkFormat), -1)
		}

		fmt.Println(s)
	}

}
