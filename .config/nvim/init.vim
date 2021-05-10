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
  \ 'coc-pairs',
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
set foldcolumn=1

" Set editor defaults
set mouse=a
set number
set numberwidth=5

" Open new split panes to right and below
set splitright
set splitbelow

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

" Map leader to comma
let mapleader = "," 

" Map Esc to tn
inoremap tn <Esc> 

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Turn terminal to normal mode with escape
tnoremap tn <C-\><C-n>

" Start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

function! OpenTerminal()
  split term://zsh
  resize 20
endfunction

nnoremap <C-j> :call OpenTerminal()<CR>

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


" Airline preferences
" ---------------------
"
let g:rigel_airline = 1
let g:airline_theme = 'rigel'
let g:airline_powerline_fonts = 1

" Elixir preferences
let g:mix_format_on_save = 1

" Keep syntax highlighting in sync in larger React files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" common editor actions
nmap <leader>rn <plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>qf <plug>(coc-fix-current)

" Show documentation
nnoremap <silent> H :call <sid>show_documentation()<cr>

function! s:show_documentation()
  if (CocHasProvider('hover'))
    call CocAction('doHover')
  endif
endfunction

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


" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
" vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
" vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" function! CmdLine(str)
"     call feedkeys(":" . a:str)
" endfunction 

" function! VisualSelection(direction, extra_filter) range
"     let l:saved_reg = @"
"     execute "normal! vgvy"

"     let l:pattern = escape(@", "\\/.*'$^~[]")
"     let l:pattern = substitute(l:pattern, "\n$", "", "")

"     if a:direction == 'gv'
"         call CmdLine("Ack '" . l:pattern . "' " )
"     elseif a:direction == 'replace'
"         call CmdLine("%s" . '/'. l:pattern . '/')
"     endif

"     let @/ = l:pattern
"     let @" = l:saved_reg
" endfunction

