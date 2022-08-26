package workflows

import "github.com/staticaland/go-whaturl/cue/common"

vale: common.#workflow & {

	name: "Vale"

	on: pull_request: paths: [
		"**.org",
		"**.md",
		".github/styles/**",
		".vale.ini",
	]
	on: push: paths: on.pull_request.paths

	jobs: vale: common.#job & {
		name: "Vale"
		steps: [
			common.#stepCheckout,
			common.#step & {
				name: "Run Vale"
				uses: "errata-ai/vale-action@c4213d4de3d5f718b8497bd86161531c78992084"
				env: GITHUB_TOKEN: "${{secrets.GITHUB_TOKEN}}"
				with: {
					fail_on_error: true
					reporter:      "github-check"
				}
			},
		]

	}

}
