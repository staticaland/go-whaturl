package workflows

import "github.com/staticaland/go-whaturl/cue/common"

table: common.#workflow & {

	name: "Print Markdown table"

	on: {
		push: {
			branches: common.branches_default
			paths:    common.paths_cue
		}
		pull_request: branches: common.branches_default
		workflow_dispatch: null
	}

	permissions: contents: "read"

	jobs: build: common.#job & {

		name: "Print Markdown table"

		steps: [
			common.#stepCheckout,
			common.#stepSetupCue,
			common.#step & {
				name:                "Install Tabulate"
				"working-directory": ".github/cue"

				run: "pipx install tabulate"
			},
			common.#step & {
				name:                "Print table"
				"working-directory": ".github/cue"

				run: #"cue cmd ls-steps | tabulate --header --format github --sep ';;;' -"#
			}]
	}

}
