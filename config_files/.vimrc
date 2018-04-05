" modeline
" vi: sw=2 ts=2 sts=2 et cc=80
" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
"set some mac terminal/handling options - should add a detection for GUI/shell
"vim to this before uncommmenting - Matt
"set term=builtin_beos-ansi "could probably do xterm-256colors but meh

" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
" set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
if has('nvim')
  set backupdir=~/.config/nvim/backups
  set directory=~/.config/nvim/swaps
  if exists("&undodir")
          set undodir=~/.config/nvim/undo
  endif
else
  set backupdir=~/.vim/backups
  set directory=~/.vim/swaps
  if exists("&undodir")
          set undodir=~/.vim/undo
  endif
endif

set viminfo+=! " make sure vim history works
map <C-J> <C-W>j<C-W>_ " open and maximize the split below
map <C-K> <C-W>k<C-W>_ " open and maximize the split above
set wmh=0 " reduces splits to a single line 

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Make sure that filetype plugins are enabled
filetype plugin on
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" use spaces not tabs by default (pythonic)
set tabstop=4 sw=4 softtabstop=4 et
" Enable line numbers
set number
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
"set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Respect modeline in files
set modeline
set modelines=4
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" set number of history lines
set history=1000
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" Set folding options / preferences.
set foldmethod=syntax
" If you want to enable folding by default, uncomment below...
" set foldenable
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" Strip trailing whitespace (,ss)
function! StripWhitespace()
        let save_cursor = getpos(".")
        let old_query = getreg('/')
        :%s/\s\+$//e
        call setpos('.', save_cursor)
        call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
" ===========================================================================
" NOTE: I disabled this because I want to use the JSON syntax rather than the
" javascript syntax.  This is because JSON is ever-so-slightly different than
" javascript.  It does not allow unquoted dictionary keys.  It does not allow
" the last pair in an object to have a trailing comma.
" ===========================================================================
" if has("autocmd")
"         " Enable file type detection
"         filetype on
"         " Treat .json files as .js
"         autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
" endif
"anything installed by pathogen after this
call pathogen#infect()
call pathogen#helptags()

" #wsgi/python new file buffer for wsgi script
au BufNewFile,BufRead *.wsgi set filetype=python
" Set default template for new userscripts.
aug new_templates
    au!
    if has('nvim')
      au BufNewFile *userscript*.js 0r ~/.config/nvim/templates/userscript.js
      au BufNewFile *node*.js 0r ~/.config/nvim/templates/nodetmpl.js
      au BufNewFile *test*.py 0r ~/.config/nvim/templates/utesttmpl.py
      au BufNewFile *main*.py 0r ~/.config/nvim/templates/maintmpl.py
    else
      au BufNewFile *userscript*.js 0r ~/.vim/templates/userscript.js
      au BufNewFile *node*.js 0r ~/.vim/templates/nodetmpl.js
      au BufNewFile *test*.py 0r ~/.vim/templates/utesttmpl.py
      au BufNewFile *main*.py 0r ~/.vim/templates/maintmpl.py
    endif
aug END
" TODO: add template for new python scrips of various types when you feel like
" coding it out

" Set color scheme!¬
colorscheme 0x7A69_dark
colorscheme OceanicNext
" Bufexplorer
let g:bufExplorerSplitBelow=1        " Split new window below current.
set spr " set splitright to default
set splitbelow " open h-splits below current buff
let g:pymode_rope_completion=0


" for now disable eclim unless explicit

" text wrapping and visual queue
set colorcolumn=+1
" set default mapping for vim-pydocstring
autocmd FileType python setlocal ts=4 sw=4 sts=4 et cc=80
autocmd FileType python nnoremap <c-s-y>  :Pydocstring<cr>
" temporary function for python docstring width of 72
function! GetPythonTextWidth()
    if !exists('g:python_normal_text_width')
        let normal_text_width = 79
    else
        let normal_text_width = g:python_normal_text_width
    endif

    if !exists('g:python_comment_text_width')
        let comment_text_width = 72
    else
        let comment_text_width = g:python_comment_text_width
    endif

    let cur_syntax = synIDattr(synIDtrans(synID(line("."), col("."), 0)), "name")
    if cur_syntax == "Comment"
        return comment_text_width
    elseif cur_syntax == "String"
        " Check to see if we're in a docstring
        let lnum = line(".")
        while lnum >= 1 && (synIDattr(synIDtrans(synID(lnum, col([lnum, "$"]) - 1, 0)), "name") == "String" || match(getline(lnum), '\v^\s*$') > -1)
            if match(getline(lnum), "\\('''\\|\"\"\"\\)") > -1
                " Assume that any longstring is a docstring
                return comment_text_width
            endif
            let lnum -= 1
        endwhile
    endif

    return normal_text_width
endfunction

" replace with syntastic python3
augroup pep8_textwidth
    au!
    autocmd CursorMoved,CursorMovedI * :if &ft == 'python' | :exe 'setlocal textwidth='.GetPythonTextWidth() | :endif
augroup END

set statusline+=%#warningmsg#
" syntastic doc recommended config.  
" use airline and ALE instead
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_python_python_exec = '/Users/magregor/.virtualenvs/neovim2/bin/python'
let g:syntastic_python_checkers=['flake8']
"let g:syntastic_python_flake8_exec='/usr/local/bin/python'
let g:syntastic_python_flake8_exec='/Users/magregor/.virtualenvs/neovim2/bin/python'
let g:syntastic_python_flake8=['-m', 'flake8']
" Use the following syntax to disable specific error codes in flake8
" let g:syntastic_python_flake8_args='--ignore=E501,E225'
let g:syntastic_python3_python_exec = '/Users/magregor/.virtualenvs/neovim3/bin/python'
let g:syntastic_python3_checkers=['flake8']
"let g:syntastic_python3_flake8_exec='/usr/local/bin/python'
let g:syntastic_python3_flake8_exec='/Users/magregor/.virtualenvs/neovim3/bin/python'
let g:syntastic_python3_flake8=['-m', 'flake8']
" Use the following syntax to disable specific error codes in flake8
" let g:syntastic_python3_flake8_args='--ignore=E501,E225'
let syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:SuperTabClosePreviewOnPopupClose = 1
autocmd CompleteDone * pclose
" jhint javascript
let g:syntastic_javascript_checkers = ['jshint']

" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction

" search selected
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" MacVim transparency
" if has("gui_running")
"     set transparency=10
" endif

" Function to pass selected text (SQL) to oracle
function! Oracle() range
  echo system('~/src/utils/py3oracleutil.py '.shellescape(join(getline(a:firstline, a:lastline), '\n')).'| pbcopy')
endfunction
com! -range=% -nargs=0 Oracall :<line1>,<line2>call Oracle()
" Function to pass selected text (SQL) to oracle
function! Wikit() range
  echo system('wikit '.shellescape(join(getline(a:firstline, a:lastline), '\n')).'| pbcopy')
endfunction
com! -range=% -nargs=0 Wikit :<line1>,<line2>call Wikit()

" Nvim terminal mode:
noremap <Esc> <C-\><C-n>
" Nvim python environment settings
if has('nvim')
  let g:python_host_prog='/Users/magregor/.virtualenvs/neovim2/bin/python'
  let g:python3_host_prog='/Users/magregor/.virtualenvs/neovim3/bin/python'
endif
" configure python-language-server through vim-lsp so it can be used by ale
" tsserver for typescript
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server', '--stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript'],
        \ })
endif
" tsserver for python through pyls IFF using vim-lsp, but there are issues
" if executable('pyls')
  " pip install python-language-server
"   au User lsp_setup call lsp#register_server({
"       \ 'name': 'pyls',
"       \ 'cmd': {server_info->['pyls']},
"       \ 'whitelist': ['python'],
"       \ })
"   autocmd FileType python nnoremap <buffer><silent> <c-]>  :LspDefinition<cr>
"   autocmd FileType python nnoremap <buffer><silent> K :LspHover<cr>
  " autocmd FileType python setlocal omnifunc=lsp#complete
" endif
" uncomment for asyncomplete
" let g:asyncomplete_remove_duplicates = 1
if has('nvim')
  " Use deoplete for auto-completion.  Best choice.
  " Temp disable while checking ALE w/ omnicomplete and tsserver through pyls
  let g:deoplete#enable_at_startup = 1
else
  let g:ale_completion_enabled = 1
  " uncomment max_suggestions in order to limit autocomplete suggestions
  " let g:ale_completion_max_suggestions = 50
  " set omnifunc=syntaxcomplete#Complete
endif
" ALE config
let g:ale_virtualenv_dir_names = ['.virtualenvs']
" Enable only these linters
let g:ale_linters={
\    'python'     : ['pyls'],
\    'json'       : ['jsonlint'],
\    'javascript' : ['eslint'],
\    'cpp'        : ['clang'],
\    'pyrex'      : ['cython'],
\    'cmake'      : ['cmakelint'],
\}
let g:ale_fixers={
\    'javascript': ['prettier_eslint'],
\    'python'    : ['autopep8'],
\}
" let g:ale_typescript_tsserver_executable='tsserver'
" enable completion where available.  Experimental
autocmd FileType python nnoremap <buffer><silent> <c-]>  :ALEGoToDefinitionInTab<cr>
autocmd FileType python nnoremap <buffer><silent> <c-s-l>  :ALELint<cr>