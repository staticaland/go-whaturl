package workflows

// https://docs.github.com/en/free-pro-team@latest/github/finding-security-vulnerabilities-and-errors-in-your-code/configuring-code-scanning
codeql: _#workflow & {

	name: "CodeQL"

	on: {
		push: {
			branches: _branches_default
			paths: _paths_go
		}
		pull_request: branches: _branches_default
		workflow_dispatch: null
	}

	permissions: contents: "read"

	jobs: analyze: {
		permissions: {
			actions:           "read" // for github/codeql-action/init to get workflow details
			contents:          "read" // for actions/checkout to fetch code
			"security-events": "write"
		} // for github/codeql-action/autobuild to send a status report
		name:      "Analyze"
		"runs-on": "ubuntu-latest"

		strategy: {
			"fail-fast": false
			matrix: language: ["go"]
		}

		steps: [
			_#stepCheckout,
			_#step & {
				// Initializes the CodeQL tools for scanning.
				name: "Initialize CodeQL"
				uses: "github/codeql-action/init@2ca79b6fa8d3ec278944088b4aa5f46912db5d63"
				with: languages: "${{ matrix.language }}"
			},
			_#step & {
				name: "Autobuild"
				uses: "github/codeql-action/autobuild@2ca79b6fa8d3ec278944088b4aa5f46912db5d63"
			},
			_#step & {
				name: "Perform CodeQL Analysis"
				uses: "github/codeql-action/analyze@2ca79b6fa8d3ec278944088b4aa5f46912db5d63"
			}]
	}

}
