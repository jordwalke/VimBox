<h1>VimBox</h1>
<blockquote>Clean and Simple MacVim Editing</blockquote>

<table>
<tr>
<td>

<img src=".vim/images/VimBox.png" height=256 width=256 />
</td>
<td>

<ul>
  <li><h5>Mac Keyboard mappings</h5></li>
  <li><h5>Familiar autocomplete behavior</h5></li>
  <li><h5>JavaScript indentation and lint support</h5></li>
  <li><h5>Snippets (with JavaScript examples)</h5></li>
  <li><h5><a href="https://github.com/jordwalke/flatlandia/">Flatlandia</a> theme</h5></li>
</ul>
</td>
</tr>
</table>


> `VimBox` configures MacVim to behave like modern editors such as Sublime.


Screen Shot:
-------------
<img src="https://github.com/jordwalke/flatlandia/raw/master/images/flatlandia_completion.png" />



Installation:
-------------
> Quickly try VimBox in place of your existing setup. Back up your existing vim files, and move them out of the way as instructed:

1. Install HomeBrew if needed.

         http://brew.sh/

2. Install MacVim with lua/python support using HomeBrew:

        # Move any existing MacVim.app out of the way.
        mv /Applications/MacVim.app /Applications/MacVim_Backup.app
        brew install macvim --with-cscope --with-lua --python --HEAD
        brew linkapps    # Put the app in your /Applications directory

3. Back up your old .vim folder/files

        mv ~/.vim/ ~/.vim_backup/
        mv ~/.vimrc/ ~/.vimrc_backup/
        mv ~/.gvimrc/ ~/.gvimrc_backup/

4. Clone `VimBox` wherever you like to keep your github clones

        # cd ~/github/     # Or wherever you like to keep github clones
        git clone https://github.com/jordwalke/VimBox/
        ln -s ~/.vim ./VimBox/.vim   # Link to the clone
        ln -s ~/.vimrc ./VimBox/.vimrc
        ln -s ~/.gvimrc ./VimBox/.gvimrc
        # Now you can simply rebase in updates for `VimBox`

Optional Install:
-----------------
       
1. Install vim-airline font:
> You should install this font so that the `vim-airline` themes look decent (as in the screenshot).

        open Fonts/Inconsolata-dz+for+Powerline.otf
        # Click "Install Font"

2. Install node.js if you want JS features such as linting (http://nodejs.org/)


Features:
----------

####Familiar Window/Tab Key Commands

| Key          | Action        |
| ------------ |-------------|
| `⌘+n`       | New Tab        
| `⌘+shift+n`       | New Window  |
| `⌘+shift+t`       | Reopen Last Closed Tab   |
| `⌘+w`       | Close tab/split/window   |
| `⌘+s`       | Save file  |
| `⌘+enter`       | Special Distraction-Free FullScreen Mode|
| `⌘+e`       | Toggle File Explorer (Docked `NERDTree`) |
| `⌘+p`       | Open Anything (`ctrl-p`) |


####Airline/Flatlandia

Vim had a flat design Before It Was Cool. `VimBox` includes `vim-airline` and `flatlandia`.

####Braces and Pairs

- Inserting `{`, `[`, `'`, or `"` automatically inserts the closing character.
- When hitting enter with the cursor between two braces `{|}` the newline is formatted with an extra indentation.
- The behavior is identical to Sublime/Textmate.

####AutoComplete/Snippets

- Completions pop up automatically.
- Like Sublime, `VimBox` accepts highlighted entries via `tab` or `enter`.
- `tab` also triggers a snippet when applicable, and `tab` will allow "tabbing" through the snippet placeholders.
- Place custom snippets in `~/.vim/myUltiSnippets/`


####Distraction Free UI Tabs

- When not in full screen mode, Mac style metalic tabs are used.
- When in full-screen mode, those tabs become flat and blend into the background so you can focus on the code.


####One File, One Location

Included plugins are configured so that opening a file will always focus the window/tab/split where that file is already open. This is how most modern editors work.

####Control-P

`VimBox` includes `ctrl-p` and has been configured with keymappings that are consistent with its `NERDTree` keymappings.

| Key          | Action        |
| ------------ |-------------|
| `enter`      | opens a file in new tab or jump to existing window if already open |
| `c-s`        | opens a file in a vertical split or jump to existing window if already open |
| `c-h`        | opens a file in horizontal split or jump to existing window if already open |

###NERDTree

`NERDTree` is included and is configured to act as a left-nav bar (toggle it via `CMD+e`). Its keymappings have been configured to be consistent with `ctrl-p`.

| Key          | Action        |
| ------------ |-------------|
| `enter`      | opens a file in new tab or jump to existing window if already open |
| `s`          | opens a file in a vertical split or jump to existing window if already open |
| `h`          | opens a file in horizontal split or jump to existing window if already open |

####JavaScript Development

#####JavaScript Linting
- Excellent JavaScript indenting and inline linting with support for `JSX`.

<img src="https://github.com/jordwalke/VimJSXHint/raw/master/images/VimJSXHint.png" />

#####JavaScript Snippets
- JavaScript snippets are include, but you can add your own for any language you like

| Key          | Action        |
| ------------ |-------------|
| `for` `tab`  | `for` loop |
| `if`       | `if` statement|
| `forin` `tab`| `for`-`in` loop |
| `fun` `tab`| `function` definition |
| `lam` `tab`| lambda function |
| `try` `tab`| `try`/`catch` |
| `log` `tab`| `console.log` |
| `logo` `tab`| log stringified object to console |
| `tag` `tab`| `JSX` tag `<typeHere att={}></typeHere>`|
| `logo` `tab`| Many more including <a href="https://github.com/facebook/react">ReactJS</a> helpers |


#####JavaScript DocBlock Generator

The following key mapping generates docblock comments. `<tab>` will select the parameters in the generated docblock so you can edit the descriptions/types. Works with `ES6` functions.

| Key          | Action        |
| ------------ |-------------|
| `⌘+shift+c` | Generate JS Docblock  - when currsor is above a function| 


Plugin System:
---------

`VimBox` achieves its features through configuration of several plugins, but those should be considered implementation details of the `VimBox` distribution. `VimBox` uses modern editors as a "spec" for features and will configure several plugins in order to conform to that spec.

- You can add any plugin you like using the `NeoBundle` command.
- Edit `~/.vim/vimrc.custom.before` and `~/.vim/vimrc.custom.after`.
- `~/.vim/vimrc.custom.before` is executed before the stock plugins are configured.
- `~/.vim/vimrc.custom.after` is executed after the stock plugins are configured.
