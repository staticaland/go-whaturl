package workflows

import "github.com/staticaland/go-whaturl/cue/common"

_#w: {
	file:   string
	schema: (common.#workflow & {})
}
<<<<<<< HEAD
=======

_#w: {
	file: =~"^[a-z-]+\\.yml" // Lowercase and hyphens, must end with .yml (as opposed to .yaml)
}

workflows: [..._#w]
>>>>>>> 0bc216151e876014c441de263f249b0303a3bb7e

_#w: {
	file: =~"^[a-z-]+\\.yml" // Lowercase and hyphens, must end with .yml (as opposed to .yaml)
}

workflows: [..._#w]

workflows: [
	{
		file:   "go.yml"
		schema: go
	},
	{
		file:   "asdf.yml"
		schema: asdf
	},
	{
		file:   "cue-download-github-schema.yml"
		schema: cue_download_github_schema
	},
	{
		file:   "cue-fmt-check.yml"
		schema: cue_formatting_check
	},
	{
		file:   "pages.yml"
		schema: pages
	},
	{
		file:   "dasel.yml"
		schema: dasel
	},
	{
		file:   "superlinter.yml"
		schema: superlinter
	},
	{
		file:   "goreleaser.yml"
		schema: goreleaser
	},
	{
		file:   "vale.yml"
		schema: vale
	},
	{
		file:   "codeql-analysis.yml"
		schema: codeql
	},
	{
		file:   "cue-yaml-reconciliation-check.yml"
		schema: cue_yaml_reconciliation_check
	},
	{
		file:   "table.yml"
		schema: table
	},
]
