package workflows

import "github.com/staticaland/go-whaturl/cue/common"

// https://docs.github.com/en/free-pro-team@latest/github/finding-security-vulnerabilities-and-errors-in-your-code/configuring-code-scanning
codeql: common.#workflow & {

	name: "CodeQL"

	on: {
		push: {
			branches: common.branches_default
			paths:    common.paths_go
		}
		pull_request: branches: common.branches_default
		workflow_dispatch: null
	}

	permissions: contents: "read"

	jobs: analyze: common.#job & {

		name: "Analyze"

		permissions: {
			actions:           "read" // for github/codeql-action/init to get workflow details
			contents:          "read" // for actions/checkout to fetch code
			"security-events": "write"
		} // for github/codeql-action/autobuild to send a status report

		strategy: {
			"fail-fast": false
			matrix: language: ["go"]
		}

		steps: [
			common.#stepCheckout,
			common.#step & {
				// Initializes the CodeQL tools for scanning.
				name: "Initialize CodeQL"
				uses: "github/codeql-action/init@b398f525a5587552e573b247ac661067fafa920b"
				with: languages: "${{ matrix.language }}"
			},
			common.#step & {
				name: "Autobuild"
				uses: "github/codeql-action/autobuild@b398f525a5587552e573b247ac661067fafa920b"
			},
			common.#step & {
				name: "Perform CodeQL Analysis"
				uses: "github/codeql-action/analyze@b398f525a5587552e573b247ac661067fafa920b"
			}]
	}

}
