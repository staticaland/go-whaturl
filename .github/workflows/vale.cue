package workflows

import "encoding/json"

#Slack: {
	"channel-id": "workflows"
	uses:         string | *"slackapi/slack-github-action@v1.21.0"
	env: SLACK_BOT_TOKEN: string | *"${{ secrets.SLACK_BOT_TOKEN }}"
	...
}

#SlackMessage: {
	text: string
	...
}

SlackMessage: #SlackMessage & {
	"text": "Deployment started (In Progress)"
	"attachments": [
		{
			"pretext": "Deployment started"
			"color":   "dbab09"
			"fields": [
				{
					"title": "Status"
					"short": true
					"value": "In Progress"
				},
			]
		},
	]
}

SlackMessage2: {
	"text": "Deployment finished (Completed)"
	"attachments": [
		{
			"pretext": "Deployment finished"
			"color":   "28a745"
			"fields": [
				{
					"title": "Status"
					"short": true
					"value": "Completed"
				},
			]
		},
	]
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

			#Slack & {
				with: {
					payload: json.Marshal(SlackMessage)
				}
			},

			{
				uses: "errata-ai/vale-action@reviewdog"
				env: GITHUB_TOKEN: "${{secrets.GITHUB_TOKEN}}"
				with: {
					fail_on_error: true
					reporter:      "github-check"
				}
			},
			#Slack & {
				with: {
					payload: json.Marshal(SlackMessage2)
				}
			},
		]

	}

}
