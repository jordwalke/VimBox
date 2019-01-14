Include Copy Of esy-bash with VimBox
------------------------------------

- Automatically set the shell to:

    let &shell = 'C:\\Program Files\\Git\\git-cmd.exe --command=usr/bin/bash.exe -l -i'

Ejected entire plugins/config into one generated Vimrc
------------------------------------------------------

Customizing/Writing Plugins:
----------------------------
- `:execute x`  will run the command x as if you had done `:x`.
- When writing scripts/plugins always use the `normal!` mode because it will
  let you express movements that don't take into account user specific
  mappings.
- Make all your function names start with a capital letter.

**Plugin Layout:**
- Consult [Vim Script The Hard
  Way](http://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- **`pluginRoot/plugin/`**: Run once when he plugin loads (which means once
  when Vim starts up).
- **`pluginRoot/ftdetect/`**: Sets up autocommands that detect/set `filetype`s.
  Tiny files. Vim automatically wraps these `.vim` files in autocommand groups
  so no worries about registering multiple autocommand listeners.
- **`pluginRoot/ftplugin/`**:
  - When `filetype` is set to `xyz`, all plugins' `pluginRoot/ftplugin`
    directories are searched for `xyz.vim`.
  - Alternatively, you could create a directory `pluginRoot/ftplugin/xyz` which
    contains many `.vim` files.
  - Run every time a file's `filtetype` is set to matching name, so only set
    buffer local variables. Perhaps consider augroups that are resilient to
    being run multiple times since you can re-set the filetype.
- **`pluginRoot/indent/`**:
  Uses the same naming convention as ftplugin. Should also only set buffer
  local data. Basically the same as `ftplugin`.
- **`pluginRoot/compiler/`**:
  Basically the same as `ftplugin`/`indent` but for compiler related options.
- **`pluginRoot/after/`**:
  Just like `pluginRoot/plugin/` but occurs after all plugins' `plugin/`
  scripts are run. It's like a z-index "second round" hack in the plugin
  loading phases (see Vim Script The Hard Way).
- **`pluginRoot/autoload/`**:
  Lazily loaded code. Requires that functions abide by a special naming
  convention.
  - running `:call somefile#Hello()` or `somefile#Hello()` causes vim to search
    for some `pluginRoot/autoload/somefile.vim`, lazily load the vim file, then
    it will search for a function defined as:

      function somefile#Hello()
        " ...
      endfunction
  - The `#` symbols can be used to embed files more deeply in the `autoload`
    directories.
  - **IMPORTANT:** The contents surrounding functions in the `autoload/` files
    are executed every time vim loads a new `somefile#Hello()` function that
    wasn't in its cache. Don't put code outside of `#` functions in these
    files.


- **`pluginRoot/doc/`**:



- Have mappings and keyboard settings generated from json files:
  - Allow that json config to be different per platform.
  - Make all mappings use "noremap".
  - Allow "layering" so a vim distribution can have a base layer, then user,
    then project layer.
  - Allows bug-free reloading, at least of mappings.
    - Records every mappings so that they can be unmapped.
  - Vim already supports mapping specificity but only has a couple of levels:
    - http://learnvimscriptthehardway.stevelosh.com/chapters/11.html
    - Buffer specific mappings win out over global mappings.
    - Perhaps that means you can create a config of the form: and then
      automatically set up buffer local mappings for each filetype change
      event.

        mappings: {
          "*": {
          },
          "reason": {
          },
        }
- All autocommands should be of the form:
  - The `autocmd!` will make sure the group is replaced if resourced.

    augroup testgroup
        autocmd!
        autocmd BufWrite * :echom "Cats"
    augroup END

- Make keyboard shortcuts match Atom/Nuclide

  - Cmd+d for "diagnostics", Cmd+shift+d for global diagnostics.
  - Cmd+r for open file (or file(.html)) in dedicated Chrome Instance (with cross origin) or focus it in existing dedicated Chrome instance and "refresh" it.
    - Cmd+R ^ that but also run build.
  - Cmd+p for fuzzy find overlay.
  - Since Cmd+g/Cmd+shift+g is search next/previous.
    - Set ctrl+g/ctrl+shift+g to be next/previous error.

- Appropriately themed progress loading bar when installing plugins.
  - Check for updates upon start.
- Stop assuming all files/config are located at ~/.vim
  - Create variable representing "the default install location"
  - Create variable representing "where user plugins are configured/installed"
  - Copy from default install to the user install location.

- Fix the incorrect initial left nav size when opening before focusing for the
  first time.

- NERDTree doesn't find existing file open in existing split.

- Autodetect installed fonts and choose symbols (powerline and other) based on
  heuristic. Possibly even auto-*install* a font when prompting the user.

- Include this font for free by default since it works well with powerline and
  resembles PragmataPro: https://be5invis.github.io/Iosevka/

- Make Toggly an actual plugin and then configure its keys in standard
  keys file.
  - Togglist should toggle location list *per* window.

- Use a configuration for keyboard mappings instead of having them be spread
  everywhere.
  - Get a JSON parser in pure Vim somewhere.

- Go through every D-X/Y/Z mapping and reset them to noop. Right now, Vim
  inserts <D-C> (or ^Z for control+z) into the buffer for unmapped keys. What
  kind of madness is this. Imagine how confusing that is for a noob.

