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

	name: "Set up Go"
	uses: _org + "/" + _repository + "@" + _version
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

_#stepDockerLogin: _#step & {
	name: "Login to Docker Hub"
	uses: "docker/login-action@49ed152c8eca782a232dede0303416e8f356c37b"
	with: {
		username: "${{ secrets.DOCKERHUB_USERNAME }}"
		password: "${{ secrets.DOCKERHUB_TOKEN }}"
	}
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
