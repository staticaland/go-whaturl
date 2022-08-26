package workflows

import "github.com/staticaland/go-whaturl/cue/common"

cue_formatting_check: common.#workflow & {

	name: "CUE formatting check"

	on: {
		push: {}
		workflow_dispatch: {}
	}

	permissions: contents: "read"

	jobs: cue_fmt_check: common.#job & {

		name: "CUE formatting check"

		steps: [
			common.#stepCheckout,
			common.#stepSetupCue,
			common.#step & {
				name:                "Check formatting"
				"working-directory": "cue"
				run:                 "cue fmt -s"
			},
			common.#stepGitDiffCheck,
		]
	}

}
