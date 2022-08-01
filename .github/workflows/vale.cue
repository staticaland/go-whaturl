name: "Vale"
on: pull_request: paths: [
	"**.org",
	"**.md",
]

jobs: vale: {
	name:      "Vale"
	"runs-on": "ubuntu-latest"
	steps: [{
		uses: "actions/checkout@v3"
	}, {
		uses: "errata-ai/vale-action@reviewdog"
		env: GITHUB_TOKEN: "${{secrets.GITHUB_TOKEN}}"
	}]
}