package workflows

import "github.com/staticaland/go-whaturl/cue/common"

go: common.#workflow & {

	name: "Tests"

	on: push: {
		branches: common.branches_default
		paths:    common.paths_go
	}

	permissions: contents: "read"

	jobs: build: common.#job & {

		name: "Build and test the Go code"

		steps: [
			common.#stepCheckout,
			common.#stepSetupGo,
			common.#step & {
				name: "Build"
				run:  "go build"
			},
			common.#step & {
				name: "Test"
				run:  "go test -v"
			}]
	}

}
