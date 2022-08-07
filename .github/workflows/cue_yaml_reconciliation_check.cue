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

		steps: [
			_#checkout,
			{
				name: "Setup CUE environment"
				uses: "cue-lang/setup-cue@v1.0.0-alpha.2"
				with: version: "latest"
			},
			{
				name:                "Regenerate YAML from CUE"
				"working-directory": ".github/workflows"
				run:                 "rm *.yml && cue cmd genworkflows && cue cmd toolversions"
			},
			{
				name: "Check commit is clean"
				run:  "test -z \"$(git status --porcelain)\" || (git status; git diff; false)"
			}]
	}

}
