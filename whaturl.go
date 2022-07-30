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

	gq "github.com/PuerkitoBio/goquery"
	pu "github.com/PuerkitoBio/purell"
	"github.com/google/uuid"
)

type link struct {
	url string
	id  string
}

func GetTitle(url string) string {

	client := &http.Client{}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatalln(err)
	}

	req.Header.Set("User-Agent", "")

	resp, err := client.Do(req)
	if err != nil {
		log.Fatalln(err)
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return url
	}

	doc, err := gq.NewDocumentFromReader(resp.Body)

	if err != nil {
		log.Fatal(err)
	}

	title := doc.Find("title").First().Text()

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

	linkFormat := flag.String("format", "markdown", "Specify link format")
	normalizeURL := flag.Bool("normalize", true, "Normalize URLs")
	flag.Parse()

	urlRe := regexp.MustCompile(`(?i)\b(?:[a-z][\w.+-]+:(?:/{1,3}|[?+]?[a-z0-9%]))(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s\x60!()\[\]{};:'".,<>?«»“”‘’])`)

	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {

		line := scanner.Text()

		matches := urlRe.FindAllString(line, -1)

		matchesEnriched := make([]link, 0, len(matches))

		for _, url := range matches {

			id := uuid.New().String()

			l := link{url: url, id: id}

			matchesEnriched = append(matchesEnriched, l)

		}

		for _, link := range matchesEnriched {
			title := GetTitle(link.url)

			url := link.url

			if *normalizeURL {
				url, _ = pu.NormalizeURLString(
					link.url,
					pu.FlagsUsuallySafeGreedy|pu.FlagRemoveDuplicateSlashes|pu.FlagRemoveFragment,
				)
			}

			line = strings.ReplaceAll(line, link.url, CreateLink(url, title, *linkFormat))
		}

		fmt.Println(line)
	}

}
