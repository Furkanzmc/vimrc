#!/bin/sh
set -e

cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry' > ~/.vimrc

mkdir -p ~/.vim/ftplugin
cp -f ~/.vim_runtime/python.vim ~/.vim/ftplugin/python.vim
cp -f ~/.vim_runtime/cpp.vim ~/.vim/ftplugin/cpp.vim

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
