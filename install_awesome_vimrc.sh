#!/bin/sh
set -e

cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/vimrcs/my_configs.vim
catch
endtry' > ~/.vimrc

mkdir -p ~/.vim/ftplugin
ln -sf ~/.vim_runtime/vimrcs/python.vim ~/.vim/ftplugin/
ln -sf ~/.vim_runtime/vimrcs/cpp.vim ~/.vim/ftplugin/

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
