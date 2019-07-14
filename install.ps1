Push-Location ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/functions.vim
source ~/.vim_runtime/vimrcs/init.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim

' > ~/.vimrc

mkdir -p ~/.vim/ftplugin

foreach ($file in Get-ChildItem -Path "~/.vim_runtime/vimrcs/filetypes/") {
    $fileName = Split-Path $file -Leaf
    New-Item -ItemType SymbolicLink -Target $file -Path ~/.vim/ftplugin/$fileName
}

Pop-Location

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
