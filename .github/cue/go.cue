package whaturl

go: _#workflow & {

	name: "Tests"

	on: push: {
		branches: _branches_default
		paths:    _paths_go
	}

	jobs: build: {
		"runs-on": "ubuntu-latest"
		steps: [
			_#stepCheckout,
			_#stepSetupGo,
			_#step & {
				name: "Build"
				run:  "go build"
			},
			_#step & {
				name: "Test"
				run:  "go test -v"
			}]
	}

}
