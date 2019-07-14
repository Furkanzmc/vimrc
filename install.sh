#!/bin/sh
set -e

cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/functions.vim
source ~/.vim_runtime/vimrcs/init.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim

' > ~/.vimrc

mkdir -p ~/.vim/ftplugin
ln -sf ~/.vim_runtime/vimrcs/* ~/.vim/ftplugin/

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
