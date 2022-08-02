package workflows

#Slack: {
	uses: string | *"slackapi/slack-github-action@v1.21.0"
	env: SLACK_BOT_TOKEN: string | *"${{ secrets.SLACK_BOT_TOKEN }}"
	...
}

vale: {

	name: "Vale"

	on: pull_request: paths: [
		"**.org",
		"**.md",
	]
	on: push: paths: on.pull_request.paths

	jobs: vale: {
		name:      "Vale"
		"runs-on": "ubuntu-latest"
		steps: [
			{
				uses: "actions/checkout@v3"
			},
			{
				uses: "errata-ai/vale-action@reviewdog"
				env: GITHUB_TOKEN: "${{secrets.GITHUB_TOKEN}}"
			},
			#Slack & {
				with: {
					"channel-id":    "workflows"
					"slack-message": "Vale DocOps workflow ran. Thanks for writing!"
				}
			},
		]

	}

}
