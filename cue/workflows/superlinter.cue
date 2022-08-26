package workflows

import "github.com/staticaland/go-whaturl/cue/common"

superlinter: common.#workflow & {

	name: "Super-Linter"

	on: {
		pull_request: {}
		workflow_dispatch: {}
	}

	jobs: build: common.#job & {

		name: "Lint Code Base"

		steps: [
			common.#stepCheckout & {
				with: "fetch-depth": 0
			},
			common.#step & {
				name: "Lint Code Base"
				uses: "github/super-linter/slim@01d3218744765b55c3b5ffbb27e50961e50c33c5"
				env: {
					VALIDATE_ALL_CODEBASE: "${{ github.event_name == 'workflow_dispatch' }}"
					DEFAULT_BRANCH:        "main"
					GITHUB_TOKEN:          "${{ secrets.GITHUB_TOKEN }}"
				}
			}]
	}

}
