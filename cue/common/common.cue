package common

github_username: "staticaland"
project_name:    "go-whaturl"
binary_name:     "whaturl"

go_version:         "1.18.5"
cue_version:        "0.4.3"
hugo_version:       "0.101.0"
goreleaser_version: "1.10.3"

paths_go: [
	"**.go",
	"go.mod",
	"go.sum",
]

paths_cue: [
	"**.cue",
	"**.yml",
]

branches_default: ["main"]
