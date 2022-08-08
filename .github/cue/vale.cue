package whaturl

_#stepSlack: _#step & {
	name: string | *"Ring the bell"
	uses: string | *"slackapi/slack-github-action@936158bbe252e9a6062e793ea4609642c966e302"
	env: SLACK_BOT_TOKEN: string | *"${{ secrets.SLACK_BOT_TOKEN }}"
	with: {
		"channel-id": "workflows"
		...
	}
	...
}

_#slackPayload: {
	text: string
	attachments: [...{
		pretext: string
		color:   string
		fields: [{
			title:    string
			short:    bool | *true
			value:    string
			run_link: string | *"https://${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
		}]
		...
	}]
	...
}

_slackBlocks: {
	text: "Vale deployment failure"
	blocks: [
		{
			type: "section"
			text: {
				type: "mrkdwn"
				text: "*Vale* deployment :warning: failure :warning:"
			}
		},
		{
			type: "divider"
		},
		{
			type: "section"
			text: {
				type: "mrkdwn"
				text: "Vale DocOps failed deployment during. Write better! The best way to fix this particular issue is <https://github.com/${{github.repository}}/actions/runs/${{github.run_id}}|viewing the CI server logs> to learn why and fix the issue."
			}
		},
	]
}

_slackMsgBeginDeployment: _#slackPayload & {
	text: "Deployment started (In Progress)"
	attachments: [
		{
			pretext: "Deployment started"
			color:   "dbab09"
			fields: [
				{
					title: "Status"
					value: "In Progress"
				},
			]
		},
	]
}

_slackMsgCompleteDeployment: _#slackPayload & {
	text: "Deployment finished (Completed)"
	attachments: [
		{
			pretext: "Deployment finished"
			color:   "28a745"
			fields: [
				{
					title: "Status"
					value: "Completed"
				},
			]
		},
	]
}

vale: _#workflow & {

	name: "Vale"

	on: pull_request: paths: [
		"**.org",
		"**.md",
		".github/styles/**",
		".vale.ini",
	]
	on: push: paths: on.pull_request.paths

	jobs: vale: _#job & {
		name: "Vale"
		steps: [
			_#stepCheckout,
			_#step & {
				name: "Run Vale"
				uses: "errata-ai/vale-action@c4213d4de3d5f718b8497bd86161531c78992084"
				env: GITHUB_TOKEN: "${{secrets.GITHUB_TOKEN}}"
				with: {
					fail_on_error: true
					reporter:      "github-check"
				}
			},
		]

	}

}
