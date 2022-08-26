package workflows

import "github.com/staticaland/go-whaturl/cue/common"

_url_gh_workflow_schema:          "https://raw.githubusercontent.com/SchemaStore/schemastore/6fe4707b9d1c5d45cfc8d5b6d56968e65d2bdc38/src/schemas/json/github-workflow.json"
_filename_gh_workflow_schema:     "gh-workflows-schema.json"
_filename_gh_workflow_cue_schema: "github-workflow.cue"

cue_download_github_schema: common.#workflow & {

	name: "Create PR with latest GitHub schema"

	on: workflow_dispatch: {}

	permissions: contents: "read"

	jobs: cue_fmt_check: common.#job & {

		name: "CUE formatting check"

		permissions: {
			contents:        "write"
			"pull-requests": "write"
		}

		steps: [
			common.#stepCheckout,
			common.#stepSetupCue,
			common.#step & {
				name:                "Download GitHub schema"
				"working-directory": ".github/cue/cue.mod/pkg/json.schemastore.org/github"
				run:                 "curl \(_url_gh_workflow_schema) --output \(_filename_gh_workflow_schema)"
			},
			common.#step & {
				name:                "Import GitHub schema with CUE"
				"working-directory": ".github/cue/cue.mod/pkg/json.schemastore.org/github"
				run:                 "cue import --force --package json --path '#workflow:' --outfile \(_filename_gh_workflow_cue_schema) jsonschema: \(_filename_gh_workflow_schema)"
			},
			common.#stepCreatePR & {
				with: {
					"add-paths":      ".github/cue/cue.mod/pkg/json.schemastore.org/github/\(_filename_gh_workflow_cue_schema)"
					"commit-message": "Update..."
					title:            "Update..."
					"delete-branch":  true
					labels:           "cue,enhancement"
				}
			},
			common.#stepGitDiffCheck,
		]
	}

}
