package whaturl

cue_formatting_check: _#workflow & {

	name: "CUE formatting check"

	on: [
		"push",
		"pull_request",
	]

	jobs: cue_fmt_check: _#job & {
		name:      "CUE formatting check"
		"runs-on": "ubuntu-latest"

		steps: [
			_#stepCheckout,
			_#stepSetupCue,
			_#step & {
				name:                "Check formatting"
				"working-directory": ".github/cue"
				run:                 "cue fmt -s"
			},
			_#stepGitDiffCheck,
		]
	}

}
