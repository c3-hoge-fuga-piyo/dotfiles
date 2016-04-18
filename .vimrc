" NOTE: Skip initialization for 'vim-tiny' or 'vim-small'
if 0 | endif

" NOTE: In some cases, Vim is started in Vi compatibility mode.
if &compatible
  " vint: -ProhibitSetNoCompatible
 set nocompatible
  " vint: +ProhibitSetNoCompatible
endif

" Encodings {{{
if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif

" NOTE: Must be after modifying 'encoding'.
scriptencoding utf-8

set fileformat=unix
set fileformats=unix,dos,mac
"}}}

" Environment Variables {{{
let s:env = {}

let s:env.platform = {}
let s:env.platform.is_windows = has('win64') || has('win32')

let s:env.path = {}
let s:env.path.cache = empty($XDG_CACHE_HOME)
  \ ? expand('~/.cache')
  \ : $XDG_CACHE_HOME
let s:env.path.vimfiles = expand(s:env.platform.is_windows
  \ ? '~/vimfiles'
  \ : '~/.vim')

function! g:Environment() abort "{{{
  return s:env
endfunction "}}}
"}}}

" Plugins {{{
let s:env.path.dein = s:env.path.cache . '/dein'

let s:env.dein = {
  \ 'repo': 'https://github.com/Shougo/dein.vim',
  \ 'path': s:env.path.dein . '/repos/github.com/Shougo/dein.vim'}

if !isdirectory(s:env.dein.path)
  execute '!git clone' s:env.dein.repo s:env.dein.path
endif

set runtimepath&
execute 'set runtimepath^=' . s:env.dein.path

if dein#load_state(s:env.path.dein)
  call dein#begin(s:env.path.dein)
  call dein#add(s:env.dein.path)
  call dein#add('Shougo/vimproc.vim', {
      \ 'timeout': 1200,
      \ 'build': s:env.platform.is_windows
        \ ? 'tools\\update-dll-mingw'
        \ : 'make'})
  call dein#add('Shougo/context_filetype.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimfiler.vim',{
    \ 'depends': ['Shougo/unite.vim']})
  call dein#add('Shougo/neocomplete.vim', {
    \ 'if': has('lua'),
    \ 'lazy': 1,
    \ 'on_i': 1})

  call dein#add('vim-jp/vimdoc-ja')

  call dein#add('wakatime/vim-wakatime')

  call dein#add('editorconfig/editorconfig-vim', {
    \ 'if': has('python')})

  call dein#add('OmniSharp/omnisharp-vim', {
    \ 'if': has('python') && executable('mono'),
    \ 'timeout': 1200,
    \ 'lazy': 1,
    \ 'on_ft': ['cs'],
    \ 'build': s:env.platform.is_windows
      \ ? 'msbuild server/OmniSharp.sln'
      \ : 'xbuild server/OmniSharp.sln'})

  call dein#add('itchyny/lightline.vim')

  call dein#add('popkirby/lightline-iceberg', {
    \ 'depends': ['itchyny/lightline.vim']})

  call dein#add('thinca/vim-quickrun')
  call dein#add('thinca/vim-zenspace')
  call dein#add('thinca/vim-ft-help_fold', {
    \ 'lazy': 1,
    \ 'on_ft': ['help']})
  call dein#add('thinca/vim-prettyprint', {
    \ 'lazy': 1,
    \ 'on_cmd': ['PP', 'PrettyPrint'],
    \ 'on_func': ['PP', 'PrettyPrint']})

  call dein#add('osyo-manga/vim-precious', {
    \ 'depends': ['Shougo/context_filetype.vim']})
  call dein#add('osyo-manga/shabadou.vim', {
    \ 'depends': ['thinca/vim-quickrun']})
  call dein#add('osyo-manga/vim-watchdogs', {
    \ 'depends': [
      \ 'Shougo/vimproc.vim',
      \ 'thinca/vim-quickrun',
      \ 'osyo-manga/shabadou.vim']})
  call dein#add('osyo-manga/vim-anzu')

  call dein#add('cohama/vim-hier')
  call dein#add('cohama/vim-insert-linenr', {
    \ 'lazy': 1,
    \ 'on_i': 1})

  call dein#add('tpope/vim-dispatch')

  call dein#add('tyru/open-browser.vim')
  call dein#add('tyru/caw.vim')

  call dein#add('kannokanno/previm', {
    \ 'lazy': 1,
    \ 'on_cmd': ['PrevimOpen']})

  call dein#add('bronson/vim-trailing-whitespace')

  call dein#add('haya14busa/incsearch.vim')
  call dein#add('haya14busa/incsearch-fuzzy.vim', {
    \ 'depends': ['haya14busa/incsearch.vim']})
  call dein#add('haya14busa/incsearch-migemo.vim', {
    \ 'if': executable('cmigemo'),
    \ 'depends': [
      \ 'haya14busa/incsearch.vim',
      \ 'Shougo/vimproc.vim']})

  call dein#add('mhinz/vim-signify')

  " Color Schemes {{{
  call dein#add('cocopon/iceberg.vim')
  "}}}

  " Syntacies {{{
  call dein#add('elzr/vim-json')
  call dein#add('cespare/vim-toml')
  call dein#add('stephpy/vim-yaml')
  call dein#add('vim-scripts/ShaderHighLight')
  "}}}

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

augroup vimrc_dein-hooks
  autocmd!
augroup END

" Shougo/neocomplete.vim {{{
if dein#tap('neocomplete.vim')
  function! s:neocomplete_on_source() abort
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_camel_case = 1
    let g:neocomplete#enable_fuzzy_completion = 1
    let g:neocomplete#enable_auto_close_preview = 0
    let g:neocomplete#enable_auto_select = 0
    let g:neocomplete#enable_cursor_hold_i = 0

    let g:neocomplete#auto_completion_start_length = 2
    let g:neocomplete#manual_completion_start_length = 0

    let g:neocomplete#sources#omni#input_patterns = get(g:, 'neocomplete#sources#omni#input_patterns', {})
    let g:neocomplete#sources#omni#functions = get(g:, 'neocomplete#sources#omni#functions', {})

    " C# {{{
    let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'

    if dein#tap('omnisharp-vim')
      let g:neocomplete#sources#omni#functions.cs = 'OmniSharp#Complete'
    endif
    "}}}

    function! s:is_indent_requested() abort "{{{
      let l:prev = col('.') - 1
      return l:prev <= 0 || getline('.')[l:prev - 1] =~? '\s'
    endfunction "}}}

    " Keyboard Mapping {{{
    inoremap <expr> <TAB>
      \ pumvisible()
        \ ? "\<C-n>"
        \ : <SID>is_indent_requested()
          \ ? "<TAB>"
          \ : neocomplete#start_manual_complete()

    inoremap <expr> <S-TAB>
      \ pumvisible()
        \ ? "\<C-p>"
        \ : "\<C-d>"
    "}}}
  endfunction

  execute 'autocmd vimrc_dein-hooks User' 'dein#source#' . g:dein#name
    \ 'call s:neocomplete_on_source()'
endif
"}}}

" itchyny/lightline.vim {{{
if dein#tap('lightline.vim')
  let g:lightline = get(g:, 'lightline', {})
  let g:lightline.colorscheme = 'iceberg'
endif
"}}}

" thinca/vim-quickrun {{{
if dein#tap('vim-quickrun')
  let g:quickrun_config = get(g:, 'quickrun_config', {})

  let g:quickrun_config['_'] = {
    \ 'runner': 'vimproc',
    \ 'runner/vimproc/updatetime': 60}

  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
endif
"}}}

" osyo-manga/vim-watchdogs {{{
if dein#tap('vim-watchdogs')
  let g:watchdogs_check_BufWritePost_enable = 1

  let g:quickrun_config = get(g:, 'quickrun_config', {})

  let g:quickrun_config['watchdogs_checker/_'] = {
    \ 'watchdogs_checker/_': {
      \ 'outputter/quickfix/open_cmd': ''}}

  " Vim script {{{
  if executable('vint')
    let g:quickrun_config['vim/watchdogs_checker'] = {
      \ 'type': 'watchdogs_checker/vint'}
    let g:quickrun_config['watchdogs_checker/vint'] = {
      \ 'command': 'vint',
      \ 'exec': '%c %o %s:p',
      \ 'cmdopt': '--style-problem --color'}
  endif
  "}}}

  " C# {{{
  if executable('mcs')
    let g:quickrun_config['cs/watchdogs_checker'] = {
      \ 'type': 'watchdogs_checker/mcs'}
    let g:quickrun_config['watchdogs_checker/mcs'] = {
      \ 'command': 'mcs',
      \ 'exec': '%c %o %s:p',
      \ 'cmdopt': '--parse',
      \ 'quickfix/errorformat': '%f\\(%l\\,%c\\):\ error\ CS%n:\ %m'}
  endif
  "}}}

  " Shell script {{{
  if executable('shellcheck')
    let g:quickrun_config['sh/watchdogs_checker'] = {
      \ 'type': 'watchdogs_checker/shellcheck'}
    let g:quickrun_config['watchdogs_checker/shellcheck'] = {
      \ 'command': 'shellcheck',
      \ 'exec': '%c %o %s:p'}
  endif
  "}}}

  call watchdogs#setup(g:quickrun_config)
endif
"}}}

" bronson/vim-trailing-whitespace {{{
if dein#tap('vim-trailing-whitespace')
  let g:extra_whitespace_ignored_filetypes = [
    \ 'markdown',
    \ 'unite']
endif
"}}}

" haya14busa/incsearch.vim {{{
if dein#tap('incsearch.vim')
  let g:incsearch#auto_nohlsearch = 1
  " Keyboard Mapping {{{
  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)

  if dein#tap('vim-anzu')
    nmap n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
    nmap N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
    nmap * <plug>(incsearch-nohl)<Plug>(anzu-star-with-echo)
    nmap # <plug>(incsearch-nohl)<Plug>(anzu-sharp-with-echo)

    vmap n <plug>(incsearch-nohl-n)
    vmap N <plug>(incsearch-nohl-N)
    vmap * <plug>(incsearch-nohl-*)
    vmap # <plug>(incsearch-nohl-#)
  else
    map n <plug>(incsearch-nohl-n)
    map N <plug>(incsearch-nohl-N)
    map * <plug>(incsearch-nohl-*)
    map # <plug>(incsearch-nohl-#)
  endif

  map g* <plug>(incsearch-nohl-g*)
  map g# <plug>(incsearch-nohl-g#)
  "}}}
endif

" haya14busa/incsearch-fuzzy.vim {{{
if dein#tap('incsearch-fuzzy.vim')
  " Keyboard Mapping {{{
  map z/ <Plug>(incsearch-fuzzy-/)
  map z? <Plug>(incsearch-fuzzy-?)
  map zg/ <Plug>(incsearch-fuzzy-stay)
  "}}}
endif
"}}}
" haya14busa/incsearch-migemo.vim {{{
if dein#tap('incsearch-migemo.vim')
  " Keyboard Mapping {{{
  map m/ <Plug>(incsearch-migemo-/)
  map m? <Plug>(incsearch-migemo-?)
  map mg/ <Plug>(incsearch-migemo-stay)
  "}}}
endif
"}}}
"}}}

" elzr/vim-json {{{
if dein#tap('vim-json')
  let g:vim_json_syntax_conceal = 0
endif
"}}}
"}}}

" File Type Options {{{
augroup vimrc_filetype
  autocmd!

  " Default Options {{{
  autocmd FileType *
    \ setlocal
      \ formatoptions& formatoptions-=ro
      \ textwidth=0
      \ colorcolumn=80
      \ autoindent
      \ smarttab
      \ expandtab
      \ shiftwidth=2
      \ tabstop=2
      \ softtabstop=0
  "}}}

  " gitconfig {{{
  autocmd FileType gitconfig
    \ setlocal
      \ noexpandtab
  "}}}

  " C# {{{
  autocmd FileType cs
    \ setlocal
      \ foldmethod=syntax
      \ shiftwidth=4
      \ tabstop=4
  "}}}

  " Detection {{{
    autocmd BufNewFile,BufRead *.md
      \ setlocal
        \ filetype=markdown
  "}}}
augroup END
"}}}

" Color Scheme Options {{{
let s:env.colorscheme = {
  \ 'name': 'iceberg'}

if !has('gui_running')
  set t_Co=256
endif

function! s:env.colorscheme.source() abort "{{{
  " background {{{
  let l:current_background = &background
  let l:background = get(l:self, 'background', l:current_background)

  if l:background isnot l:current_background
    execute 'set background=' . l:background
  endif
  "}}}

  " colorscheme {{{
  let l:current_name = get(g:, 'color_name', 'default')
  let l:name = get(l:self, 'name', l:current_name)

  if l:name isnot l:current_name
    let l:colorschemes = map(
      \ split(globpath(&runtimepath, 'colors/*.vim'), '\n'),
      \ 'matchstr(v:val, ''.*[\/]\zs.*\ze\.vim'')')

    if index(l:colorschemes, l:name) >= 0
      execute 'colorscheme' l:name
    endif
  endif
  "}}}
endfunction "}}}

call s:env.colorscheme.source()
"}}}

" Vim Options {{{
set helplang=en,ja

set number
set relativenumber
set ruler
set nowrap
set cursorline
set scrolloff=8
set sidescrolloff=16
set backspace=indent,eol,start
set whichwrap=b,s,<,>,~,[,]
set laststatus=2
set showcmd
set wildmenu
set wildignorecase
set wildmode=list:full
set showmatch
set showmode
set virtualedit=block
set splitbelow splitright
set autoread

set nobackup noswapfile noundofile

set hlsearch
set wrapscan
set ignorecase
set smartcase
set incsearch

set list listchars=
  \eol:¶,
  \tab:▸\ ,
  \space:·,
  \extends:>,
  \precedes:<

if has('clipboard')
  set clipboard&

  if has('unnamedplus')
    set clipboard+=unnamedplus
  else
    set clipboard+=unnamed
  endif
endif
"}}}

" Keyboard Mapping {{{
let g:mapleader = "\<Space>"
nnoremap Q <Nop>

noremap ; :
noremap : ;

noremap j gj
noremap gj j
noremap k gk
noremap gk k
"}}}

" NOTE: Must be after modifying 'runtimepath'.
if !exists('g:syntax_on')
  syntax enable
endif

" vim: foldmethod=marker
