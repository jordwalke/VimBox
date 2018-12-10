# Vim Markdown runtime files

## Forked For VimBox

This markdown language plugin was enhanced for the purpose of being included as
the out-of-the-box markdown plugin for VimBox.

Some improvements over the default `vim-markdown`:

- Like the markdown plugin it was forked from, `VimBox`'s `vim-markdown` plugin
  supports highlighting of fenced languages. But `VimBox`'s `vim-markdown`
  extends this with the ability to _automatically_ infer the fenced language if
  it is not specified or if the code block is one of those indented four spaces
  block. You can configure how that inference occurs.
- `VimBox`'s `vim-markdown` provides more granular highlighting regions for the
  backticks, so that the backticks can be a different color than the contents
  inside the backticks. This allows hiding the backticks without needing to
  conceal.


Here's an example VimBox `settings.json` config that auto-detects Reason and
shell syntax based on the leading content/tokens. The patterns to check are
indexed by keys representing the syntax names that should be inferred.

```json
"*": {
  "markdown": {
    "config": {
      "fenced_languages": ["json", "reason", "sh", "javascript"],
      "fenced_languages_leading_token_inference": {
        "reason": ["include [A-Z]", "let ", "module ", "/\\*"],
        "javascript": ["const "],
        "sh": ["#", "git clone ", "cd ", "mkdir "]
      },
      "folding": 1
    }
  }
}
```

## TODO:
- Add sign placements for headings.
- Table highlighting
- Add a doc file that shows up when people do `:help markdown`.

New syntax groups that color schemes can take advantage of:

- `markdownCodeFenceDelimiter` default highlight linked to
  `markdownCodeDelimiter`. This allows special highlighting of the single
  backticks (distinct from highlighting of tripple backticks)

> The rest of the original README is below:

This is the development version of Vim's included syntax highlighting and
filetype plugins for Markdown.  Generally you don't need to install these if
you are running a recent version of Vim.

One difference between this repository and the upstream files in Vim is that
the former forces `*.md` as Markdown, while the latter detects it as Modula-2,
with an exception for `README.md`.  If you'd like to force Markdown without
installing from this repository, add the following to your vimrc:

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown

If you want to enable fenced code block syntax highlighting in your markdown
documents you can enable it in your `.vimrc` like so:

    let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

To disable markdown syntax concealing add the following to your vimrc:

    let g:markdown_syntax_conceal = 0

Syntax highlight is synchronized in 50 lines. It may cause collapsed
highlighting at large fenced code block.
In the case, please set larger value in your vimrc:

    let g:markdown_minlines = 100

Note that setting too large value may cause bad performance on highlighting.

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
