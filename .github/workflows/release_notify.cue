package workflows

import (
	"encoding/json"
)

name: "Published release"

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

	on: release: types: ["published"]

	jobs: notify: {
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
