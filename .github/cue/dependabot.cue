package whaturl

dependabot: {

	version: 2
	updates: [{
		"package-ecosystem": "github-actions"
		directory:           "/"
		schedule: interval: "daily"
		"commit-message": {
			prefix:               "fix"
			"prefix-development": "chore"
			include:              "scope"
		}
	}, {
		"package-ecosystem": "gomod"
		directory:           "/"
		schedule: interval: "daily"
	}]

}
