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
				uses: "github/super-linter/slim@2d64ac1c067c34beaf7d24cc12733cd46236f76e"
				env: {
					VALIDATE_ALL_CODEBASE: "${{ github.event_name == 'workflow_dispatch' }}"
					DEFAULT_BRANCH:        "main"
					GITHUB_TOKEN:          "${{ secrets.GITHUB_TOKEN }}"
				}
			}]
	}

}
