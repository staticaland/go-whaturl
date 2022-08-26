package whaturl

import (
	"encoding/yaml"
	"path"
	"tool/file"

	"github.com/staticaland/go-whaturl/cue/misc"
	"github.com/staticaland/go-whaturl/cue/workflows"
)

command: gen: {

	_goos: string @tag(os,var=os)

	"goreleaser.yaml": file.Create & {
		filename: "../.goreleaser.yaml"
		contents: yaml.Marshal(misc.dotgoreleaser)
	}

	"config.yml": file.Create & {
		filename: "../docs/config.yml"
		contents: yaml.Marshal(misc.hugo)
	}

	for w in workflows.workflows {
		"\(w.file)": file.Create & {
			_dir:     path.FromSlash("../.github/workflows", path.Unix)
			filename: path.Join([_dir, w.file], _goos)
			contents: """
						 # Generated by cue/workflows_tool.cue; do not edit
						 \(yaml.Marshal(w.schema))
						 """
		}
	}

}
