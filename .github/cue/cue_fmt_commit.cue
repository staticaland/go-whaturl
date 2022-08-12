package whaturl

cue_formatting_commit: _#workflow & {

	name: "CUE formatting check and commit"

	on: push: pull_request: paths: _paths_cue

	jobs: cue_fmt_check: _#job & {
		name: "CUE formatting check and commit"

		steps: [
			_#stepCheckout,
			_#stepSetupCue,
			_#step & {
				name:                "Check formatting"
				"working-directory": ".github/cue"
				run:                 "cue fmt -s"
			},
			_#stepGitDiffModified,
			_#stepPushChanges,
		]
	}

}
