Push-Location ~/.vim_runtime

if (Test-Path ~/.vimrc) {
    Copy-Item -Path ~/.vimrc -Destination ~/.vimrc.orig
}

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/functions.vim
source ~/.vim_runtime/vimrcs/init.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim

' > ~/.vimrc

New-Item -Force -ItemType Directory -Path ~/.vim/pack/minpac/opt/
New-Item -Force -ItemType Directory -Path ~/.vim/pack/minpac/start/
New-Item -Force -ItemType Directory -Path ~/.vim/ftplugin
New-Item -Force -ItemType Directory -Path ~/.vim/ftdetect

if ($IsWindows) {
    git clone https://github.com/k-takata/minpac.git $env:USERPROFILE/.vim/pack/minpac/opt/minpac
}
else {
    git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
}

foreach ($file in Get-ChildItem -Path "~/.vim_runtime/ftplugin/") {
    $fileName = Split-Path $file -Leaf
    New-Item -Force -ItemType SymbolicLink -Target $file -Path ~/.vim/ftplugin/$fileName
}

foreach ($file in Get-ChildItem -Path "~/.vim_runtime/ftdetect/") {
    $fileName = Split-Path $file -Leaf
    New-Item -Force -ItemType SymbolicLink -Target $file -Path ~/.vim/ftplugin/$fileName
}

foreach ($folder in Get-ChildItem -Path "~/.vim_runtime/vimrcs/plugins/" -Directory) {
    $name = $folder.Name
    New-Item -Force -ItemType SymbolicLink -Target $folder.FullName -Path ~/.vim/pack/minpac/start/$name
}

if ($IsWindows) {
    New-Item -Force -ItemType SymbolicLink -Target $env:USERPROFILE/.vim_runtime/vimrcs/ginit.vim -Path $env:LOCALAPPDATA/nvim/ginit.vim
}

Pop-Location

echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
