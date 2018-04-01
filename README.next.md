
## VimBox Commands:

| Command                   | Action                                                   |
| ------------------------- |----------------------------------------------------------|
| `:Settings`               | Open All User Settings                                   |
| `:SettingsDefaults`       | Open All Default Settings                                |
| `:Rc`                     | Open `.vim` file generated from all `settings.json` files|
| `:Logs`                   | Open VimBox logs. Plugins can append to this log.        |
| `:Locations`              | Open VimBox logs. Plugins can append to this log.        |


# User Settings:

The `:Settings` command will open your personal user settings which are stored
in `~/.config/vim-box/user/settings.json`. This settings file can configure
other plugins, including the installation/disabling of other plugins, as well
as configure mappings.

The directory where your `settings.json` file lives is itself a vim plugin -
your own personal vim plugin. It isn't special except that it has the highest
priority. Like any plugin you can define custom utilities/functions/commands
but most people will get by with just editing the `settings.json` file.


## Configuration:

In VimBox, everything is modelled as a configurable plugin. All plugins can
include a `settings.json` file in their plugin root and VimBox will apply the
settings specified in it. Any plugin's included `settings.json` can configure
any other plugin. Your `settings.json` is just the configuration file for the
semi-special `user` plugin - and it can configure other plugins.

Popular vim packages like
[`airline`](https://github.com/vim-airline/vim-airline) are configurable as
VimBox plugins but there are also some other "built in plugins".


**built-in plugins:**
- `vimBox`: VimBox sees itself as a configurable plugin named `vim-box`.
  (Recall that "everything is a plugin" in VimBox - that includes VimBox
  itself).
- `vim`: Even vim itself is modeled as a plugin named `vim`. Configuring vim
  settings (such as `incsearch`) is done by configuring the plugin named `vim`.
- `installer`: The plugin which performs installing other plugins. Configuring
  this plugin results in the installation of other plugins.
- `disabler`: The plugin that can disable installation/configuration of other
  plugins.
- `user`: The special plugin that represents "your personal vim setup". It is
  located at `~/.config/vim-box/user/`. It is encouraged that you back this up
  using version control, share it with others on Github, and synchronized it
  between all machines you use.

Note that plugin names must not contain hyphens since those plugin names end up
becoming part of variable names. If a plugin is on github under a project name
like `vim-colors`, usually the "plugin name" in configuration will end up being
`vimcolors` or `vimColors`.


## The User Plugin

The user plugin, located at  `~/.config/vim-box/user/`

## Adding Local Plugins:

You can place other local plugins not obtained from Github in new directories
inside of `~/.config/vim-box/`. Enable them by adding an entry in your `:Settings`:

```json
"*": {
  "installer": {
    "config": {
      "yourPluginName": "file:~/.config/vim-box/someLocalPlugin/"
    }
  }
}
```

#### Why Are You Doing This? Don't You Know That If You Just Invest A Ton Of Time Into Learning All The Idiosyncrasies Of VimScript Then Vim Is Not That Bad?:

This vim distribution is not for you and that's okay. Vim is great, and once
you learn how to avoid all the pitfalls in configuring it, things work pretty
well. But for people just learning Vim all of that is very overwhelming and
most people have a hard time getting to that place before giving up and using
another editor (which not coincidentally typically has some `.json` based
configuration). VimBox just spits out a single plain, generated `.vimrc` file
which can later be maintained if you wish to abandon the more familiar `.json`
based configuration.


## Keyboard Paradigm:

The following Plugins provide the following "layers" of keyboard paradigms:
They can be individually disabled.

### Mega Escape

### Never Leave Insert:

In general there are several keys that allow you to never leave insert mode but
perform the same operations as when in normal mode. In general, the pattern to
remember is that if you normally do K in normal mode, you can hit `control-k`
in insert mode.

| Action                                       | Normal Mode:     | Insert Mode      |
|--------------------------------------------- | ---------------- | ---------------- |
| Enter newline above current line.            | `O`              | `<c-o>`          |
| Kill until end of current line.              | `K`              | `<c-k>`          |
| Join current line with next line.            | `J`              | `<c-j>`          |
