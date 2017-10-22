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
set esckeys
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
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
        set undodir=~/.vim/undo
endif

set viminfo+=! " make sure vim history works
map <C-J> <C-W>j<C-W>_ " open and maximize the split below
map <C-K> <C-W>k<C-W>_ " open and maximize the split above
set wmh=0 " reduces splits to a single line 

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
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
set history=100
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" Set folding options / preferences.
set foldmethod=syntax
" If you want to enable folding by default, uncomment below...
" set foldenable

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
aug new_userscript
    au!
    au BufNewFile *.js 0r ~/.vim/templates/userscript.js
aug END
" TODO: add template for new python scrips of various types when you feel like
" coding it out

" Set color scheme!¬
colorscheme 0x7A69_dark
" Bufexplorer
let g:bufExplorerSplitBelow=1        " Split new window below current.
set spr " set splitright to default
set splitbelow " open h-splits below current buff
let g:pymode_rope_completion=0


" for now disable eclim unless explicit

" text wrapping and visual queue
set colorcolumn=+1
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
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_python_python_exec = '/usr/local/bin/python'
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_exec='/usr/local/bin/python'
let g:syntastic_python_flake8=['-m', 'flake8']
" Use the following syntax to disable specific error codes in flake8
" let g:syntastic_python_flake8_args='--ignore=E501,E225'
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