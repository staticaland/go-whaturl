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

		defaults: run: "working-directory": common.cue_dir

		steps: [
			common.#stepCheckout,
			common.#stepSetupCue,
			common.#step & {
				name: "Install Tabulate"
				run:  "pipx install tabulate"
			},
			common.#step & {
				name: "Print table"
				run:  #"cue cmd ls-steps | tabulate --header --format github --sep ';;;' -"#
			}]
	}

}
