package common

import "json.schemastore.org/github"

#workflow: github.#workflow & {
	name: string
	...
}

#workflow: {
	name: =~"^[A-Z].*" // Sentence case
}

#job: ((github.#workflow & {}).jobs & {x: _}).x

#job: {
	name:      =~"^[A-Z].*" // Sentence case
	"runs-on": "ubuntu-latest"
	...
}

#step: ((#job & {steps: _}).steps & [_])[0]

#step: {
	name:  =~"^[A-Z].*"                                             // Sentence case
	uses?: =~"(^docker:[^:]+:[A-Fa-f0-9]{64}$|^[^@]+@[a-f0-9]{40})" // Must pin with SHA1 (Git) or SHA256 (Docker)
	...
}

#stepMeta: {
	org:                 string
	repository:          string
	version:             string
	uses:                org + "/" + repository + "@" + version
	url_org:             "https://github.com/" + org
	url_org_link:        "[`" + org + "`](" + url_org + ")"
	url_repository:      url_org + "/" + repository
	url_repository_link: "[`" + org + "/" + repository + "`](" + url_repository + ")"
}

#stepSetupGo: #step & {

	_meta: #stepMeta & {
		org:        "actions"
		repository: "setup-go"
		version:    "268d8c0ca0432bb2cf416faae41297df9d262d7f"
	}

	name: "Setup Go environment"
	uses: _meta.uses
	with: "go-version": go_version
	...
}

#stepSetupCue: #step & {

	_meta: #stepMeta & {
		org:        "cue-lang"
		repository: "setup-cue"
		version:    "143c2fe537047bf8c7ead6a30784ad1802e9d991"
	}

	name: "Setup CUE environment"
	uses: _meta.uses
	with: version: "v" + cue_version
}

#stepCheckout: #step & {

	_meta: #stepMeta & {
		org:        "actions"
		repository: "checkout"
		version:    "2541b1294d2704b0964813337f33b291d3f8596b"
	}

	name: "Checkout"
	uses: _meta.uses
}

#stepDockerLogin: #step & {

	_meta: #stepMeta & {
		org:        "docker"
		repository: "login-action"
		version:    "49ed152c8eca782a232dede0303416e8f356c37b"
	}

	name: "Login to Docker Hub"
	uses: _meta.uses
	with: {
		username: "${{ secrets.DOCKERHUB_USERNAME }}"
		password: "${{ secrets.DOCKERHUB_TOKEN }}"
	}
}

#stepCreatePR: #step & {

	_meta: #stepMeta & {
		org:        "peter-evans"
		repository: "create-pull-request"
		version:    "18f90432bedd2afd6a825469ffd38aa24712a91d"
	}

	name: "Create pull request"
	uses: _meta.uses
}

#stepGitDiffCheck: #step & {
	name: "Check commit is clean"
	run:  "test -z \"$(git status --porcelain)\" || (git status; git diff; false)"
}

_stepIdGitCheck: "git-check"

#stepGitDiffModified: #step & {
	name: "Check for modified files"
	id:   _stepIdGitCheck
	run:  #"echo ::set-output name=modified::$(if git diff-index --quiet HEAD --; then echo "false"; else echo "true"; fi)"#
}

#stepPushChanges: #step & {
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
