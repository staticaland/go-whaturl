package workflows

import "github.com/staticaland/go-whaturl/cue/common"

asdf: common.#workflow & {

	on: workflow_dispatch: inputs: {

		plugin: {
			type:        "string"
			required:    true
			description: "Which asdf plugin"
		}

		constraint: {
			type:        "string"
			default:     ""
			required:    false
			description: "Version constraint"
		}

	}

	name: "Update asdf tool versions"

	jobs: compile_assets: common.#job & {

		name: "Update ${{ inputs.plugin }}"

		permissions: {
			contents:        "write"
			"pull-requests": "write"
		}

		steps: [
			common.#stepCheckout,
			common.#step & {
				name: "Setup asdf"
				uses: "asdf-vm/actions/install@707e84f3ee349548310aeabdad0dd3bfcb9b69fa"
			},
			common.#step & {
				name: "Get Newest Version"
				id:   "newestVersion"
				run: """
					LATEST_VERSION=$(asdf latest '${{ inputs.plugin }}' '${{ inputs.constraint }}')
					echo 'Latest (${{ inputs.constraint }}): $LATEST_VERSION'
					echo ::set-output name=LATEST_VERSION::${LATEST_VERSION}

					"""
			},
			common.#step & {
				name: "Try Installing new version"
				run: """
					asdf install '${{ inputs.plugin }}' '${{ steps.newestVersion.outputs.LATEST_VERSION }}'

					"""
			},
			common.#step & {
				name: "Apply latest version to .tool-versions"
				run: """
					asdf local '${{ inputs.plugin }}' '${{ steps.newestVersion.outputs.LATEST_VERSION }}'

					"""
			},
			common.#stepCreatePR & {
				with: {
					"add-paths":      ".tool-versions"
					"commit-message": "Update ${{ inputs.plugin }} to ${{ steps.newestVersion.outputs.LATEST_VERSION }}"
					title:            "Update ${{ inputs.plugin }} to ${{ steps.newestVersion.outputs.LATEST_VERSION }}"
					branch:           "asdf/${{ inputs.plugin }}/${{ steps.newestVersion.outputs.LATEST_VERSION }}"
					"delete-branch":  true
					labels:           "asdf,enhancement"
				}
			},
		]
	}

}
