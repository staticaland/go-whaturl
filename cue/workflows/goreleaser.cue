package workflows

import "github.com/staticaland/go-whaturl/cue/common"

goreleaser: common.#workflow & {

	name: "GoReleaser"

	on: push: tags: [
		"*",
	]

	permissions: contents: "write"

	jobs: goreleaser: common.#job & {

		name: "Create a release"

		steps: [
			common.#stepCheckout & {
				with: "fetch-depth": 0
			},
			common.#step & {
				name: "Fetch all tags"
				run:  "git fetch --force --tags"
			},
			common.#stepSetupGo,
			common.#stepDockerLogin,
			common.#step & {
				name: "Run GoReleaser"
				uses: "goreleaser/goreleaser-action@68acf3b1adf004ac9c2f0a4259e85c5f66e99bef"
				with: {
					distribution: "goreleaser"
					version:      "v" + common.goreleaser_version
					args:         "release --rm-dist"
				}
				env: {
					SLACK_WEBHOOK: "${{ secrets.SLACK_WEBHOOK_URL }}"
					GITHUB_TOKEN:  "${{ secrets.GITHUB_TOKEN }}"
				}
			}]
	}
}
