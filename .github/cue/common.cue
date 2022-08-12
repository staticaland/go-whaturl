package whaturl

import "json.schemastore.org/github"

_github_username: "staticaland"
_project_name:    "go-whaturl"
_binary_name:     "whaturl"

_go_version:  "1.18.5"
_cue_version: "0.4.3"

_paths_go: [
	 "**.go",
	"go.mod",
	"go.sum",
]

_paths_cue: [
	"**.cue",
	"**.yml",
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

_#job: ((github.#workflow & {}).jobs & {x: _}).x

_#job: {
	name:      =~"^[A-Z].*" // Sentence case
	"runs-on": "ubuntu-latest"
	...
}

_#step: ((_#job & {steps: _}).steps & [_])[0]

_#step: {
	name:  =~"^[A-Z].*"            // Sentence case
	uses?: =~"^[^@]+@[a-f0-9]{40}" // Must pin with SHA1
	...
}

_#stepSetupGo: _#step & {
	name: "Set up Go"
	uses: "actions/setup-go@84cbf8094393cdc5fe1fe1671ff2647332956b1a" // v3.2.1
	with: "go-version": _go_version
	...
}

_#stepSetupCue: _#step & {
	name: "Setup CUE environment"
	uses: "cue-lang/setup-cue@143c2fe537047bf8c7ead6a30784ad1802e9d991"
	with: version: "v" + _cue_version
}

_#stepCheckout: _#step & {
	name: "Checkout"
	uses: "actions/checkout@2541b1294d2704b0964813337f33b291d3f8596b" // v3.0.2
	...
}

_#stepGitDiffCheck: _#step & {
	name: "Check commit is clean"
	run:  "test -z \"$(git status --porcelain)\" || (git status; git diff; false)"
}

_stepIdGitCheck: "git-check"

_#stepGitDiffModified: _#step & {
	name: "Check for modified files"
	id:   _stepIdGitCheck
	run:  #"echo ::set-output name=modified::$(if git diff-index --quiet HEAD --; then echo "false"; else echo "true"; fi)"#
}

_#stepPushChanges: _#step & {
	name: "Push changes"
	if:   "steps." + _stepIdGitCheck + ".outputs.modified == 'true'"
	run: """
		git config --global user.name 'Anders K. Pettersen'
		git config --global user.email 'staticaland@users.noreply.github.com'

		git commit -am "style: Automated changes"

		git remote set-url origin https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }}
		git push
		"""
}
