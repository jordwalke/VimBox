

- Have mappings and keyboard settings generated from json files:
  - Allow that json config to be different per platform.
  - Allow "layering" so a vim distribution can have a base layer, then user,
    then project layer.

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

