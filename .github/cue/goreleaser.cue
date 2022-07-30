name: "GoReleaser"

on: push: tags: [
	"*",
]

permissions: contents: "write"
// packages: write
// issues: write

jobs: {
	goreleaser: {
		"runs-on": "ubuntu-latest"
		steps: [{
			name: "Checkout"
			uses: "actions/checkout@v2"
			with: "fetch-depth": 0
		}, {
			name: "Fetch all tags"
			run:  "git fetch --force --tags"
		}, {
			name: "Set up Go"
			uses: "actions/setup-go@v2"
			with: "go-version": 1.18
		}, {
			name: "Run GoReleaser"
			uses: "goreleaser/goreleaser-action@v2"
			with: {
				distribution: "goreleaser"
				version:      "latest"
				args:         "release --rm-dist"
			}
			env: GITHUB_TOKEN: "${{ secrets.GITHUB_TOKEN }}"
		}]
	}
}
