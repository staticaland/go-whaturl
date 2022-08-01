on: [
	"push",
	"pull_request",
]

name: "CUE regenerate"

jobs: workflow2_job1: {
	"runs-on": "ubuntu-latest"

	steps: [{
		name: "Checkout code"
		uses: "actions/checkout@v3"
	}, {
		name: "Setup CUE environment"
		uses: "cue-lang/setup-cue@v1.0.0-alpha.2"
		with: version: "latest"
	}, {
		name:                "Regenerate YAML from CUE"
		"working-directory": ".github/workflows"
		run: """
			cue export --out yaml goreleaser.cue > goreleaser.cue
			cue export --out yaml superlinter.cue > superlinter.yml
			cue export --out yaml go.cue > go.yml
			cue export --out yaml vale.cue > vale.yml
			cue export --out yaml cue_verify.cue > cue_verify.yml

			"""
	}, {
		name: "Check commit is clean"
		run:  "test -z \"$(git status --porcelain)\" || (git status; git diff; false)"
	}]
}