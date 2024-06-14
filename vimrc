set nocompatible
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
set showcmd
set foldmethod=syntax

set sw=4
set ts=4

set backspace=indent,eol,start

autocmd FileType make setlocal noexpandtab
autocmd FileType kconfig setlocal noexpandtab
autocmd FileType c setlocal noexpandtab tabstop=8 shiftwidth=8
autocmd FileType kconfig setlocal noexpandtab tabstop=8 shiftwidth=8
autocmd BufRead,BufNewFile *.h,*.c set filetype=c
autocmd FileType gitcommit setlocal spell

set wildoptions=fuzzy,pum
set wildchar=<Tab> wildmenu wildmode=full

set formatoptions+=mM

""
"For Emacs-style editing on the command-line: >
""

" start of line
cnoremap <C-A>		<Home>
" back one character
cnoremap <C-B>		<Left>
" delete character under cursor
cnoremap <C-D>		<Del>
" end of line
cnoremap <C-E>		<End>
" forward one character
" (Use vim normal mode instead)
" cnoremap <C-F>		<Right> 
" recall newer command-line
cnoremap <C-N>		<Down>
" recall previous (older) command-line
cnoremap <C-P>		<Up>
" back one word
cnoremap <Esc><C-B>	<S-Left>
" forward one word
cnoremap <Esc><C-F>	<S-Right>


" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Allow saving of files as sudo when I forgot to start vim using sudo.
" https://stackoverflow.com/a/7078429
cmap w!! w !sudo tee > /dev/null %

let g:ale_linters = {'verilog' : ['verilator'],
\ 'haskell' : ['hls'], 'rust': ['analyzer'],
\ 'systemverilog' : ['verilator']}
let g:ale_haskell_hls_executable = '/usr/bin/haskell-language-server'
let g:ale_linter_aliases = {"PKGBUILD": ['sh']}
""
" Verilog
""
let g:formatdef_istyle = '"iStyle"'

let g:formatdef_verible = '"verible-verilog-format --column_limit=80 --indentation_spaces=4 -"'
let g:formatters_systemverilog = ['verible']
let g:formatters_verilog = ['verible']

""
" C
""
let g:ale_c_clangtidy_checks = ['*', '-altera*', '-llvmlibc*']

""
"Python
""
let g:formatters_python = ['black']

""
" PKGBUILD (pacman-contrib)
""
let g:formatters_PKGBUILD = ['shfmt']

""
" Themes and plugins 
""
let g:vimwiki_list = [{'path': '~/docs/vimwiki',
\ 'path_html': '~/docs/vimwiki_html',
\ 'auto_toc': 1,
\ 'auto_diary_index': 1,
\ 'auto_generate_links': 1,
\ 'auto_generate_tags': 1,
\ 'template_path': '~/.vimwiki/',
\ 'template_ext': '.html'}]

let g:vimwiki_auto_header = 1
let g:vimwiki_toc_header_level = 2

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

set termguicolors

set background=dark
let g:palenight_terminal_italics=1
let g:palenight_color_overrides = {'white': { 'gui' : '#FFFFFF', "cterm":"15", "cterm16": "7" }}

function DarkTheme()
    let g:airline_theme = "palenight"
    colorscheme palenight
endfunction

function LightTheme()
    let g:airline_theme = "papercolor"
    colorscheme PaperColor
endfunction

au User LumenLight call LightTheme()
au User LumenDark call DarkTheme()

if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >

" Disable wakatime by default
if $wakatime_enable
    autocmd VimEnter * echo "Wakatime enabled."
else
    let g:loaded_wakatime = 1
endif

" Autoformat
noremap <leader>f :Autoformat<CR>

" fzf
noremap <leader><space>f :Files<CR>
noremap <leader><space>b :Buffers<CR>
noremap <leader><space>w :Windows<CR>

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:UltiSnipsSnippetDirectories=['mysnippet']

" mouse
noremap <leader>m :set mouse=a<CR>:set ttymouse=xterm2<CR>

" zoom.vim
let g:zoom#statustext="zoom"
call airline#parts#define_function('zoom', 'zoom#statusline')
let g:airline_section_b = airline#section#create_left(['hunks', 'branch', 'zoom'])
