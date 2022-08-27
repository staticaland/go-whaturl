package workflows

import "github.com/staticaland/go-whaturl/cue/common"

dependency_review: common.#workflow & {

	name: "Dependency review"

	on: pull_request: {}

	permissions: contents: "read"

	jobs: dependency_review: common.#job & {

		name: "Perform dependency review"

		steps: [
			common.#stepCheckout,
			{
				name: "Dependency review"
				uses: "actions/dependency-review-action@23d1ffffb6fa5401173051ec21eba8c35242733f"
			}]
	}

}
