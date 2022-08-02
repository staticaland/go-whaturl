name: "Vale"
on: pull_request: paths: [
	"**.org",
	"**.md",
]
on: push: paths: [
	"**.org",
	"**.md",
]

jobs: vale: {
	name:      "Vale"
	"runs-on": "ubuntu-latest"
	steps: [{
		uses: "actions/checkout@v3"
	},
	{
		uses: "errata-ai/vale-action@reviewdog",
		env: GITHUB_TOKEN: "${{secrets.GITHUB_TOKEN}}",
	},
	{
		uses: "slackapi/slack-github-action@v1.21.0"
		with: {
			"channel-id": "workflows",
			"slack-message": "Vale DocOps workflow ran. Thanks for writing!",
		}
		env: SLACK_BOT_TOKEN: "${{ secrets.SLACK_BOT_TOKEN }}"
	}]

}
