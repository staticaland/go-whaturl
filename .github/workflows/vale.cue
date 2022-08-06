package workflows

import "encoding/json"

#SlackAction: {
	uses: string | *"slackapi/slack-github-action@936158bbe252e9a6062e793ea4609642c966e302"
	env: SLACK_BOT_TOKEN: string | *"${{ secrets.SLACK_BOT_TOKEN }}"
	with: {
		"channel-id": "workflows"
		...
	}
	...
}

SlackBlocks: {
	"text": "Vale deployment failure"
	"blocks": [
		{
			"type": "section"
			"text": {
				"type": "mrkdwn"
				"text": "*Vale* deployment :warning: failure :warning:"
			}
		},
		{
			"type": "divider"
		},
		{
			"type": "section"
			"text": {
				"type": "mrkdwn"
				"text": "Vale DocOps failed deployment during. Write better! The best way to fix this particular issue is <https://github.com/${{github.repository}}/actions/runs/${{github.run_id}}|viewing the CI server logs> to learn why and fix the issue."
			}
		},
	]
}

#SlackPayload: {
	text: string
	attachments: [...{
		pretext: string
		color:   string
		fields: [{
			title:      string
			short:      bool | *true
			value:      string
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
			#Checkout,
			#SlackAction & {
				with: {
					"channel-id": "workflows"
					payload:      json.Marshal(SlackMsgBeginDeployment)
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
					payload:      json.Marshal(SlackBlocks)
				}
			},
		]

	}

}
