colorscheme onedark
" Map CtrlP shortcut
let g:ctrlp_map = '<c-p>'
set nu

" Autoclose YCM completion window
let g:ycm_autoclose_preview_window_after_completion=1
" Add shortcut for go to decleration
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

" Access system clipboard on macOS.
set clipboard=unnamed
" Hide the default show mode because I'm using lightline
set noshowmode
