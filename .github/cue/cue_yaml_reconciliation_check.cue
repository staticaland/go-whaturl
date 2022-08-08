package whaturl

cue_yaml_reconciliation_check: _#workflow & {

	name: "CUE and YAML reconciliation check"

	on: [
		"push",
		"pull_request",
	]

	jobs: cue_reconciliation: {
		name:      "Verify CUE matches YAML configuration"
		"runs-on": "ubuntu-latest"

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
					cue cmd gen
					"""
			},
			_#stepGitDiffCheck,
		]
	}

}
