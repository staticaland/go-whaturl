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
				uses: "goreleaser/goreleaser-action@ff11ca24a9b39f2d36796d1fbd7a4e39c182630a"
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
