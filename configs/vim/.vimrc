" Custom settings for Vim

" Source other Vim settings
let g:dotfiles_path = fnamemodify(resolve(expand("~/.vimrc")), ":p:h:h:h")
for vim_file in glob(g:dotfiles_path . "/tmp/*vimrc", 0, 1)
    execute "source " . vim_file
endfor

" Various settings needed for Vundle plugin manager
" (see https://github.com/VundleVim/Vundle.vim)
filetype off                  " required

" Set the runtime path to include Vundle and initialize
" Plugin files are located in ~/.vim/bundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" =========================== VUNDLE PLUGINS ===========================
" Let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" vimwiki
Plugin 'vimwiki/vimwiki'

" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" vimspector
Plugin 'puremourning/vimspector'

" ALE
Plugin 'dense-analysis/ale'

" YouCompleteMe
Plugin 'ycm-core/YouCompleteMe'

" vim-ollama
Plugin 'gergap/vim-ollama'
" ======================================================================
call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on           " ignore plugin indent changes

" Some vimwiki settings
command COMPILEWIKI VimwikiAll2HTML
let g:vimwiki_key_mappings = { 'table_mappings': 0 }

" Some vim-airline settings
" see :help airline-customization, :help airline-configuration
set laststatus=2   " needed for basic functionality
let g:airline_section_c = airline#section#create_right(['%0.30F ','readonly'])
let g:airline_section_y = ''
let g:airline_section_z = '%3p%% %3l/%L %v'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline_disable_statusline = 0
let g:airline_theme='mpk'

" Some vimspector settings
" (see https://github.com/puremourning/.vim-mac/blob/master/vimspector-conf/configurations/macos/)
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'vscode-bash-debug' ]
let g:vimspector_enable_mappings = 'HUMAN'

" Some ALE settings
let g:ale_fixers = {
\   '*': [ 'remove_trailing_lines', 'trim_whitespace' ],
\   'sh': [ 'shfmt' ],
\   'python': [ 'ruff' , 'yapf' ],
\   'c': [ 'clang-format' ],
\}
let g:ale_python_flake8_options = '--max-line-length=90'
let g:ale_sign_priority=9  " needed to prevent priority clash (see https://github.com/puremourning/vimspector/issues/231)
"highlight ALEError ctermbg=red
highlight ALEWarning ctermbg=lightblue ctermfg=black
highlight ALEInfo ctermbg=magenta ctermfg=black
"highlight ALEVirtualError ctermbg=red
"highlight ALEVirtualWarning ctermbg=yellow

" Some YouCompleteMe settings
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/global_extra_conf.py'

" Some netrw settings
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Enable Vim features (don't force compatibility with vi)
set nocompatible

" Avoid saving backup files all over the place
set nobackup

" Enable buffer switching without saving changes
set hidden

" Remember cursor column position when switching buffers
if has("autocmd")
  augroup RememberCursorPosition
    autocmd!
    autocmd BufLeave * let b:winview = winsaveview()
    autocmd BufEnter * if exists('b:winview') | call winrestview(b:winview) | endif
  augroup END
endif

" Set line numbers on the left and a ruler on the bottom right
set number
set ruler

" Set custom tab behaviour
filetype plugin indent on
set smarttab
set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set backspace=2
set expandtab

" Automatically indent C code (may cause text reflow issues; disable cinwords to fix)
"set cindent
set cinwords=

" Some special options for editing Fortran source code (see https://gist.github.com/Sharpie/287445)
let fortran_free_source=1
let fortran_do_enddo=1

" Allow case-insensitive search
set smartcase
set ignorecase

" Fix colors on Vim via SSH
set background=dark
syntax on
set t_Co=256

" Fix colors in popups
highlight Pmenu ctermbg=black ctermfg=white
highlight PmenuSel ctermbg=white ctermfg=black
highlight PmenuSbar ctermbg=black

" Fix other colors (see :hi and :help hi and :so $VIMRUNTIME/syntax/hitest.vim)
highlight WarningMsg ctermfg=red
highlight SpellLocal ctermfg=black
highlight VertSplit ctermbg=white ctermfg=235
highlight TabLineFill ctermbg=235 ctermfg=235
highlight SignColumn ctermbg=235 ctermfg=235
highlight MatchParen ctermbg=red ctermfg=white
highlight DiffDelete ctermfg=red
highlight Ignore ctermfg=DarkBlue

"" Set persistent undo
"set undofile
"set undodir=$HOME/.vim/undo  " this directory must already exist!
"set undolevels=1000
"set undoreload=10000

" Open blank files in insert mode
au BufNewFile * startinsert

" When editing a file, always jump to the last known cursor position
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Enable code folding based on syntax
set nofoldenable
set foldmethod=indent  " indent, syntax, marker, manual
set foldnestmax=10
set foldlevel=2

" Define some aliases
command NN set nonumber!                " exclamation toggles the binary option
command RO set readonly!
command WW set wrap | set textwidth=72  " enable a word wrap
command NW set wrap | set textwidth=0   " disable a word wrap
command NVW set nowrap                  " disable a visual word wrap
set textwidth=0                         " disable word wrap by default

" Color characters beyond the word wrap distance
"highlight ColorColumn ctermbg=magenta ctermfg=black
"call matchadd('ColorColumn', '\%73v', 100)
"set textwidth=72

" Color trailing whitespace
autocmd VimEnter * :highlight TrailingSpaces ctermbg=red guibg=red | :match TrailingSpaces /\s\+$/

" Define some general key remappings
" Here are some keys almost never needed (in normal mode): <Space> <CR> <BS> <F2>-<F10> <F12> -
let mapleader = ";"
" Copy to system clipboard:
vnoremap <Space> "+y
" Cut to system clipboard:
vnoremap <BS> "+d
" Paste from system clipboard (after cursor):
nnoremap \ "+p
" Paste from system clipboard (before cursor):
nnoremap \| "+P
" Prevent single character deletion from yanking to default register:
nnoremap x "_x
" Toggle spellchecker (see also stackoverflow.com/a/39539203):
nnoremap <F1> :setlocal spell! spelllang=en_ca<CR>
" Paste the current date & time:
nnoremap <leader>t :pu=strftime('%c')<CR>kddo
" Open terminal from within Vim:
let g:default_terminal = 'konsole'
"nnoremap <leader>s :execute 'silent !'.g:default_terminal .' &'<CR>
nnoremap <leader>s :call system('nohup '.g:default_terminal.' > /dev/null 2>&1 &')<CR>:redraw!<CR>
" Toggle readonly mode:
nnoremap <leader>r :set readonly!<CR>
" Resize split windows:
nnoremap <silent> <s-k> :resize -1<CR>
nnoremap <silent> <s-j> :resize +1<CR>
nnoremap <silent> <s-h> :vertical resize -3<CR>
nnoremap <silent> <s-l> :vertical resize +3<CR>
" Navigate between splits:
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-l> :wincmd l<CR>
" Remap default repeat keybinding:
nnoremap <leader><leader> .
" Remap default join keybinding:
nnoremap <S-t> J
" Switch between buffers:
nnoremap , :bp<CR>
nnoremap . :bn<CR>
" Delete current buffer (note that  is special char for <C-/>):
nnoremap  :bd<CR>
" List all buffers:
nnoremap <C-m> :ls<CR>
" Quickly enter buffer commands:
nnoremap <C-b> :b
" Open netrw:
nnoremap <leader>e :Explore<CR>
" Write a line of dashes:
nnoremap <leader>- :put! =repeat('-', 72)<CR>
" Write a line of equals:
nnoremap <leader>= :put! =repeat('=', 72)<CR>
" Set vimspector breakpoint:
nnoremap <F9> :VimspectorToggleBreakpoint<CR>
" Launch vimspector/continue to next breakpoint:
nnoremap <F5> :VimspectorContinue<CR>
" Close vimspector:
nnoremap <F2> :VimspectorReset<CR>
" Access popups in vimspector:
noremap <leader><CR> <Plug>VimspectorBalloonEval
" Toggle ALE:
nnoremap <leader>1 :ALEDisable<CR>
nnoremap <leader>2 :ALEEnable<CR>
" Run ALEFix in the current buffer:
nnoremap <leader>3 :ALEFix<CR>
" Move to next ALE error:
nnoremap <Tab>   :ALENext<CR>
nnoremap <S-Tab> :ALEPrevious<CR>
" Find symbols via YouCompleteMe:
nnoremap <leader>4 <Plug>(YCMFindSymbolInDocument)
nnoremap <leader>5 <Plug>(YCMFindSymbolInWorkspace)
" Toggle hover menu in YouCompleteMe:
nnoremap <leader>6 <Plug>(YCMHover)
