package workflows

import "json.schemastore.org/github"

_github_username: "staticaland"
_project_name: "go-whaturl"
_binary_name: "whaturl"

_go_version: "1.18.5"
_cue_version: "0.4.3"

_paths_go: [
	"**.go",
	"go.mod",
	"go.sum",
]

_branches_default: ["main"]

_#workflow: github.#workflow & {
	name: string
	...
}

_#workflow: {
	name: =~"^[A-Z].*" // Sentence case
	...
}

_#job:  ((github.#workflow & {}).jobs & {x: _}).x
_#step: ((_#job & {steps:                   _}).steps & [_])[0]

_#step: {
	name: =~"^[A-Z].*" // Sentence case
	uses?: =~"^[^@]+@[a-f0-9]{40}" // Must pin with SHA1
	...
}

_#stepSetupGo: _#step & {
	name: "Set up Go"
	uses: "actions/setup-go@84cbf8094393cdc5fe1fe1671ff2647332956b1a" // v3.2.1
	with: "go-version": _go_version
	...
}

_#stepCheckout: _#step & {
	name: "Checkout"
	uses: "actions/checkout@2541b1294d2704b0964813337f33b291d3f8596b" // v3.0.2
	...
}