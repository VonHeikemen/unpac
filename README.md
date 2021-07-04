# unpac

A thin wrapper around [minpac](https://github.com/k-takata/minpac) that adds some features of [vim-plug](https://github.com/junegunn/vim-plug/).

## Features

* Intuitive syntax.
* Offers convenient methods for lazy-loading.
* The order in which plugins are loaded can be determined in your vimrc.
* Plugins can be disabled by commenting out the line in which they appear in your vimrc.

## Getting started

### Installation

Just like minpac, unpac should be installed in the first directory in the `'packpath'` option. It is recommended that you follow minpac's instructions and use `pack/minpac/opt`.

#### Windows

* vim:

```
git clone https://github.com/k-takata/minpac.git %USERPROFILE%\vimfiles\pack\minpac\opt\minpac ^
&& git clone https://github.com/VonHeikemen/unpac.git %USERPROFILE%\vimfiles\pack\minpac\opt\unpac
```

* neovim:

```
git clone https://github.com/k-takata/minpac.git %LOCALAPPDATA%\nvim\pack\minpac\opt\minpac ^
&& git clone https://github.com/VonHeikemen/unpac.git %LOCALAPPDATA%\nvim\pack\minpac\opt\unpac
```

#### Linux, macOS

* vim:

```
git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac \
&& git clone https://github.com/VonHeikemen/unpac.git ~/.vim/pack/minpac/opt/unpac
```

* neovim  (use `$XDG_CONFIG_HOME` in place of `~/.config` if set on your system): 

```
git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac \
&& git clone https://github.com/VonHeikemen/unpac.git ~/.config/nvim/pack/minpac/opt/unpac
```

## Usage

* A simple example:

```vim
" Initialize unpac
packadd unpac

call unpac#init()

" Handle self updates
Pack 'k-takata/minpac', { 'type': 'opt' }
Pack 'VonHeikemen/unpac', { 'type': 'opt' }

Pack 'tpope/vim-sensible'

" Your favorite plugins ....
```

* Lazy-loading plugins

```vim
" Loaded when clojure file is opened
Pack 'tpope/vim-fireplace', { 'for': 'clojure' }

" Multiple file types
Pack 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Pack 'scrooloose/nerdtree', { 'command': 'NERDTreeToggle' }

" Multiple commands
Pack 'junegunn/vim-github-dashboard', { 'command': ['GHDashboard', 'GHActivity'] }

" Load vim-obsession after loading the session file
Pack 'tpope/vim-obsession', { 'event': 'SessionLoadPost' }
```

## Commands

| **Command** | **Description** |
| --- | --- |
| `Pack {url} [{options}]` | Register a plugin. This is meant to be used in your vimrc. It's an alias of the function `unpac#add` |
| `PackUpdate {name} [{options}]` | Install or update plugins. It's an alias of the function `unpac#update` |
| `PackClean [{name}]` | Remove unlisted plugins or selected plugin if `{name}` is provided. It's an alias of the function `unpac#clean`|
| `PackStatus` | Check the status of plugins. It's an alias of the function `unpac#status` |

## Functions

### unpac#init([{config}])

Initialize unpac and minpac. 

For more information about `{config}` checkout minpac's documentation: [minpac#init](https://github.com/k-takata/minpac#minpacinitconfig).

### unpac#add({url}[, {config}])

Register a plugin.

`{url}` is a URL of a plugin. It can be a short form (`'<github-account>/<repository>'`) or a valid git URL. If you use the short form, `<repository>` should not include the ".git" suffix.

`{config}` is a dictionary that takes everything [minpac#add](https://github.com/k-takata/minpac#minpacaddurl-config) might need plus a few option I have added.

* **type**

Now takes a new option called `init` which is the default value. This will cause the plugin to be installed in the `pack/minpac/opt` folder, but will load the plugin immediately using the built-in command `packadd`. This is to allow the user to choose the order in which the plugins are going to be loaded during vim's initialization process.

* **for**

It will create an `autocommand` that'll load the plugin when you enter a buffer of the given filetype. Uses the built-in function `packadd` to load the plugin.

* **command**

It makes sure to execute `packadd {plugin-name}` before calling the given command.

* **event**

Execute `packadd {plugin-name}` when the given event (or list of events) is triggered. For a complete list of events see [:help autocmd-events](https://vimhelp.org/autocmd.txt.html#autocmd-events)

### unpac#update([{name}[, {config}]])

Install or update all plugins or the specified plugin.

`{name}` is a unique name of a plugin (`plugin_name`).

If `{name}` is omitted or an empty String, all plugins will be installed or updated. Frozen plugins will be installed, but it will not be updated.

If `{name}` is specified, only specified plugin will be installed or updated. Frozen plugin will be also updated.
`{name}` can also be a list of plugin names.

For more information about `{config}` checkout minpac's documentation: [minpac#update](https://github.com/k-takata/minpac#minpacupdatename-config)

### unpac#clean([{name}])

Remove all plugins which are not registered, or remove the specified plugin.

### unpac#status([{config}])

Print status of plugins.

For more information about `{config}` checkout minpac's documentation: [minpac#status](https://github.com/k-takata/minpac#minpacstatusconfig)

## Support

If you find this plugin useful and want to support my efforts, [buy me a coffee ☕](https://www.buymeacoffee.com/vonheikemen).

[![buy me a coffee](https://res.cloudinary.com/vonheikemen/image/upload/v1618466522/buy-me-coffee_ah0uzh.png)](https://www.buymeacoffee.com/vonheikemen)

