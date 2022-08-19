package whaturl

table: _#workflow & {

	name: "Print Markdown table"

	on: {
		push: {
			branches: _branches_default
			paths:    _paths_cue
		}
		pull_request: branches: _branches_default
		workflow_dispatch: null
	}

	permissions: contents: "read"

	jobs: build: _#job & {

		name: "Print Markdown table"

		steps: [
			_#stepCheckout,
			_#stepSetupCue,
			_#step & {
				name:                "Install Tabulate"
				"working-directory": ".github/cue"

				run: "pipx install tabulate"
			},
			_#step & {
				name:                "Print table"
				"working-directory": ".github/cue"

				run: #"cue cmd ls-steps | tabulate --format github --sep ';;;' -"#
			}]
	}

}
