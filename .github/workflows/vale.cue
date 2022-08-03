package workflows

import "encoding/json"

#SlackAction: {
	uses:         string | *"slackapi/slack-github-action@v1.21.0"
	env: SLACK_BOT_TOKEN: string | *"${{ secrets.SLACK_BOT_TOKEN }}"
	...
}

#SlackPayload: {
	text: string
	attachments: [...{
		pretext: string
		color: string
		fields: [{
			title: string
			short: bool | *true
			value: string
			"run_link": string | *"https://${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
		}]
		...
	}]
	...
}

SlackMsgBeginDeployment: #SlackPayload & {
	"text": "Deployment started (In Progress)"
	"attachments": [
		{
			"pretext": "Deployment started"
			"color":   "dbab09"
			"fields": [
				{
					"title": "Status"
					"value": "In Progress"
				},
			]
		},
	]
}

SlackMsgCompleteDeployment: #SlackPayload & {
	"text": "Deployment finished (Completed)"
	"attachments": [
		{
			"pretext": "Deployment finished"
			"color":   "28a745"
			"fields": [
				{
					"title": "Status"
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

			#SlackAction & {
				with: {
					"channel-id": "workflows"
					payload: json.Marshal(SlackMsgBeginDeployment)
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
			#SlackAction & {
				if: "${{ failure() }}"
				with: {
					"channel-id": "workflows"
					payload: json.Marshal(SlackMsgCompleteDeployment)
				}
			},
		]

	}

}
