package workflows

import "encoding/json"

SlackBlockRelease: {
	"blocks": [
		{
			"type": "section"
			"text": {
				"type": "mrkdwn"
				"text": "A new version of `whaturl` has been released: `yo` :tada:"
			}
			"accessory": {
				"type": "button"
				"text": {
					"type": "plain_text"
					"text": "See details"
				}
				"url": "https://github.com/staticaland/go-whaturl/releases"
			}
		},
	]
}

goreleaser: {

	name: "GoReleaser"

	on: push: tags: [
		"*",
	]

	permissions: contents: "write"

	jobs: {

		goreleaser: {
			"runs-on": "ubuntu-latest"
			steps: [{
				name: "Checkout"
				uses: "actions/checkout@v2"
				with: "fetch-depth": 0
			}, {
				name: "Fetch all tags"
				run:  "git fetch --force --tags"
			}, {
				name: "Set up Go"
				uses: "actions/setup-go@v2"
				with: "go-version": 1.18
			}, {
				name: "Run GoReleaser"
				uses: "goreleaser/goreleaser-action@v3"
				with: {
					distribution: "goreleaser"
					version:      "latest"
					args:         "release --rm-dist"
				}
				env: GITHUB_TOKEN: "${{ secrets.GITHUB_TOKEN }}"
			}]
		}

		notify: {
			name:      "Perform Slack notification"
			"runs-on": "ubuntu-latest"
			steps: [
				#SlackAction & {
					with: {
						payload: json.Marshal(SlackBlockRelease)
					}
				},
			]
		}

	}
}
