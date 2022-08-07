package workflows

go: {
	name: "Tests"

	on: push: {
		branches: "main"
		paths: [
			"**.go",
			"go.mod",
			"go.sum",
		]
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
