package workflows

import (
	"tool/file"
	"encoding/yaml"
)

command: genworkflows: {

	for w in workflows {
		"\(w.filename)": file.Create & {
			filename: w.filename
			contents: yaml.Marshal(w.workflow)
		}
	}

}

command: d: {

	file.Create & {
		filename: "../dependabot.yml"
		contents: yaml.Marshal(dependabot)
	}
}

command: gr: {

	file.Create & {
		filename: "../../.goreleaser.yaml"
		contents: yaml.Marshal(dotgoreleaser)
	}
}

command: toolversions: {

	file.Create & {
		filename: "../../.tool-versions"
		contents: "go " + _go_version
	}

}
