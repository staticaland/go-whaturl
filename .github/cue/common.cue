package whaturl

import "json.schemastore.org/github"

// Maybe use something like this to generate docs
_actions: "setup-go": {
	org:        "actions"
	repository: "setup-go"
	version:    "84cbf8094393cdc5fe1fe1671ff2647332956b1a"
	a:          org + "/" + repository + "@" + version
}

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
	name:  =~"^[A-Z].*"                                             // Sentence case
	uses?: =~"(^docker:[^:]+:[A-Fa-f0-9]{64}$|^[^@]+@[a-f0-9]{40})" // Must pin with SHA1 (Git) or SHA256 (Docker)
	...
}

_#stepSetupGo: _#step & {

	_org:        "actions"
	_repository: "setup-go"
	_version:    "84cbf8094393cdc5fe1fe1671ff2647332956b1a"
	_uses:       _org + "/" + _repository + "@" + _version

	name: "Set up Go"
	uses: _uses
	with: "go-version": _go_version
	...
}

_#stepSetupCue: _#step & {

	_org:        "cue-lang"
	_repository: "setup-cue"
	_version:    "143c2fe537047bf8c7ead6a30784ad1802e9d991"
	_uses:       _org + "/" + _repository + "@" + _version

	name: "Setup CUE environment"
	uses: _uses
	with: version: "v" + _cue_version
}

_#stepCheckout: _#step & {

	_org:        "actions"
	_repository: "checkout"
	_version:    "2541b1294d2704b0964813337f33b291d3f8596b"
	_uses:       _org + "/" + _repository + "@" + _version

	name: "Checkout"
	uses: _uses
	...
}

_#stepDockerLogin: _#step & {

	_org:        "docker"
	_repository: "login-action"
	_version:    "49ed152c8eca782a232dede0303416e8f356c37b"
	_uses:       _org + "/" + _repository + "@" + _version

	name: "Login to Docker Hub"
	uses: _uses
	with: {
		username: "${{ secrets.DOCKERHUB_USERNAME }}"
		password: "${{ secrets.DOCKERHUB_TOKEN }}"
	}
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
		git config --global user.name 'github-actions[bot]'
		git config --global user.email '41898282+github-actions[bot]@users.noreply.github.com'

		git commit -am "style: Automated changes"

		git remote set-url origin https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }}
		git push
		"""
}
