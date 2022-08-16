package whaturl

pages: _#workflow & {

	name: "Deploy Hugo site to Pages"

	on: {
		push: branches: _branches_default
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

			env: HUGO_VERSION: "0.99.0"

			steps: [
				_#step & {
					name: "Install Hugo CLI"
					run: """
						wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb \\
						&& sudo dpkg -i ${{ runner.temp }}/hugo.deb

						"""
				},
				_#stepCheckout & {with: submodules: "recursive"},
				_#step & {
					name: "Setup Pages"
					id:   "pages"
					uses: "actions/configure-pages@e22fa7ebed408f1742133d89012dbe1dad4646fc"
				},
				_#step & {
					name:                "Build with Hugo"
					"working-directory": "./docs"
					run: """
						hugo \\
							--minify \\
							--baseURL ${{ steps.pages.outputs.base_url }}

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
				uses: "actions/deploy-pages@e490850a64fea2143eb618fcd4453e397842ae0c"
			}]
		}
	}

}
