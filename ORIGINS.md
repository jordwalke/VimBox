["Togglist"](dotVim/pluginRc/toggly/togglyVimRc) includes window position code
coppied from [asyncrun](https://github.com/skywind3000/asyncrun.vim)

Included Dependencies:
---------------------
Any dependencies that are included in `VimBox` may have their own license. In
the event any dependency is include in `VimBox`, an attempt has been made to
also include its corresponding license in the directory containing that
licensed work.

Each of the fonts carry their own license, which you should consult.

The VimBox application icon was derived from [Jannik Siebert](https://dribbble.com/janniks)'s excellent [Sublime
icon](https://dribbble.com/shots/1827862-Yosemite-Sublime-Text-Icon). See the icon's `README` for more information and links to the original
works as well as the license that applies to that icon.

The SketchApp sources to the icon are also included in the
`dotVim/images/iconSources` folder.


The colorscheme in dotVim/colors/vimboxColorsDurintLoad.vim
was coppied from https://github.com/rakr/vim-one
and vendored just to show something nice while plugins load.

`dotVim/localBundle/json-ponyfill` was included from
[https://github.com/retorillo/json-ponyfill.vim.git](this project)(MIT).

The color utilities in `dotVim/localBundle/color-tools/` were combined from
[vim-one](https://github.com/rakr/vim-one) as well as
[vim-airline](https://github.com/vim-airline/vim-airline).


`box`: The included `box` script is included [from MacVim's
repo](https://github.com/macvim-dev/macvim/blob/6ff781f67eca346595b501c862dae12c3fca1e82/src/MacVim/mvim)
and retains its original license.


Inside of `./dotVim/localBundle/` is `python-3.7.0-embed-win32/` which contains
a snapshot of python 3 for 32 bit systems. The reason why this is included, is
because on Windows, the default GVim distribution is compiled for 32 bit
systems, but the version of Python often installed is 64 bit based and the two
won't work together. VimBox includes the right python out of the box so that
you can use popular plugins like UltiSnips on Windows and Mac.  Origin:
`https://www.python.org/ftp/python/3.7.0/python-3.7.0-embed-win32.zip`
