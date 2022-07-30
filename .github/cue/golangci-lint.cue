name: "golangci-lint"

on: {
	push: {
		tags: [
			"v*",
		]
		branches: [
			"master",
			"main",
		]
	}
	pull_request: null
}

permissions: contents: "read"

jobs: golangci: {
	name:      "lint"
	"runs-on": "ubuntu-latest"
	steps: [{
		uses: "actions/checkout@v3"
	}, {
		uses: "actions/setup-go@v3"
		with: "go-version": "1.18.4"
	}, {
		name: "golangci-lint"
		uses: "golangci/golangci-lint-action@v3"
		with: version: "latest"
	}]
}
