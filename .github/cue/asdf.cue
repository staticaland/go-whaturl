package whaturl

asdf: {

	on: workflow_dispatch: inputs: {

		plugin: {
			type:     "string"
			required: true
		}

		constraint: {
			type:     "string"
			default:  ""
			required: false
		}

	}

	name: "Update asdf tool versions"

	jobs: compile_assets: {

		name: "${{ inputs.plugin }}"

		"runs-on": "ubuntu-latest"

		permissions: {
			contents:        "write"
			"pull-requests": "write"
		}

		steps: [

			_#stepCheckout,
			_#step & {
				name: "Setup asdf"
				uses: "asdf-vm/actions/install@707e84f3ee349548310aeabdad0dd3bfcb9b69fa"
			},
			_#step & {
				name: "Get Newest Version"
				id:   "newestVersion"
				run: """
					LATEST_VERSION=$(asdf latest \"${{ inputs.plugin }}\" \"${{ inputs.constraint }}\")
					echo \"Latest (${{ inputs.constraint }}): $LATEST_VERSION\"
					echo ::set-output name=LATEST_VERSION::${LATEST_VERSION}

					"""
			},
			_#step & {
				name: "Try Installing new version"
				run: """
					asdf install \"${{ inputs.plugin }}\" \"${{ steps.newestVersion.outputs.LATEST_VERSION }}\"

					"""
			},
			_#step & {
				name: "Apply latest version to .tool-versions"
				run: """
					asdf local \"${{ inputs.plugin }}\" \"${{ steps.newestVersion.outputs.LATEST_VERSION }}\"

					"""
			},
			_#step & {
				name: "Create pull request"
				uses: "peter-evans/create-pull-request@18f90432bedd2afd6a825469ffd38aa24712a91d"
				with: {
					"add-paths":      ".tool-versions"
					"commit-message": "Update ${{ inputs.plugin }} to ${{ steps.newestVersion.outputs.LATEST_VERSION }}"
					title:            "Update ${{ inputs.plugin }} to ${{ steps.newestVersion.outputs.LATEST_VERSION }}"
					branch:           "asdf/${{ inputs.plugin }}/${{ steps.newestVersion.outputs.LATEST_VERSION }}"
					"delete-branch":  true
					labels:           "asdf,enhancement"
				}
			}]
	}

}
