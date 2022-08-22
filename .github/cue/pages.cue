package whaturl

pages: _#workflow & {

	name: "Deploy Hugo site to Pages"

	on: {
		push: {
			branches: _branches_default
			paths: [
				"**.org",
				"**.md",
			]
		}
		workflow_dispatch: null
	}

	// Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
	permissions: {
		contents:   "read"
		pages:      "write"
		"id-token": "write"
	}

	// Allow one concurrent deployment
	concurrency: {
		group:                "pages"
		"cancel-in-progress": true
	}

	defaults: run: shell: "bash"

	jobs: {

		build: _#job & {

			name: "Build GitHub Pages with Hugo"

			env: {
				HUGO_VERSION: _hugo_version
				HUGO_ENV:     "production"
			}

			steps: [
				_#stepCheckout & {with: submodules: "recursive"},
				_#step & {
					name: "Convert README to Hugo compatible MD"
					uses: "docker://pandoc/core@sha256:65d98a5fb89867961479c16f4597134517923661aca23ef63843f6b6e623508b"
					with: args: "--from=org --to=gfm --output docs/content/index.md README.org"
				},
				_#step & {
					name: "Install Hugo CLI"
					run: """
						wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb \\
						&& sudo dpkg -i ${{ runner.temp }}/hugo.deb

						"""
				},
				_#step & {
					name: "Setup Pages"
					id:   "pages"
					uses: "actions/configure-pages@61fd3a3cc1d0a4c8dae3bce7d897863ccdedb25d"
				},
				_#step & {
					name:                "Build with Hugo"
					"working-directory": "./docs"
					run: """
						hugo \\
							--minify \\
							--baseURL "${{ steps.pages.outputs.base_url }}"

						"""
				},
				_#step & {
					name: "Upload artifact"
					uses: "actions/upload-pages-artifact@6a57e48bf6d74ddc95cf0cfa136a09fff27067b8"
					with: path: "./docs/public"
				}]

		}

		deploy: _#job & {

			name: "Deploy to GitHub Pages"

			environment: {
				name: "github-pages"
				url:  "${{ steps.deployment.outputs.page_url }}"
			}

			needs: "build"

			steps: [{
				name: "Deploy to GitHub Pages"
				id:   "deployment"
				uses: "actions/deploy-pages@a87638c69ce253619c881e20b8c40a3ed5aeec2c"
			}]
		}
	}

}
