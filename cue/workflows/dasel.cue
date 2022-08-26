package workflows

import "github.com/staticaland/go-whaturl/cue/common"

dasel: common.#workflow & {

	name: "Dasel"

	on: workflow_dispatch: null

	permissions: contents: "read"

	jobs: dasel: common.#job & {

		name: "Do some dasel things"

		steps: [
			common.#stepCheckout,
			common.#step & {
				name: "Install dasel with Homebrew"
				run:  "brew install dasel"
			},
			common.#step & {
				name: "Run dasel"
				run:  #"echo '{"name": "Tom"}' | dasel -r json '.name'"#
			},
		]
	}

}
