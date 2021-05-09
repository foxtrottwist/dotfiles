call plug#begin('~/.vim/plugged')

" Language Client
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" coc extensions
let g:coc_global_extensions = [
  \ 'coc-elixir',
  \ 'coc-emmet',
  \ 'coc-eslint',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-json',  
  \ 'coc-prettier',
  \ 'coc-tsserver',
  \ 'coc-yaml'
  \ ]

" Theming
Plug 'Rigellute/rigel'

" Language support ~ Ruby
Plug 'vim-ruby/vim-ruby'

" Language support ~ Elixir
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim'
Plug 'mhinz/vim-mix-format'

" Language support ~ Rust
Plug 'rust-lang/rust.vim'

" Language support ~ Swift
Plug 'toyamarinyon/vim-swift'

" Language support ~ Front-End
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx']}
Plug 'jparise/vim-graphql'

" File Explorer with Icons
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

" File Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'

Plug 'junegunn/goyo.vim'

call plug#end()

"""" enable 24bit true color
set termguicolors

"""" enable the theme
syntax enable
colorscheme rigel
set noshowmode
set cursorline

" Setup code folding
set foldmethod=indent
set foldlevel=99

" Set editor defaults
set mouse=a
set number

" map leader to comma
let mapleader = "," 

"
" NERDTree preferences
" ---------------------
"
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle NerdTree
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" This supposedly hides the brackets in NERDTree
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

"
" FZF preferences
" ---------------------
"
nnoremap <C-p> :Files<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" For ignoring gitignore files requires silversearcher-ag 
" https://github.com/ggreer/the_silver_searcher
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

"
" Goyo preferences
" ---------------------
"
nnoremap <silent> <C-k> :Goyo<CR>

let g:goyo_width = 150

"
" Easymotion preferences
" ---------------------
"
" <Leader>n{char} to move to {char}
map  <leader>n <plug>(easymotion-bd-f)
nmap <leader>n <plug>(easymotion-overwin-f)

" Move to line
map <leader>L <plug>(easymotion-bd-jk)
nmap <leader>L <plug>(easymotion-overwin-line)

" Move to word
map  <leader>w <plug>(easymotion-bd-w)
nmap <leader>w <plug>(easymotion-overwin-w)

" open new split panes to right and below
set splitright
set splitbelow

" Airline preferences
" ---------------------
"
let g:rigel_airline = 1
let g:airline_theme = 'rigel'
let g:airline_powerline_fonts = 1


" Elixir preferences
let g:mix_format_on_save = 1

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" Keep syntax highlighting in sync in larger React files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Show documentation
function! s:show_documentation()
  if (CocHasProvider('hover'))
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> H :call <sid>show_documentation()<cr>

" Show diagnostics, otherwise documentation, on hold
" function! ShowDocIfNoDiagnostic(timer_id)
"   if (CocHasProvider('hover'))
"     if (coc#float#has_float() == 0)
"       silent call CocActionAsync('doHover')
"     endif
"   endif
" endfunction

" function! s:show_hover_doc()
"   call timer_start(500, 'ShowDocIfNoDiagnostic')
" endfunction

" autocmd CursorHoldI * :call <sid>show_hover_doc()
" autocmd CursorHold * :call <sid>show_hover_doc()

" common editor actions
nmap <leader>rn <plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>qf <plug>(coc-fix-current)

