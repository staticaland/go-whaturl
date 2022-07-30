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
	steps: [{
		uses: "actions/checkout@v2"
	}, {
		name: "Set up Go"
		uses: "actions/setup-go@v3"
		with: "go-version": "1.18.4"
	}, {
		name: "Build"
		run:  "go build"
	}, {
		name: "Test"
		run:  "go test -v"
	}]
}
