lua require("plugins")

" Enable 24bit true color
set termguicolors

" Enable the theme
syntax enable
colorscheme rigel
set noshowmode
set cursorline

" Setup code folding
set foldmethod=indent
set foldlevel=99
set foldcolumn=1

" A little mourse never hurt anyone
set mouse=a

" Display relative line numbers, with absolute line number for current line
set number
set numberwidth=5
set relativenumber

" Open new split panes to right and below
set splitright
set splitbelow

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases
set hlsearch  " Highlight search results
set incsearch " Makes search act like search in modern browsers
set lazyredraw " Don't redraw while executing macros (good performance config)
set magic " For regular expressions turn magic on
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs ;)

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

set history=500 " Sets how many lines of history VIM has to remember
set hidden

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Map leader to comma
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Map Esc to tn
inoremap tn <Esc>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>
map <leader>t<leader> :tabnext<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>pp :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Turn terminal to normal mode with escape
tnoremap tn <C-\><C-n>

" Moving lines
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


" Elixir preferences
let g:mix_format_on_save = 1

" Keep syntax highlighting in sync in larger React files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

"
" Airline preferences
" ---------------------
"
let g:rigel_airline = 1
let g:airline_theme = 'rigel'
let g:airline_powerline_fonts = 1

"
" COC Preferences
" ---------------------
"
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

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Rename Symbol
nmap <leader>rn <Plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>qf <Plug>(coc-fix-current)

" Show documentation
nnoremap <silent> H :call <sid>show_documentation()<cr>

function! s:show_documentation()
  if (CocHasProvider('hover'))
    call CocAction('doHover')
  endif
endfunction

"
" Goyo preferences
" ---------------------
"
nnoremap <silent> <C-k> :Goyo<CR>

let g:goyo_width = 150

"
" Hop preferences
" ---------------------
"
map <silent> s :HopWord<CR>
map <silent> <Leader>p :HopPattern<CR>
nmap <silent> <Leader>s :HopChar1<CR>
nmap <silent> <Leader>ss :HopChar2<CR>
map <silent> <Leader>l :HopLine<CR>

"
" NVIM Tree preferences
" ---------------------
"
let g:nvim_tree_width = 35
let g:nvim_tree_auto_close = 1
let g:nvim_tree_follow = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_highlight_opened_files = 1

nnoremap <C-b> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Telescope preferences
" ---------------------
"
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

lua << EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {'node_modules', 'dist'},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
EOF
