package workflows

cue_yaml_reconciliation_check: {

	on: [
		"push",
		"pull_request",
	]

	name: "CUE and YAML reconciliation check"

	jobs: cue_reconciliation: {
		name:      "Verify CUE matches YAML configuration"
		"runs-on": "ubuntu-latest"

		steps: [{
			name: "Checkout code"
			uses: "actions/checkout@v3"
		}, {
			name: "Setup CUE environment"
			uses: "cue-lang/setup-cue@v1.0.0-alpha.2"
			with: version: "latest"
		}, {
			name:                "Regenerate YAML from CUE"
			"working-directory": ".github/workflows"
			run: """
				cue cmd genworkflows

				"""
		}, {
			name: "Check commit is clean"
			run:  "test -z \"$(git status --porcelain)\" || (git status; git diff; false)"
		}]
	}

}
