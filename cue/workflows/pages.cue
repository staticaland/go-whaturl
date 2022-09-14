package workflows

import "github.com/staticaland/go-whaturl/cue/common"

pages: common.#workflow & {

	name: "Deploy Hugo site to Pages"

	on: {
		push: {
			branches: common.branches_default
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

		build: common.#job & {

			name: "Build GitHub Pages with Hugo"

			env: {
				HUGO_VERSION: common.hugo_version
				HUGO_ENV:     "production"
			}

			steps: [
				common.#stepCheckout & {with: submodules: "recursive"},
				common.#step & {
					name: "Convert README to Hugo compatible MD"
					uses: "docker://pandoc/core@sha256:65d98a5fb89867961479c16f4597134517923661aca23ef63843f6b6e623508b"
					with: args: "--from=org --to=gfm --output docs/content/index.md README.org"
				},
				common.#step & {
					name: "Install Hugo CLI"
					run: """
						wget -O "${{ runner.temp }}/hugo.deb" "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \\
						&& sudo dpkg -i "${{ runner.temp }}/hugo.deb"

						"""
				},
				common.#step & {
					name: "Setup Pages"
					id:   "pages"
					uses: "actions/configure-pages@45efe609374726fd94570f0e5a4c32f41675e823"
				},
				common.#step & {
					name:                "Build with Hugo"
					"working-directory": "./docs"
					run: """
						hugo \\
							--minify \\
							--baseURL "${{ steps.pages.outputs.base_url }}"

						"""
				},
				common.#step & {
					name: "Upload artifact"
					uses: "actions/upload-pages-artifact@a597aecd27af1cf14095ccaa29169358e3d91e28"
					with: path: "./docs/public"
				}]

		}

		deploy: common.#job & {

			name: "Deploy to GitHub Pages"

			environment: {
				name: "github-pages"
				url:  "${{ steps.deployment.outputs.page_url }}"
			}

			needs: "build"

			steps: [{
				name: "Deploy to GitHub Pages"
				id:   "deployment"
				uses: "actions/deploy-pages@c2379ec5e719a934ec613038d081879b58c9d7df"
			}]
		}
	}

}
