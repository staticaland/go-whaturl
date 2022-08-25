package whaturl

// Tip link for humans:
_url_gh_workflow_schema:          "https://raw.githubusercontent.com/SchemaStore/schemastore/6fe4707b9d1c5d45cfc8d5b6d56968e65d2bdc38/src/schemas/json/github-workflow.json"
_filename_gh_workflow_schema:     "gh-workflows-schema.json"
_filename_gh_workflow_cue_schema: "github-workflow.cue"

cue_download_github_schema: _#workflow & {

	name: "Create PR with latest GitHub schema"

	on: workflow_dispatch: {}

	permissions: contents: "read"

	jobs: cue_fmt_check: _#job & {
		name:      "CUE formatting check"
		"runs-on": "ubuntu-latest"

		permissions: {
			contents:        "write"
			"pull-requests": "write"
		}

		steps: [
			_#stepCheckout,
			_#stepSetupCue,
			_#step & {
				name:                "Download GitHub schema"
				"working-directory": ".github/cue/cue.mod/pkg/json.schemastore.org/github"
				run:                 "curl \(_url_gh_workflow_schema) --output \(_filename_gh_workflow_schema)"
			},
			_#step & {
				name:                "Import GitHub schema with CUE"
				"working-directory": ".github/cue/cue.mod/pkg/json.schemastore.org/github"
				run:                 "cue import --force --package json --path '#workflow:' --outfile \(_filename_gh_workflow_cue_schema) jsonschema: \(_filename_gh_workflow_schema)"
			},
			_#stepCreatePR & {
				with: {
					"add-paths":      "_(filename_gh_workflow_cue_schema)"
					path:             ".github/cue/cue.mod/pkg/json.schemastore.org/github"
					"commit-message": "Update..."
					title:            "Update..."
					"delete-branch":  true
					labels:           "cue,enhancement"
				}
			},
			_#stepGitDiffCheck,
		]
	}

}
