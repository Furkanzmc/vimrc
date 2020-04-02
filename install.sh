#!/bin/sh
set -e

cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/functions.vim
source ~/.vim_runtime/vimrcs/init.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim

' > ~/.vimrc

mkdir -p ~/.vim/ftplugin
mkdir -p ~/.vim/pack/minpac/start/

ln -sf ~/.vim_runtime/vimrcs/filetypes/* ~/.vim/ftplugin/
ln -sf ~/.vim_runtime/vimrcs/plugins/zmc ~/.vim/pack/minpac/start/

git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
