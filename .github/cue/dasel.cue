package whaturl

dasel: _#workflow & {

	name: "Dasel"

	on: workflow_dispatch: null

	permissions: contents: "read"

	jobs: build: _#job & {

		name: "Install dasel"

		steps: [
			_#stepCheckout,
			_#step & {
				name: "Install dasel with Homebrew"
				run:  "brew install dasel"
			},
			_#step & {
				name: "Do some dasel things"
				run:  #"echo '{"name": "Tom"}' | dasel -r json '.name'"#
			},
		]
	}

}
