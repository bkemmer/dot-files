set encoding=UTF-8

set nocompatible

" Disable netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" optionally enable 24-bit colour
set termguicolors
"
" Show line numbers.
set number
" Enable the onedark colors
packadd! onedark.vim

" Turn on syntax highlighting.
syntax on
colorscheme onedark

" Disable the default Vim startup message.
set shortmess+=I

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Filetype detection on (defaults on nvim")
filetype plugin indent on

" Mapping leader from / to Space
noremap <Space> <Nop>
map <Space> <leader>

" Alias to replace all to S
nnoremap S :%s//g<Left><Left>

" Tabs size
set expandtab
set shiftwidth=2
set tabstop=2

" No need to show the mode since it's displayed in the statusline
set noshowmode

" Open current window in a new tab | Use <C-W><C-Q> to go back
nnoremap <leader>wo  :tab split<CR>
" Shortcut for :tabnew
nnoremap <C-t> :tabnew<Space>

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>


" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Vim slime
let g:slime_target = "tmux" 
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}

" Vim lightline
let g:lightline                  = {}
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]} 
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}  
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.colorscheme = 'onedark'

" SO specific
if has('linux')
   set clipboard=unnamedplus
else
  set clipboard=unnamed  
endif

" Copilot
" packadd! copilot.vim

" Git signs
lua require('gitsigns').setup()
"autopairs
lua require("nvim-autopairs").setup()
" nvim tree
"lua require("nvim-tree").setup()

" Nvim-tree configs
" lua << EOL
" require("nvim-tree").setup({
"   sort = {
"     sorter = "case_sensitive",
"   },
"   view = {
"     width = 30,
"   },
"   renderer = {
"     group_empty = true,
"   },
"   filters = {
"     dotfiles = true,
"   },
" })
" EOL



lua << EOL
require("nvim-tree").setup({
        filters = {
          custom = { "^\\.git$", "\\.pyc$", "__pycache__" },
        },
        renderer = {
          special_files = {},
          icons = {
            show = {
              folder_arrow = false,
            },
            glyphs = {
              default = "",
              folder = {
                default = "",
                open = "",
                empty = "",
                empty_open = "",
              },
            },
          },
        },
        filters = {
          dotfiles = true,
          },
})
