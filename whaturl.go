package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	gq "github.com/PuerkitoBio/goquery"
	"mvdan.cc/xurls/v2"
)

func getTitle(url string) string {

	if !strings.HasPrefix(url, "http://") && !strings.HasPrefix(url, "https://") {
			url = "https://" + url
	}

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

func createLink(url, title, dialect string) string {

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
	shouldCreateLinkList := flag.Bool("list", false, "Create list of links")
	relaxed := flag.Bool("relaxed", false, "Process URLs without a schema")
	flag.Parse()

	urlReFunc := xurls.Strict

	if *relaxed {
		urlReFunc = xurls.Relaxed
	}

	urlRe := urlReFunc()

	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {

		line := scanner.Text()

		if *shouldCreateLinkList {

			urls := urlRe.FindAllString(line, -1)

			for _, url := range urls {
				fmt.Println(" - " + createLink(url, getTitle(url), *linkFormat))
			}

		} else {

			line = urlRe.ReplaceAllStringFunc(line, func(s string) string {
				return createLink(s, getTitle(s), *linkFormat)
			})

			fmt.Println(line)

		}

	}

}
