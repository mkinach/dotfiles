" Custom settings for Vim

" Enable Vim features (don't force compatibility with vi)
set nocompatible

" Various settings needed for Vundle plugin manager
" (see https://github.com/VundleVim/Vundle.vim)
filetype off                  " required

" Set the runtime path to include Vundle and initialize
" Plugin files are located in ~/.vim/bundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle. All plugins must be after this line
Plugin 'VundleVim/Vundle.vim'

" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" All of your plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on

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

" Avoid saving backup files with ~ everywhere
set nobackup

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

" Allow case-insensitive search
set smartcase
set ignorecase

" Some special options for editing Fortran source code
let fortran_free_source=1
let fortran_do_enddo=1
filetype plugin indent on

" Fix colors on Vim via SSH
set background=dark
syntax on

" Fixes boldness problem on Vim via SSH
set t_Co=256       

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Make Vim load my .bashrc (so that aliases can be called from within Vim)
set shellcmdflag=-c

" Set wrapping length for gwip
" set textwidth=72

" Enable code folding based on syntax
set nofoldenable
set foldmethod=syntax
set foldnestmax=10
set foldlevel=2

" Define some aliases
command NN set nonumber
command SN set number
command SP set paste
command PATH echo expand('%:p')
command SPELL setlocal spell spelllang=en_CA
