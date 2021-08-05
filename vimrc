set cursorline
syntax enable
set expandtab
set tabstop=4
set smartindent
set autoread
inoremap jj <ESC>
set nu
set incsearch
set updatetime=100

set nocompatible
filetype plugin on

let g:vimwiki_list = [{'path': '~/OneDrive/Sync/vimwiki',
\ 'path_html': '~/OneDrive/Sync/vimwiki_html',
\ 'auto_toc': 1,
\ 'auto_diary_index': 1,
\ 'auto_generate_links': 1,
\ 'auto_generate_tags': 1,
\ 'template_path': '~/.vimwiki/',
\ 'template_ext': '.html'}]

let g:vimwiki_auto_header = 1
let g:vimwiki_toc_header_level = 2


set sw=4
set ts=4

:set backspace=indent,eol,start

autocmd FileType make setlocal noexpandtab

" Allow saving of files as sudo when I forgot to start vim using sudo.
" https://stackoverflow.com/a/7078429
cmap w!! w !sudo tee > /dev/null %

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

set termguicolors

set background=dark
let g:palenight_terminal_italics=1
let g:palenight_color_overrides = {'white': { 'gui' : '#FFFFFF', "cterm":"15", "cterm16": "7" }}

let g:airline_theme = "palenight"

colorscheme palenight

if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
