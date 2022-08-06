package workflows

workflows: [
	{
		filename: "cue_yaml_reconciliation_check.yml"
		workflow: cue_yaml_reconciliation_check
	},
	{
		filename: "superlinter.yml"
		workflow: superlinter
	},
	{
		filename: "go.yml"
		workflow: go
	},
	{
		filename: "vale.yml"
		workflow: vale
	},
	{
		filename: "goreleaser.yml"
		workflow: goreleaser
	},
	{
		filename: "codeql-analysis.yml"
		workflow: codeql
	},

]
