![VIM](https://dnp4pehkvoo6n.cloudfront.net/43c5af597bd5c1a64eb1829f011c208f/as/Ultimate%20Vimrc.svg)

# The Ultimate vimrc

This is my Vim configuration that I based on the fantastic work
[Amir Salihefendic](https://github.com/amix/vimrc) did.

I deal with Markdown, C++, QML, JavaScript and Python files most of the time. So
my configuration is tailored for those file types.

## How to install?

Install [Vundle](https://github.com/VundleVim/Vundle.vim) for plugin management.

```sh
git clone --depth=1 https://github.com/Furkanzmc/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install.sh
```

## How to uninstall

Just do following:

* Remove `~/.vim_runtime`
* Remove any lines that reference `.vim_runtime` in your `~/.vimrc`

## Configuring with Environment Variables

For easy manipulation of some configurations, the following environment variables
are used:

- `VIMRC_RUST_ENABLED`: Enables Rust support. Defaults to `0`.
- `VIMRC_SNIPPET_ENABLED`: Enables Ultisnip plugin. Defaults to `0`.
- `VIMRC_USE_VIRTUAL_TEXT`: Enables virtual text for LanguageClient-neovim.
  Defaults to `No`.
- `VIMRC_BACKGROUND`: Changes `background`. Defaults to `dark`.

## Screenshots

![screenshot1](https://drive.google.com/uc?export=download&id=1cIzNgh8WE0CMBB2gNDv34xNhXt1gc2fS)

![screenshot2](https://drive.google.com/uc?export=download&id=1VprQXbtXkiBoeQz7D1fka9L1VJ9ho9el)
