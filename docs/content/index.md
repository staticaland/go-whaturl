# whaturl

<p>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/go.yml">
        <img alt="Build" src="https://github.com/staticaland/go-whaturl/actions/workflows/go.yml/badge.svg" />
    </a>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/vale.yml">
        <img alt="Vale" src="https://github.com/staticaland/go-whaturl/actions/workflows/vale.yml/badge.svg" />
    </a>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/goreleaser.yml">
        <img alt="Release" src="https://github.com/staticaland/go-whaturl/actions/workflows/goreleaser.yml/badge.svg" />
    </a>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/superlinter.yml">
        <img alt="Lint" src="https://github.com/staticaland/go-whaturl/actions/workflows/superlinter.yml/badge.svg" />
    </a>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/cue_yaml_reconciliation_check.yml">
        <img alt="CUE" src="https://github.com/staticaland/go-whaturl/actions/workflows/cue_yaml_reconciliation_check.yml/badge.svg" />
    </a>
    <a href="https://github.com/staticaland/go-whaturl/releases">
        <img alt="Version" src="https://img.shields.io/github/v/release/staticaland/go-whaturl" />
    </a>
</p>

# About

`whaturl` replaces URLs found in text with a markup hyperlink with the
contents of the `<title>` tag in the HTML of the URL. It works like a
typical [Unix
filter](https://en.wikipedia.org/wiki/Filter_%28software%29):

``` bash
echo "I like https://github.com" | whaturl
I like [GitHub: Where the world builds software · GitHub](https://github.com)
```

Inspired by [Titler by Brett
Terpstra](http://brettterpstra.com/2015/02/18/titler-system-service/)
for Mac OS and [org-cliplink](https://github.com/rexim/org-cliplink) for
Emacs.

# Usage

``` bash
Usage of whaturl:
  -format string
        Specify link format (default "markdown")
  -list
        Create list of links
  -relaxed
        Process URLs without a schema
```

If you run the program, it will wait for input from
[stdin](https://en.wikipedia.org/wiki/Standard_streams#Standard_input_(stdin)).

``` bash
whaturl
```

You can write lines to it and get a result by pressing enter. To finish,
press Ctrl+D to communicate
[end-of-transmission](https://en.wikipedia.org/wiki/End-of-Transmission_character).
However, the more common use-case is to pipe something directly:

``` bash
cat urls | whaturl
```

# Editor integration

## Emacs

I use `reformatter.el` (see [my reformatter.el configuration
here](https://github.com/staticaland/doom-emacs-config/blob/master/modules/editor/reformatter/config.el)).
Otherwise, `shell-command-on-region` is what you are looking for. Read
[Executing Shell Commands in
Emacs](https://www.masteringemacs.org/article/executing-shell-commands-emacs)
to learn more.

## Vim

``` example
nnoremap <leader>l :%!whaturl<CR>
vnoremap <leader>l :!whaturl<CR>
```

This is reminiscent of the [Vim Kōan Master Wq and the Markdown
acolyte](https://blog.sanctum.geek.nz/vim-koans/).

# Installation

[Check out releases for pre-built
binaries](https://github.com/staticaland/go-whaturl/releases).

## Homebrew

A Homebrew formula is included at
[Formula/whaturl.rb](./Formula/whaturl.rb).

``` bash
brew tap staticaland/go-whaturl https://github.com/staticaland/go-whaturl
brew install whaturl
```

If you watch the project (Watch → Custom → Releases) you can easily
upgrade to the latest version when notified:

``` bash
brew upgrade whaturl
```

To uninstall:

``` bash
brew uninstall whaturl
brew untap staticaland/go-whaturl
```

# Build and run

<p>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/go.yml">
        <img alt="Build" src="https://github.com/staticaland/go-whaturl/actions/workflows/go.yml/badge.svg" />
    </a>
</p>

``` bash
go build whaturl.go
```

``` bash
go run whaturl.go
```

# Test

<p>
    <a href="https://github.com/staticaland/go-whaturl/actions/workflows/go.yml">
        <img alt="Build" src="https://github.com/staticaland/go-whaturl/actions/workflows/go.yml/badge.svg" />
    </a>
</p>

``` bash
go test
```

# Similar projects

-   [markdown-link-expander](https://github.com/Skn0tt/markdown-link-expander)
-   [kukushi/PasteURL](https://github.com/kukushi/PasteURL)
-   [zolrath/obsidian-auto-link-title](https://github.com/zolrath/obsidian-auto-link-title)
-   [sindresorhus/linkify-urls](https://github.com/sindresorhus/linkify-urls)
-   [sindresorhus/urls-md](https://github.com/sindresorhus/urls-md)
-   [alphapapa/org-protocol-capture-html](https://github.com/alphapapa/org-protocol-capture-html)
-   [deathau/markdownload](https://github.com/deathau/markdownload)
-   [kepano/obsidian-web-clipper.js](https://gist.github.com/kepano/90c05f162c37cf730abb8ff027987ca3)
-   [Keyboard Maestro - Create a Markdown Link for a URL in the
    Clipboard](https://forum.keyboardmaestro.com/t/create-a-markdown-link-url-title-url-for-a-url-in-the-clipboard/8505)
-   [Hyper Optimized URL grabber (Using Keyboard Maestro on the
    Mac)](https://forum.obsidian.md/t/hyper-optimized-url-grabber-using-keyboard-maestro-on-the-mac/34318)

# See also

-   [Vim Tip: Paste Markdown Link with Automatic Title
    Fetching](https://benjamincongdon.me/blog/2020/06/27/Vim-Tip-Paste-Markdown-Link-with-Automatic-Title-Fetching/)
-   [Automate Copying and Pasting the Current Page Title and URL with
    Keyboard
    Maestro](https://www.moncefbelyamani.com/automate-pasting-title-and-url-of-frontmost-browser/)

# Bookmarklets

[Org Mode](https://orgmode.org):

``` javascript
javascript:(
    function(){
        prompt(
            '',
            '[['
                +location.href
                +']['
                +document.title.replace(/ [-,|].*$/,'')
                +']]'
        )
    }
)()
```

Markdown:

``` javascript
javascript:(
    function(){
        prompt(
            '',
            '['
                +[location.href](<document.title.replace(/ [-,|].*$/,'')>)
                +']('
                +location.href
                +')'
        )
    }
)()
```
