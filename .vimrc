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
  let g:gruvbox_contrast_dark = "soft"

  "=======================
  "=>> Spacing
  "=======================
  set smarttab
  set expandtab
  set tabstop=4
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
  nnoremap <Leader>ss :sp %:h/
  nnoremap <Leader>vs :vsp %:h/

  "=======================
  "=>> Functions
  "=======================
  function! SortByLength() range
    execute a:firstline . "," . a:lastline . 's/^\(.*\)$/\=strdisplaywidth( submatch(0) ) . " " . submatch(0)/'
    execute a:firstline . "," . a:lastline . 'sort n'
    execute a:firstline . "," . a:lastline . 's/^\d\+\s//'
    call feedkeys("\<CR>")
  endfunction

  command -range Order <line1>,<line2>call SortByLength()


  "=======================
  "=>> Misc
  "=======================
  set timeout timeoutlen=200 ttimeoutlen=200

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
  nnoremap <Left> :N<CR>
  nnoremap <Right> :n<CR>
  vnoremap // y/<C-R>"<CR>

  " Fuzzyfinder
  nnoremap <C-g> :Rg<Cr>
  nnoremap <C-p> :Files<Cr>

  " Leader
  nnoremap <Leader>bb :ls<CR>:b<Space>
  nnoremap <Leader>bd :w<CR>:bd<Space>
  nnoremap <Leader>df :YcmCompleter GoToDefinition<CR>
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

      call dein#add('carlitux/deoplete-ternjs') " Javascript
      call dein#config('deoplete-ternjs', {
            \ 'do': 'npm install -g tern'
            \ })

      call dein#add('zchee/deoplete-jedi') " Python

      " Fuzzyfinder
      " call dein#add('Shougo/denite.nvim')
      call dein#add('/usr/local/opt/fzf')
      call dein#add('junegunn/fzf.vim')

      " Prettier
      call dein#add('prettier/vim-prettier')
      call dein#add('mindriot101/vim-yapf')

      " Auto Pairs
      call dein#add('jiangmiao/auto-pairs')
      
      " Shell Integration (Deol)
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
  "=>> Yapf
  "=======================
  nnoremap <leader>y :Yapf<cr>

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

  "=======================
  "=>> Denite
  "=======================
  "nnoremap <C-p> :Denite buffer file/rec<Cr>
  "
  "call denite#custom#var('file/rec', 'command',
        "\ ['rg', '--files', '--glob', '!.git'])
  " next line
  "call denite#custom#map('insert', '<C-j>',
        "\ '<denite:move_to_next_line>', 'noremap')
  " prev line
  "call denite#custom#map('insert', '<C-k>',
        "\ '<denite:move_to_previous_line>', 'noremap')
  " top
  "call denite#custom#map('insert', '<C-h>',
        "\ '<denite:move_to_top>', 'noremap')
  " bottom
  "call denite#custom#map('insert', '<C-l>',
        "\ '<denite:move_to_bottom>', 'noremap')
  " filter
  "call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
        "\ [ '.git/', '*.graphql.*', 'node_modules/',
        "\   'images/', '*.min.*', 'img/', 'fonts/'])
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
