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

" VimWiki
Plugin 'vimwiki/vimwiki'

" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" ======================================================================
call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on           " ignore plugin indent changes

" Some VimWiki settings
command COMPILEWIKI VimwikiAll2HTML
let g:vimwiki_key_mappings = { 'table_mappings': 0 }

" Some vim-airline settings
" see :help airline-customization, :help airline-configuration
set laststatus=2   " needed for basic functionality
set t_Co=256       
let g:airline_section_b = ''
let g:airline_section_c = '%0.30F'
let g:airline_section_y = ''
let g:airline_section_z = '%3p%% %3l/%L%3v'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme='mpk'

" Some netrw settings
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Enable Vim features (don't force compatibility with vi)
set nocompatible

" Avoid saving backup files all over the place
set nobackup

" Enable buffer switching without saving changes
set hidden

" Set line numbers on the left and a ruler on the bottom right
set number
set ruler

" Set custom tab behaviour
set smarttab
set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set backspace=2
set expandtab

" Automatically indent C code
set cindent

" Allow case-insensitive search
set smartcase
set ignorecase

" Some special options for editing Fortran source code (see https://gist.github.com/Sharpie/287445)
let fortran_free_source=1
let fortran_do_enddo=1
filetype plugin indent on

" Fix colors on Vim via SSH
set background=dark
syntax on
set t_Co=256       

" Open blank files in insert mode 
au BufNewFile * startinsert

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Enable code folding based on syntax
set nofoldenable
set foldmethod=indent
set foldnestmax=10
set foldlevel=2

" Define some aliases
command NN set nonumber!  " exclamation toggles the binary option
command SPELL setlocal spell spelllang=en_ca
command RO set readonly!
command WW set textwidth=72  " enable a word wrap
command NW set textwidth=0   " disable

" Color characters beyond the word wrap distance
highlight ColorColumn ctermbg=magenta ctermfg=black
call matchadd('ColorColumn', '\%73v', 100)
"set textwidth=72

" Define some general key remappings
" Here are some keys almost never needed (in normal mode): <Space> <CR> <BS> <F2>-<F10> <F12> -
let mapleader = "-"
" Copy to system clipboard:
vnoremap <Space> "+y
" Cut to system clipboard:
vnoremap <BS> "+d
" Paste from system clipboard (after cursor):
nnoremap \ "+p
" Paste from system clipboard (before cursor):
nnoremap \| "+P
" Open ~./vimrc for editing:
nnoremap <F2> :split $MYVIMRC<CR>
" Open ~./bashrc for editing:
nnoremap <F3> :split ~/.bashrc<CR>
" Open ~./bash_aliases for editing:
nnoremap <F4> :split ~/.bash_aliases<CR>
" Open ~/tmp/scratch.txt
nnoremap <F5> :split ~/tmp/scratch.txt<CR>
" Toggle spellchecker (see also stackoverflow.com/a/39539203):
nnoremap <F12> :setlocal spell! spelllang=en_ca<CR>
" Prevent single character deletion from yanking to default register:
nnoremap x "_x
" Paste the current date & time:
nnoremap <leader>t :pu=strftime('%c')<CR>kddo
" Execute shell command and show stdout/stderr in split window:
nnoremap <leader>s :term ++shell <CR>
" Toggle readonly mode:
nnoremap <leader>r :set readonly!<CR>
" Resize split windows:
nnoremap <silent> <c-k> :resize -1<CR>
nnoremap <silent> <c-j> :resize +1<CR>
nnoremap <silent> <c-h> :vertical resize -3<CR>
nnoremap <silent> <c-l> :vertical resize +3<CR>
" Switch between splits:
"nnoremap ` <c-w>W
nnoremap <tab> <c-w>W
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
" Open fzf to search for files:
nnoremap <leader>f :Files ~<CR>
" Open fzf to search for buffers:
nnoremap <leader>b :Buffers<CR>
" Write a line of dashes:
nnoremap <leader>l i------------------------------------------------------------------------<CR><ESC>
" Write a line of equals:
nnoremap <leader>q i========================================================================<CR><ESC>
