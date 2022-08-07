package workflows

superlinter: {

	name: "Super-Linter"

	on: {
		pull_request:      null
		workflow_dispatch: null
	}

	jobs: build: {
		name:      "Lint Code Base"
		"runs-on": "ubuntu-latest"

		steps: [
			_#stepCheckout & {
				with: "fetch-depth": 0
			},
			_#step & {
				name: "Lint Code Base"
				uses: "github/super-linter/slim@01d3218744765b55c3b5ffbb27e50961e50c33c5"
				env: {
					VALIDATE_ALL_CODEBASE: "${{ github.event_name == 'workflow_dispatch' }}"
					DEFAULT_BRANCH:        "main"
					GITHUB_TOKEN:          "${{ secrets.GITHUB_TOKEN }}"
				}
			}]
	}

}
