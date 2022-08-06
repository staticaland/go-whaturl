package workflows

_go_version: "1.18.5"

#SetupGo: {
	name: "Set up Go"
	uses: "actions/setup-go@v3"
	with: "go-version": _go_version
	...
}

#Checkout: {
	name: "Checkout"
	uses: "actions/checkout@v3"
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
			#Checkout,
			#SetupGo,
			{
				name: "Build"
				run:  "go build"
			}, {
				name: "Test"
				run:  "go test -v"
			}]
	}

}
