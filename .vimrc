"================================================
"=====>> Shared configuration
"================================================
function SharedConfiguration()
  set nocompatible
  set encoding=utf-8

  "=======================
  "=>> Colors
  "=======================
  syntax enable
  set background=dark
  let g:jsx_ext_required = 0
  
  " Gruvbox
  colorscheme gruvbox
  let g:gruvbox_invert_selection = 0
  let g:gruvbox_contrast_dark = "hard"

  "=======================
  "=>> Spacing
  "=======================
  set smarttab
  set expandtab
  set tabstop=2
  set shiftwidth=2
  set softtabstop=0
  set softtabstop=2
  set whichwrap+=<,>,h,l
  set backspace=eol,start,indent
  
  "=======================
  "=>> Performance
  "=======================
  set re=1
  set ttyfast
  set lazyredraw
  set noshowmatch
  set synmaxcol=128
  syntax sync minlines=256
  autocmd VimEnter * hi Normal ctermbg=none
  
  "=======================
  "=>> Interface
  "=======================
  set ruler
  set number relativenumber
  
  " Wildmenu
  set wildmenu
  set wildmode=longest:full,full
  
  " Search
  set hlsearch
  set showmatch
  set incsearch
  nnoremap <silent> <Leader>/ :nohlsearch<Cr>
  
  " Statusline
  set showcmd
  set belloff=all
  set cmdheight=1
  set laststatus=2
  set noshowmode " hides -- INSERT -- at the bottom
  
  "=======================
  "=>> Folding
  "=======================
  set foldenable
  set foldnestmax=10
  set foldlevelstart=10
  set foldmethod=marker

  "=======================
  "=>> Splits
  "=======================
  nnoremap <Leader>h :sp %:h/
  nnoremap <Leader>v :vsp %:h/

  "=======================
  "=>> Functions
  "=======================
  function! SortByLength() range
    execute a:firstline . "," . a:lastline . 's/^\(.*\)$/\=strdisplaywidth( submatch(0) ) . " " . submatch(0)/'
    execute a:firstline . "," . a:lastline . 'sort n'
    execute a:firstline . "," . a:lastline . 's/^\d\+\s//'
    call feedkeys("\<Cr>")
  endfunction

  command -range Order <line1>,<line2>call SortByLength()
  xnoremap <Leader>o :Order<Cr>

  "=======================
  "=>> Misc
  "=======================
  set timeout
  set timeoutlen=100
  set ttimeoutlen=100

endfunction


"================================================
"=====>> Vim8 Plugins
"================================================
function Vim8Plugins()
  " Automatic :PlugInstall
  if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
  endif

  call plug#begin('$HOME/.vim/plugged')
  
    Plug 'itchyny/vim-gitbranch'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    
    "=======================
    "=>> Fuzzyfinder (FZF)
    "=======================
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'
    command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
          \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
          \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
          \   <bang>0)
    
    "=======================
    "=>> Prettier
    "=======================
    Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn install',
      \ 'for': ['javascript', 'css', 'graphql'] }
    
    let g:prettier#autoformat = 0
    autocmd BufWritePre *.js,*.jsx,*.graphql,*.css PrettierAsync
    
    "=======================
    "=>> Linter (ALE)
    "=======================
    Plug 'https://github.com/w0rp/ale.git'
    
    let g:ale_linters = {
      \  'json': ['fixjson', 'jsonlint'],
      \   'vim': ['vint'],
      \  'javascript': ['eslint', 'prettier']
      \}
    let g:ale_sign_error = '✘'
    let g:ale_sign_warning = '⚠'
    let g:ale_fixers = {
      \  'html':      ['tidy'],
      \ 'markdown':   ['prettier'],
      \ 'reason':     ['refmt'],
      \ 'javascript': ['eslint'],
      \ }
    
    highlight ALEErrorSign ctermbg=NONE ctermfg=red
    highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
    let g:ale_echo_cursor = 0
    let g:ale_set_balloons = 1
    let g:ale_cursor_detail = 0
    let g:ale_sign_column_always = 1
    let g:ale_javascript_prettier_use_local_config = 1
    let g:ale_javascript_prettier_options = '--single-quote --trailing-comma none --parser flow --semi false --print-width 100'
    
    "=======================
    "=>> Lightline
    "=======================
    Plug 'itchyny/lightline.vim'
    let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'gitbranch#name'
        \ },
        \ }
    
    
    "=======================
    "=>> Lang (Polyglot)
    "=======================
    Plug 'sheerun/vim-polyglot'
    
    "=======================
    "=>> Autocompletion (YCM)
    "=======================
    
    Plug 'Valloric/YouCompleteMe'
    
    "=======================
    "=>> Themes
    "=======================
    
    Plug 'trevordmiller/nova-vim'
    Plug 'morhetz/gruvbox'

  call plug#end()
endfunction

"================================================
"=====>> Vim8 Configuration
"================================================
function Vim8Configuration()
  "=======================
  "=>> Bindings
  "=======================
  " agvi buffer
  nnoremap <Left> :N<Cr>
  nnoremap <Right> :n<Cr>
  vnoremap // y/<C-R>"<Cr>

  " Fuzzyfinder
  nnoremap <C-g> :Rg<Cr>
  nnoremap <C-p> :Files<Cr>

  " Leader
  nnoremap <Leader>bb :ls<Cr>:b<Space>
  nnoremap <Leader>bd :w<Cr>:bd<Space>
  nnoremap <Leader>df :YcmCompleter GoToDefinition<Cr>
endfunction

"================================================
"=====>> Neovim Plugins
"================================================
function NeovimPlugins()
  set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

  if dein#load_state('~/.cache/dein')
	call dein#begin('~/.cache/dein')
    call dein#add('~/.cache/dein')
      " Themes
      call dein#add('morhetz/gruvbox')
      call dein#add('trevordmiller/nova-vim')

      " Autocompletion
      call dein#add('Shougo/deoplete.nvim')
      call dein#config('deoplete.nvim', {
            \ 'lazy' : 1, 'on_i' : 1,
            \ })

      call dein#add('zchee/deoplete-jedi')
      call dein#add('carlitux/deoplete-ternjs')
      call dein#config('deoplete-ternjs', {
            \ 'do': 'npm install -g tern'
            \ })
	
      " Linting
      call dein#add('w0rp/ale')
      
      " Formatting
      call dein#add('prettier/vim-prettier')

      " Filetree
      call dein#add('Shougo/defx.nvim')

      " Statusline
      call dein#add('vim-airline/vim-airline')
      call dein#add('vim-airline/vim-airline-themes')

      " Fuzzyfilter
      call dein#add('/usr/local/opt/fzf')
      call dein#add('junegunn/fzf.vim')

      " Auto Pairs
      call dein#add('jiangmiao/auto-pairs')
      
      " Shell integration
      call dein#add('Shougo/deol.nvim')

      " Lang
      call dein#add('sheerun/vim-polyglot')

      call dein#end()
    call dein#save_state()
  endif

  if dein#check_install()
    call dein#install()
  endif
endfunction

"================================================
"=====>> Neovim Configuration
"================================================
function NeovimConfiguration()
  "=======================
  "=>> Dein
  "=======================
  nnoremap <Leader>du :call dein#update()<Cr>
  
  "=======================
  "=>> Deoplete
  "=======================
  let g:deoplete#enable_at_startup = 1

  "=======================
  "=>> Prettier
  "=======================
  let g:prettier#autoformat = 1
  autocmd BufWritePre *.js,*.jsx,*.graphql,*.css PrettierAsync

  "=======================
  "=>> Airline
  "=======================
  let g:airline_theme = 'gruvbox'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#ale#enabled = 1

  "=======================
  "=>> Ale
  "=======================
  let g:ale_sign_error = '✗'
  let g:ale_sign_warning = '⚠'
  let g:ale_sign_column_always = 1
  let g:ale_linters = {
        \  'vim': ['vint'],
        \  'jsx': ['eslint'],
        \  'json': ['fixjson', 'jsonlint'],
        \  'javascript': ['eslint', 'prettier'],
        \  'python': ['pycodestyle', 'flake8', 'pylint'],
        \}
  let g:ale_fixers = {
        \ 'reason': ['refmt'],
        \ 'python': ['autopep8', 'yapf', 'isort'],
        \ }
  
   nnoremap <Leader>l :ALEFix<Cr>

  "=======================
  "=>> Defx
  "=======================
  let g:vimfiler_as_default_explorer = 1

  autocmd FileType defx call s:get_defx_settings()
  nnoremap <C-b> :Defx -split=vertical -winwidth=50 -direction=topleft -toggle=true<Cr>

  "=======================
  "=>> Fzf
  "=======================
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
        \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
        \   <bang>0)

  let g:fzf_layout = { 'window': 'enew' }
  let g:fzf_layout = { 'window': '-tabnew' }
  let g:fzf_layout = { 'window': '30split enew' }
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  let g:fzf_buffers_jump = 1


  nnoremap <C-g> :Rg<Cr>
  nnoremap <C-p> :Files<Cr>
endfunction

"================================================
"=====>> Initialize .vimrc
"================================================
function Initialize()
  let g:mapleader=" "

  if has('nvim')
    call NeovimPlugins() 
    call NeovimConfiguration()
  else
    call Vim8Plugins()
    call Vim8Configuration()
  endif
  call SharedConfiguration()
endfunction

call Initialize()


"================================================
"=====>> Defx settings
"================================================
function! s:get_defx_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <Cr>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
endfunction
