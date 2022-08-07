package workflows

_go_version: "1.18.5"

_#step: {
	uses?: =~"^[^@]+@[a-f0-9]{40}" // Must pin with SHA1
	...
}

_#setupGo: _#step & {
	name: "Set up Go"
	uses: "actions/setup-go@84cbf8094393cdc5fe1fe1671ff2647332956b1a" // v3.2.1
	with: "go-version": _go_version
	...
}

_#checkout: _#step & {
	name: "Checkout"
	uses: "actions/checkout@2541b1294d2704b0964813337f33b291d3f8596b" // v3.0.2
	...
}


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
			_#checkout,
			_#setupGo,
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
