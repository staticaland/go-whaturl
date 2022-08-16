package whaturl

cue_yaml_reconciliation_check: _#workflow & {

	name: "CUE and YAML reconciliation check"

	on: {
		push: branches: _branches_default
		pull_request: {}
		workflow_dispatch: null
	}

	jobs: cue_reconciliation: _#job & {
		name: "Verify CUE matches YAML configuration"

		steps: [
			_#stepCheckout,
			_#stepSetupCue,
			_#step & {
				name:                "Regenerate YAML from CUE"
				"working-directory": ".github/cue"
				run: """
					rm ../workflows/*.yml
					rm ../dependabot.yml
					rm ../../.goreleaser.yaml
					rm ../../.tool-versions
					rm ../../docs/config.yml
					cue cmd gen
					"""
			},
			_#stepGitDiffCheck,
		]
	}

}
