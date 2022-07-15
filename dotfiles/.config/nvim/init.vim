" ------------- Config -------------

" Auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mcchrish/nnn.vim'
Plug 'itchyny/lightline.vim'
Plug 'drewtempelmeyer/palenight.vim'
call plug#end()

" Enable line numbers
set number
set ruler

" Enable syntax hilighting
syntax on

" Set number of tab spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Enable auto-indent
set autoindent

" Don't make noise
set visualbell

" Line wrap
set wrap

" Status line
set laststatus=2

" Highlight search results
set hlsearch
set incsearch

" auto + smart indent for code
set autoindent
set smartindent

" Mouse support
set mouse=a

" Disable backup files
set nobackup
set nowritebackup

" No delays
set updatetime=300

" Signcolumn
set signcolumn=number

" Echo area modifications
set cmdheight=1
set shortmess+=c

" Theme
colorscheme palenight

" -------------- Keybindings --------------

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" NNN picker
nnoremap <space>n :NnnPicker<enter>
let g:nnn#command = "NNN_TMPFILE=/home/$USER/.config/nnn/.lastd nnn -o"

" FZF picker
nnoremap <space>f :Files<enter>

" Navigate and create splits
nmap <space>v :split<enter>
nmap <space>g :vsplit<enter>
nmap <space>h <c-w>h
nmap <space>j <c-w>j
nmap <space>k <c-w>k
nmap <space>l <c-w>l
nmap <space>w <c-w>q

" Open terminal
nmap <space>c :term<enter>A
