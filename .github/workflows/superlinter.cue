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
			#Checkout & {
				with: "fetch-depth": 0
			},
			{
				name: "Lint Code Base"
				uses: "github/super-linter/slim@v4"
				env: {
					VALIDATE_ALL_CODEBASE: "${{ github.event_name == 'workflow_dispatch' }}"
					DEFAULT_BRANCH:        "main"
					GITHUB_TOKEN:          "${{ secrets.GITHUB_TOKEN }}"
				}
			}]
	}

}
