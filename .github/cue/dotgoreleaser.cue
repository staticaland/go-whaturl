package whaturl

dotgoreleaser: {

	builds: [{
		binary: _binary_name
	}]

	dockers: [
		{
			image_templates: [
				"staticaland/whaturl",
			]
		},
	]

	brews: [{
		name:        _binary_name
		description: "A CLI for creating titled markup language links out of text containing raw URLs"
		homepage:    "https://github.com/staticaland/go-whaturl"

		goarm: 6

		goamd64: "v3"

		tap: {
			owner: _github_username
			name:  _project_name
		}

		folder: "Formula"

		install: """
			bin.install \"whaturl\"

			"""
	}]

	announce: slack: {
		enabled:  true
		channel:  "workflows"
		username: "whaturl"
	}

	changelog: {
		sort: "asc"

		groups: [{
			title:  "Features"
			regexp: "^.*feat[(\\w)]*:+.*$"
			order:  0
		}, {
			title:  "Bug fixes"
			regexp: "^.*fix[(\\w)]*:+.*$"
			order:  1
		}, {
			title: "Others"
			order: 999
		}]

		filters: exclude: [
			"^docs:",
			"^test:",
			"README",
			"OK",
			"Merge pull request",
			"Merge branch",
			"^ci:",
			"^chore:",
			"^refactor:",
			"Brew formula update",
		]
	}

}
