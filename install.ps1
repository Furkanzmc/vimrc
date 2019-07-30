Push-Location ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/functions.vim
source ~/.vim_runtime/vimrcs/init.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim

' > ~/.vimrc

mkdir -p ~/.vim/pack/minpac/opt/
mkdir -p ~/.vim/ftplugin

if ($IsWindows) {
    git clone https://github.com/k-takata/minpac.git $env:USERPROFILE/.vim/pack/minpac/opt/minpac
}
else {
    git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
}

foreach ($file in Get-ChildItem -Path "~/.vim_runtime/vimrcs/filetypes/") {
    $fileName = Split-Path $file -Leaf
    New-Item -ItemType SymbolicLink -Target $file -Path ~/.vim/ftplugin/$fileName
}


if ($IsWindows) {
    New-Item -Force -ItemType SymbolicLink -Target $env:USERPROFILE/.vim_runtime/vimrcs/ginit.vim -Path $env:LOCALAPPDATA/nvim/ginit.vim
}

Pop-Location

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
