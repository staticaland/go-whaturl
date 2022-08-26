package workflows

import "github.com/staticaland/go-whaturl/cue/common"

cue_yaml_reconciliation_check: common.#workflow & {

	name: "CUE and YAML reconciliation check"

	on: {
		push: branches: common.branches_default
		pull_request: {}
		workflow_dispatch: null
	}

	jobs: cue_reconciliation: common.#job & {
		name: "Verify CUE matches YAML configuration"

		steps: [
			common.#stepCheckout,
			common.#stepSetupCue,
			common.#step & {
				name:                "Regenerate YAML from CUE"
				"working-directory": "cue"
				run: """
					rm ../.github/workflows/*.yml
					rm ../dependabot.yml
					rm ../.goreleaser.yaml
					rm ../.tool-versions
					rm ../docs/config.yml
					cue cmd gen
					"""
			},
			common.#stepGitDiffCheck,
		]
	}

}
