" Python indentation
au BufRead,BufNewFile *.py set tabstop=4|set softtabstop=4|set shiftwidth=4|set textwidth=100|set expandtab|set autoindent

" vim-flake8 Settings
" Auto run the flake8 when the file is saved
autocmd BufWritePost *.py call Flake8()

let g:flake8_show_in_gutter=1

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF



