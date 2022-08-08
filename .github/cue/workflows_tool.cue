package workflows

import (
	"tool/file"
	"encoding/yaml"
)

command: gen: {

	for w in workflows {
		"\(w.filename)": file.Create & {
			filename: w.filename
			contents: yaml.Marshal(w.workflow)
		}
	}

	"dependabot.yml": file.Create & {
		filename: "../dependabot.yml"
		contents: yaml.Marshal(dependabot)
	}

	"goreleaser.yaml": file.Create & {
		filename: "../../.goreleaser.yaml"
		contents: yaml.Marshal(dotgoreleaser)
	}

	".tool-versions": file.Create & {
		filename: "../../.tool-versions"
		contents: "go " + _go_version
	}

}
