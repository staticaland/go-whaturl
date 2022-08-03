package workflows

import (
	"encoding/json"
)

SlackBlockRelease: {
	"blocks": [
		{
			"type": "section"
			"text": {
				"type": "mrkdwn"
				"text": "A new version of `whaturl` has been released: `${{ github.event.release.tag_name }}` :tada:"
			}
			"accessory": {
				"type": "button"
				"text": {
					"type": "plain_text"
					"text": "See details"
				}
				"url": "${{ github.event.release.html_url }}"
			}
		},
	]
}

release_notify: {

	name: "Release notification"

	on: release:

	jobs: notify: {
		name: "Perform Slack notification"
		"runs-on": "ubuntu-latest"
		steps: [
			#SlackAction & {
				with: {
					payload: json.Marshal(SlackBlockRelease)
				}
			},
		]

	}

}
