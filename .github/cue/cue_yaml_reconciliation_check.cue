package workflows

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
			_#step & {
				name: "Setup CUE environment"
				uses: "cue-lang/setup-cue@143c2fe537047bf8c7ead6a30784ad1802e9d991"
				with: version: "latest"
			},
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
			_#step & {
				name: "Check commit is clean"
				run:  "test -z \"$(git status --porcelain)\" || (git status; git diff; false)"
			}]
	}

}
