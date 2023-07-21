" ======================= Config =======================


" ------ Vim Settings ------

" faster updates!

" no hidden buffers

" automatically read on change

" no folds, ever

" For cool vim things

" Syntax highlighting

" Position in code

" Don't make noise

" default file encoding

" Line wrap

" Function to set tab width to n spaces
" ------ Theming ------

" let g:everforest_background = 'hard'
" let g:everforest_better_performance = 1
" colorscheme gruvbox


" ------ Plugin Options ------

" EasyMotion
" disable default mappings, turn on case-insensitivity
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" FZF
" enable history
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name build -o -name .cache \) -prune -o ! -type d -a -print'

" Auto-pairs
let g:AutoPairsFlyMode = 0


" ------ Language Specifics ------

" C, C++
" use clang-format formatter
au FileType cpp set formatprg=clang-format | set equalprg=clang-format
" colorcolumn 80
autocmd BufRead,BufNewFile *.c setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.h setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.cpp setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.hpp setlocal colorcolumn=80
" settab
" autocmd BufRead,BufNewFile *.c SetTab 4
" autocmd BufRead,BufNewFile *.h SetTab 4
" autocmd BufRead,BufNewFile *.cpp SetTab 4
" autocmd BufRead,BufNewFile *.hpp SetTab 4
" fix extra indentation on function continuation
set cino=(0,W4
