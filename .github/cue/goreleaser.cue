package whaturl

_slackBlockRelease: blocks: [
	{
		type: "section"
		text: {
			type: "mrkdwn"
			text: "A new version of `whaturl` has been released: `yo` :tada:"
		}
		accessory: {
			type: "button"
			text: {
				type: "plain_text"
				text: "See details"
			}
			url: "https://github.com/staticaland/go-whaturl/releases"
		}
	},
]

goreleaser: _#workflow & {

	name: "GoReleaser"

	on: push: tags: [
		"*",
	]

	permissions: contents: "write"

	jobs: {

		goreleaser: _#job & {
			name: "Create a release"

			steps: [
				_#stepCheckout & {
					with: "fetch-depth": 0
				},
				_#step & {
					name: "Fetch all tags"
					run:  "git fetch --force --tags"
				},
				_#stepSetupGo,
				_#stepDockerLogin,
				_#step & {
					name: "Run GoReleaser"
					uses: "goreleaser/goreleaser-action@68acf3b1adf004ac9c2f0a4259e85c5f66e99bef"
					with: {
						distribution: "goreleaser"
						version:      "latest"
						args:         "release --rm-dist"
					}
					env: {
						SLACK_WEBHOOK: "${{ secrets.SLACK_WEBHOOK_URL }}"
						GITHUB_TOKEN:  "${{ secrets.GITHUB_TOKEN }}"
					}
				}]
		}

		notify: _#job & {
			name: "Perform Slack notification"

			steps: [
				_#stepSlack & {
					with: "slack-message": "A new version of `whaturl` has been released :tada:"
				},
			]
		}

	}
}
