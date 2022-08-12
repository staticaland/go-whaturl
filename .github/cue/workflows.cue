package whaturl

workflows: [
	{
		filename: "../workflows/cue_yaml_reconciliation_check.yml"
		workflow: cue_yaml_reconciliation_check
	},
	{
		filename: "../workflows/superlinter.yml"
		workflow: superlinter
	},
	{
		filename: "../workflows/go.yml"
		workflow: go
	},
	{
		filename: "../workflows/vale.yml"
		workflow: vale
	},
	{
		filename: "../workflows/goreleaser.yml"
		workflow: goreleaser
	},
	{
		filename: "../workflows/codeql-analysis.yml"
		workflow: codeql
	},
	{
		filename: "../workflows/cue_fmt_check.yml"
		workflow: cue_formatting_check
	},
	{
		filename: "../workflows/cue_fmt_commit.yml"
		workflow: cue_formatting_commit
	},

]
