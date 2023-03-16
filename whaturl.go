package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"

	gq "github.com/PuerkitoBio/goquery"
	"mvdan.cc/xurls/v2"
)

func getTitle(ctx context.Context, client *http.Client, url string) (string, error) {
	if !strings.HasPrefix(url, "http://") && !strings.HasPrefix(url, "https://") {
		url = "https://" + url
	}

	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return "", err
	}

	req.Header.Set("User-Agent", "")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return url, nil
	}

	doc, err := gq.NewDocumentFromReader(resp.Body)
	if err != nil {
		return "", err
	}

	title := doc.Find("title").First().Text()
	return title, nil
}

func createLink(url, title, dialect string) (string, error) {
	switch dialect {
	case "markdown":
		return fmt.Sprintf("[%s](%s)", title, url), nil
	case "org":
		return fmt.Sprintf("[[%s][%s]]", url, title), nil
	case "html":
		return fmt.Sprintf(`<a href="%s">%s</a>`, url, title), nil
	default:
		return "", fmt.Errorf("unsupported dialect: %s", dialect)
	}
}

func processUrlsConcurrently(urls []string, linkFormat string) <-chan string {
	var wg sync.WaitGroup
	wg.Add(len(urls))

	outputCh := make(chan string, len(urls))

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	for _, url := range urls {
		go func(url string) {
			ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)

			defer cancel()
			defer wg.Done()

			title, err := getTitle(ctx, client, url)
			if err != nil {
				log.Printf("Error getting title for %s: %v", url, err)
				outputCh <- url
				return
			}
			formattedLink, err := createLink(url, title, linkFormat)
			if err != nil {
				log.Printf("Error creating link for %s: %v", url, err)
				outputCh <- url
			} else {
				outputCh <- formattedLink
			}
		}(url)
	}

	wg.Wait()
	close(outputCh)

	return outputCh
}

func printLinks(linksCh <-chan string, prefix string) {
	for link := range linksCh {
		fmt.Println(prefix + link)
	}
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

		urls := urlRe.FindAllString(line, -1)
		linksCh := processUrlsConcurrently(urls, *linkFormat)

		if *shouldCreateLinkList {
			printLinks(linksCh, " - ")
		} else {
			resultMap := make(map[string]string)

			for link := range linksCh {
				for _, url := range urls {
					if strings.Contains(link, url) {
						resultMap[url] = link
						break
					}
				}
			}

			line = urlRe.ReplaceAllStringFunc(line, func(s string) string {
				return resultMap[s]
			})

			fmt.Println(line)
		}
	}
}
