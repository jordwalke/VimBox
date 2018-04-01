# VimBox Layered Config

Proposal for a convention for progressively enhancing plugins, with
extensibility in mind.

Result:
If plugins abide by this convention then:
- Plugin configuration will be discoverable, easily configured,
  merged/defaulted, and extensible by the user or other plugins.
- Plugin configuration will show up on a config summary page.
- The user will receive an explanation about *why* a configuration value was
  determined (was it a plugin default, or was it overridden by user
  customization? Was that override given priority due to the filetype/scope
  etc?)
- Plugin config and mappings will be tweakable withour requiring a restart.
- Plugins could be notified of config changes without having to poll (maybe the
  restart-the-world approach is better though.)
- Plugins and the user may then use a well defined configuration
  defaulting/lookup for global and buffer local plugin settings, in the same
  way that getbufvar() acts for vim settings (it defaults to buffer before
  consulting global vim setting - but doesn't work for custom vim plugin
  variables).

Configuration files are organized at their top level by scope, followed by
plugin names. The `"*"` scope is the global scope which means that the plugin
is loaded and configured for all file types. Scopes such as `"reason"` will
ensure that the plugin is only loaded and configured

Any plugin can override another plugin's configuration and you as the user get
to decide which plugins have priority over others. Each plugin section in a
configuration specifies information about that plugin, its capabilities and its
customizability.

- **`settings`**: Defines new *settings* for configuration. Each setting has a
  name, description, and may also include a value which will act as the
  default.
  These setting values (or anything else) can be overridden by by other
  plugins, or by the implicit "user plugin".
- **`actions`**: Named operations that can be invoked and registered.
- **`mappings`**: Key mappings.
  - `mappedTo` can be any of:
    - `pluginName.settings.foo`: Pseudo mapping.
    - `pluginName.actions.theAction`: Perform an action
  - `mappedToKey` maps to a key sequence.

A plugin `my-plugin`, will typically have a `Config.json` that configures
`myPlugin`. It may also specify config for _other_ plugins as well, which
will override that other plugin's config. This example `my-plugin/Config.json`
configures its own plugin `myPlugin`, but also overrides some configuration
from another plugin named `otherPlugin`.

```json
{
  "*": {
    "myPlugin": {
      "settings": {
        "color": {
          "description": "Description of color setting",
          "possibleValues": [{"value": "blue"}, {"value": "red"}],
          "value": "blue"
        },
      },
      "actions": {
        "greet": {
          "description": "Greets the user",
          "do": ["Reformat()"]
        },
        "abstractAction": {
          "description": "Abstract action left unimplemented",
        }
      },
      "mappings": [
        modes: ["insert", "normal"]
        key: "cmd+g",
        mappedTo: "action:myPlugin.actions.greet"
      ]
    },
    "otherPlugin": {
      "settings": {
        "background": {
          "value": "dark"
        },
      },
    }
  }
}
```

There is a shortcut for overriding `settings.x.value` in configuration. In the
previous example, the `"otherPlugin"` portion could be replaced with:

```
"otherPlugin": {
  "settings": {
    "background": "dark"
  },
}
```

## A Couple Of Special Plugins
There are a couple of "special" plugins that implicitly exist without ever
needing to depend on them.
- "The Vim Plugin" is an implicit plugin that you can "configure", and when
  doing so just passes that configuration to underlying vim.
- The "VimBox Plugin" `/path/to/vim-box/built-in-plugins/vim-box/`. This plugin
  actually does exist, and ships by default with VimBox. You can
  override/customize settings for this plugin like any of the other plugins you
  depend on. It includes a lot of built in functionality for managing your vim
  plugins and config.
- The "User Plugin". `~/.vim-box/user/`. This plugin exists by default and is
  fairly empty out of the box. Think of this plugin as the place to put all the
  config you wouldn't ever want to share with anyone else. Users customize
  VimBox by changing the contents of this plugin, which can override some of
  the defaults from other plugins, and create their own mappings. This is the
  directory you should commit to version control.

In `~/.vim-box/user/Config.json` you can define your own
settings/actions/mappings and then use them with their own scripts. To
configure typical vim settings, you override that "special Vim Plugin"'s
settings'. The other important configuration placed in
`~/.vim-box/user/Config.json`, is overridding/customizing the `vim-box` built
in plugin's settings - specifically the `dependencies` list which specifies
which other plugins to install. Here's an example `~/.vim-box/user/Config.json`
which does all of these things.

```json
{
  "*" : {
    "user": {
      "settings": {
        "workingFromHome": {
          "description": "Whether or not I'm on a VPN connection.",
          "value": false
        },
      },
      "mappings": [
        modes: ["insert", "normal"]
        key: "cmd+g",
        mappedTo: ":echo 'Greetings!'"
      ]
    },
    "vimBox": {
      "dependencies": [
        "jordwalke/vim-one": true,
        "jordwalke/vim-airline": { "branch': "AirlineOnTop" }
      ]
    },
    "vimAirline": {
      "settings": {
        "airline_powerline_fonts": true
      }
    },
    "vim": {
      "settings": {
        "background": "dark",
        "colorscheme": "vim-one"
      },
    }
  }
}
```

## Note On Overridding:

Overridding is different than allowing multiple plugins to set the same
variables/settings because the override is determined *statically*. This allows
the `vim-one` colorscheme to also configure the setting
`"vim.settings.colorscheme": "vim-one"`, which the user can then override to
something else, without the colorscheme being temporarily set to `vim-one`
before the users' prefered choice.

Any time a config value is changed, we can (tbd) completely undo all the
previous configuration settings/mappings (because we have a complete record of
them) and then redo them with the new settings (without restarting Vim).

## Reading And Setting Configuration At Runtime:
A plugin Config.json will be loaded every time the editor starts up and the
settings/actions/mappings are registered with VimBox.
The settings become global variables which you can inspect.
`myPlugin.settings.xyz` becomes the global variable `g:myPlugin#config#xyz`. They
become globally readable varaibles for your convenience - do not set these
global variables yourself.  Instead use the appropriate setters:

```vim
:Config myPlugin.settings.xyz "value"
```
Or if in VimScript:
```vim
Config("myPlugin.settings.xyz", "value")
```

Plugins themselves may read at runtime by using
`GetConfig(configName, default)`.

You can invoke actions by doing:
```
:Action myPlugin.actions.greet
```
Or from within VimScript:
```
Action('myPlugin.actions.greet')
```
## TODO: Subscribing:

Another reason to have a central config negotiator, is to allow plugins to
subscribe to changing configuration variables. This isn't yet implemented, but
should be added.

## Config Relying On Other Config:

Your config value key can specify how the value should be interpretted.
- `:eval`: Eval the code in VimScript. This would allow you to read other
  config values as well via `GetConfig()`.

```
"settings": {
  "myPlugin.settings.settingXyz:eval": "GetConfig('otherPlugin.settings.foo')"
},
```

## Abstract Configuration:

The config follows a very simple, and explicit convention.
The JSON key path that you specify in calls like
`GetConfig('myPlugin.settings.width')` map directly to the `Config.json` file
structure. Actions also follow the same very predictable form
`Action('myPlugin.actions.greet')`.
But it was no coincidence that the `Config.json` file for `my-plugin` had to
specify a top level key `myPlugin`. It was actually because
`my-plugin/Config.json` can and often needs to specify actions and settings for
other plugins.

For example, a plugin called `codecodeformat` might define its `Config` as
follows:

```json
{
  "*": {
    "codeFormat": {
      "settings": {
        "width": {
          description: "Formatting width",
          "value": 80
        },
      },
      "actions": {
        "reformat": {
          "description": "Reformats the document",
        },
      }
    },
  }
}
```

This plugin's `Config.json` doesn't implement any text reformatting, but it
does specify an action `codeFormat.actions.reformat`, as well as a
configuration variable `codeFormat.settings.width`. Why would anyone make a
plugin with this configuration when it does nothing? The answer is that it is a
named extensibility point for *many* arbitrary an unanticipated plugins to
coordinate around.

Any other plugin that wants to know how wide the document will be reformatted
at knows they can call `GetConfig('codeFormat.settings.width')`.
Furthermore, any other plugin is capable of implementing the
`codeFormat.settings.reformat` action which has (up until now) been left
unimplemented ("abstract").

Here's how another plugin `markdown-formatter/Config.json` would fulfill the
role of the abstract action in addition to specifying its own config.

```json
{
  "*": {
    "markdownFormatter": {
      "settings": {
        "someOtherRandomThing": {
          description: "Not Important Here"
        },
      }
    },
    "codeFormatter": {
      "actions": {
        "reformat": {
          "do": "MarkdownFormatNow()"
        },
      },
    },
    "vim": {
      "setttings": {
        "conceallevel": 2
      }
    }
  }
}
```

Notice that `markdown-formatter/Config.json` specifies an entirely other
section called `codeFormatter`, after its own section to override the
"abstract" action. It also configures Vim's `conceallevel` option since the
markdown plugin takes advantage of that (suppose it's true).

If the user installs both plugins, then a call to
`Action('codeFormatter.actions.reformat')` will call `MarkdownFormatNow()`, and
inside of `MarkdownFormatNow()`, `markdown-formatter`, will query
`Config('codeFormatter.settings.width')` to know which width to use. Also,
vim's `conceallevel` setting will be adjusted to `2`.

The user can then add this to their `~/.vim-box/user/Config.json` file to
depend on both plugins as well as setup one keyboard shortcut that will format
using `codeFormatter.actions.reformat`, regardless of which plugin actually
implements the formatting.


```json
{
  "*": {
    "user": {
      "mappings": [
        modes: ["insert", "normal"]
        key: "cmd+shift+c",
        mappedTo: "codeFormatter.actions.reformat"
      ]
    },
    "vimBox": {
      "dependencies": [
        "jordwalke/code-formatter": true,
        "jordwalke/markdown-formatter": true
      ]
    },
  }
}
```

## But The FileTypes!

There's a couple of problems.
1. The `vim` `conceallevel` setting was applied to all filetypes, not just
   markdown files.
2. Usually, one single plugin couldn't possibly know how to reformat an
   arbitrary filetype.

What we want is for the `markdown-formatter` to only apply its
config/overrides when markdown files are loaded. In fact, we want to depend on
many plugins, each that implement the `codeFormatter.actions.reformat` action
for their respective file types, but maintain the constraints that:
- The `user/Config.json` only sets one keyboard mapping.
- The `codeFormatter` plugin doesn't need to predict all the various kinds of
  file types/plugins that will want to implement code formatting.
- No Vim settings are set in a heavy handed way for *all* file types.

VimBox config provides a way!

The `markdownFormatter` plugin can specify that some or all of its config
should only apply to markdown files - all config/settings will therefore will
be applied at the *buffer* level instead of global level.

To do so, we change the outer scope from `"*"` (any filetype) to `"markdown"`.
We can however also combine that markdown specific config with other settings
that we *do* want to remain global as shown here.
```json
{
  "*": {
    "markdownFormatter": {
      "settings": {
        "someGlobalValue": {
          "value": "globalValue"
        },
      }
    },
  },
  "markdown": {
    "codeFormatter": {
      "settings": {
        "someLocalValue": {
          "value": "globalValue"
        },
      }
    },
    "codeFormatter": {
      "actions": {
        "reformat": {
          "do": "MarkdownFormatNow()"
        },
      },
    },
    "vim": {
      "setttings": {
        "conceallevel": 2
      }
    }
  }
}
```

Now, whenever the user calls `:Action('codeFormatter.actions.reformat')` it
will only run `MarkdownFormatNow()` if that file is a markdown file.
Furthermore, the `vimconceallevel` setting is only set on markdown files at a
per buffer level.

The configuration also set a globally scoped setting called `someGlobalValue`,
and a markdown filetype scoped setting called `someLocalValue`.

If the user (or another plugin) were to load this plugin and call
`:GetConfig('markdownFormatter.settings.someGlobalValue')` it would return
`globalValue`, regardless of the file type currently focused. But if the user
(or a plugin) called `:GetConfig('markdownFormatter.settings.someLocalValue')`
in a `.js` file, it would return undefined, but if called in a `.md` file it
would return `localValue`.


The user would then typically install many formatters, each handling their own
filetypes, but still only has to specify a single keyboard mapping to know that
they can reliably format any of them. The `codeFormatter` plugin initially
seemed overly abstract, but ended up solving this extensibility problem very
well.

```json
{
  "*": {
    "user": {
      "mappings": [
        modes: ["insert", "normal"]
        key: "cmd+shift+c",
        mappedTo: "codeFormatter.actions.reformat"
      ]
    },
    "vimBox": {
      "dependencies": [
        "jordwalke/code-formatter": true,
        "jordwalke/markdown-formatter": true,
        "jordwalke/reason-formatter": true,
        "jordwalke/js-formatter": true,
      ]
    },
  }
}
```

## How Do Plugins Get Loaded?

## Refering To Other Plugins Config From Within Config:
- Filetype driven reads from non-filetype config should still work.

## Overwriting Other Plugins Config:

#### Monkeypatching:

#### Implementing Abstract Behavior
