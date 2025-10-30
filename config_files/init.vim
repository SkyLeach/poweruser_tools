" modeline
" vi: sw=2 ts=2 sts=2 et cc=80 tw=80
" SkyLeach custom settings
"{{ Custom variables
" this is ultra-important as the vim-sessions plugin will prompt and that
" breaks stuff
" let g:session_directory = expand('~\vimfiles\sessions')
let g:session_autoload = 'no'
let g:session_autosave = 'no'
let g:is_win           = has('win32') || has('win64')
let g:is_linux         = 0
let g:is_mac           = 0
let g:is_cygwin        = 0
let g:is_wsl           = 0
let g:psver            = system('$PSVersionTable')
let g:is_pshell        = empty(g:psver) ? 0 : 1
" SkyLeach - 3/23/2025 10:48:07 PM - Set coc default testing
" let g:coc_global_extensions = [
"   \ 'coc-css',
"   \ 'coc-json',
"   \ ]
if has('unix')
  if !has('macunix')
    let g:is_linux     = 1
  else
    let g:is_mac       = 1
  endif
  let res              = trim(system("uname -a | grep -i microsoft"))
  if v:shell_error
    let res            = trim(system("uname -a | grep -i cygwin"))
    let g:is_cygwin    = v:shell_error ? 0 : 1
  else
    let g:is_wsl       = 1
  endif
endif

" NOTE: handle paths between windows/cygwin/wsl
let g:bundles = "C:\\Users\\mattg\\AppData\\Local\\nvim\\bundle"
let g:pathtool = 'cygpath -ad'
if has('unix')
  let g:pathtool = g:is_cygwin ? exepath('cygpath') . " -au" : g:pathtool
  let g:bundles = trim(system(g:pathtool . g:bundles))
  " Special Handling for win->cygwin->win problems, WSL should have the WSLENV
"   if empty(glob($JAVA_HOME))
"       " Try this one likely fix
"       let $JAVA_HOME = trim(system(g:pathtool . "'" . $JAVA_HOME."'"))
"       if empty(glob($JAVA_HOME))
"           echom "Unable to repair JAVA_HOME = " . $JAVA_HOME
"       else
"           echom "JAVA_HOME fixed!"
"       endif
"   endif
endif
" python configuration
if executable('python')
  if g:is_win
    "  3/12/2025 5:12:16 AM
    " let g:python_host_prog="C:\\Users\\mattg\\Envs\\srs\\Scripts\\python.exe"
    let g:python_host_prog="C:\\Python313\\python.exe"
    " I'm really unsure why this didn't work, maybe a compile-time issue.
    " 3/12/2025 3:17:34 PM
    " let g:python_host_prog=trim(system("Get-Command python | Select-Object -ExpandProperty Definition"))
    let g:python3_host_prog=g:python_host_prog
    " let g:pydocstring_doq_path="C:\\Users\\mattg\\Envs\\srs\\Scripts\\doq.exe"
    " 3/12/2025 5:13:30 AM
    let g:pydocstring_doq_path="C:\\Python313\\Scripts\\doq.exe"
    " let g:python_host_prog="C:/Python39/python.exe"
    " let g:python3_host_prog=g:python_host_prog
    " let g:pydocstring_doq_path="C:/Python39/Scripts/doq.exe"
    if g:is_wsl || g:is_cygwin
      let g:python_host_prog=trim(system(g:pathtool . g:python_host_prog))
      let g:python3_host_prog=trim(system(g:pathtool . g:python3_host_prog))
    endif
  else
    let g:python_host_prog=exepath('python')
    let g:python3_host_prog=exepath('python3')
    let g:pydocstring_doq_path=exepath('doq')
  endif
else
  echoerr 'Python 3 executable not found! You must install Python 3 and set its PATH correctly!'
endif
let g:virtualenv_directory = expand('~\Envs')
" if g:is_win && executable('conda')
"   let g:virtualenv_directory = '\tools\miniconda3\envs'
" else
"   let g:virtualenv_directory = expand('~\Envs')
" endif
let mapleader = ';'
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
" for coc-vimlsp

let g:markdown_fenced_languages = ['vim', 'help', 'html', 'python',
    \ 'bash=sh', 'json', 'javascript', 'typescript', 'ps1']
" NOTE: SkyLeach options/prefs
set nocompatible
set number
" default fileformats for my style
set ffs=unix,dos,mac
" handle binary files without decoding
set binary
" obvious cursor position
" cursorline
set cul
" cursorcolumn
set cuc
" default bg highlight hint
set bg=dark
let &spellfile = expand("~/.vim/spell/en.utf-8.add")
set spell spelllang=en_us
" coc suggested settings ported to this init.vim
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set encoding=UTF-8
" this doesn't work and '' is UTF-8 anyhow...
let &fileencoding=&encoding
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1
set signcolumn=yes
" set signcolumn=number

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Setting sessiontopns not to save blank buffers fixes errors on workspace
" tools
" set sessionoptions-=blank
" Setting grepprg on windows is essential as default configs are for POSIX
let rg_binary="C:/ProgramData/chocolatey/bin/rg.exe"
let rg_format="%f:%l:%m,%f:%l%m,%f  %l%m"
let rg_command=rg_binary . " --vimgrep --smart-case --hidden $*"
" let rg_command=rg_binary . " --vimgrep --smart-case --hidden 'function.*\n([^}]*\n)+^[}]$' @(Get-ChildItem .\matthew-gregory-skill-relevance-timeline\ -File -Filter "*@*.js" | ForEach-Object -Process { echo $_.FullName})
let &grepprg=rg_command
let &grepformat=rg_format
" set grepprg=C:/ProgramData/chocolatey/bin/grep.exe
" set grepformat=%f:%l:%c:%m
" reset filetype
filetype off
filetype plugin indent on

" if/when using neovide quickly toggle transparency mode...
nnoremap <leader>T :let g:neovide_opacity=0.90CR>
nnoremap <leader>S :let g:neovide_opacity=1<CR>
" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>dgh :diffget //2<CR>
nnoremap <leader>dgl :diffget //3<CR>
" Simple `windo diffthis` mappings:
nnoremap <leader>dt :windo diffthis<CR>
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>dp :diffput<CR>
xmap <leader>dg :diffget<CR>
xmap <leader>dp :diffput<CR>
nnoremap <leader>dq :diffoff<CR>

" NOTE: handle key mappings when you can't use C-w in ConEmu?
nnoremap <C-S-h> <C-w>h
nnoremap <C-S-j> <C-w>j
nnoremap <C-S-k> <C-w>k
nnoremap <C-S-l> <C-w>l
" 
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" * enable/disable coc integration >
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: cool ALE signs!
let g:ale_sign_error             = '❌'
let g:ale_sign_info              = '📝'
let g:ale_sign_offset            = 1000000
let g:ale_sign_style_error       = '🆘'
let g:ale_sign_style_warning     = '✏️'
let g:ale_sign_warning           = '⚠️'
let g:ale_sign_highlight_linenrs = 0
let g:ale_statusline_format      = v:null
let g:ale_set_balloons           = 1
let g:ale_set_quickfix           = 0
let g:ale_set_loclist            = 0
" NOTE: have to be before coc integration...
let g:airline#extensions#coc#enabled = 1
" * change error symbol: >
  " let airline#extensions#coc#error_symbol = 'E:'
let airline#extensions#coc#error_symbol = g:ale_sign_error
" * change warning symbol: >
  " let airline#extensions#coc#warning_symbol = 'W:'
let airline#extensions#coc#warning_symbol = g:ale_sign_warning
" * change error format: >
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
" * change warning format: >
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'
" 
" " Mappings for CoCList
" " Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Show buffers.
nnoremap <silent><nowait> <space>b  :<C-u>CocList buffers<cr>
" " Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " coc-marketplace
nnoremap <silent><nowait> <space>m  :<C-u>CocList marketplace<cr>
" " coc-marketplace
nnoremap <silent><nowait> <space>u  :<C-u>CocList mru<cr>
" " Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" " coc-yank
nnoremap <silent><nowait> <space>y  :<C-u>CocList -a --normal yank<CR>
" " coc-find files
nnoremap <silent><nowait> <space>f  :<C-u>CocList files<CR>
" " coc-search cwd files
nnoremap <silent><nowait> <space>h  :<C-u>CocSearch<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Pydocstring code actions
nmap <leader>gP <Plug>(coc-codeaction-line)
xmap <leader>gP <Plug>(coc-codeaction-selected)
nmap <leader>gPA <Plug>(coc-codeaction)

augroup json_ft
  au!
  " set ojs filetype.  typescript handled in next group.
  autocmd BufNewFile,BufRead *.ojs set filetype=typescript
  autocmd BufNewFile,BufRead *.json,*.ipynb setl
        \ sw=2 sts=2 ts=2 tw=80 syn=json et ff=unix foldmethod=syntax
        \ formatexpr=CocActionAsync('format')
augroup END

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    au FileType typescript,json,javascript setl 
                \ sw=2 sts=2 ts=2 tw=80 et ff=unix foldmethod=syntax wrapmargin=80 cc=80
                \ formatexpr=CocActionAsync('format')
    au FileType html setl 
                \ sw=2 sts=2 ts=2 tw=0 et ff=unix foldmethod=syntax wrapmargin=0 cc=120
                \ formatexpr=CocActionAsync('format')
    au FileType sql setl 
                \ sw=2 sts=2 ts=2 tw=100 et ff=unix foldmethod=syntax wrapmargin=100 cc=100 tw=100
                \ formatexpr=CocActionAsync('format')
    au FileType python let b:coc_root_patterns = ['.git',
                                                 \'.env',
                                                 \'venv',
                                                 \'.venv',
                                                 \'setup.cfg',
                                                 \'setup.py',
                                                 \'pyproject.toml',
                                                 \'pyrightconfig.json']
    " There are three markdowns: markdown, *_web and *-web because one is for the
    " web, the other comments on the web 
    au FileType markdown setl
                \ sw=4 sts=4 ts=4 tw=80 et ff=unix syn=markdown foldmethod=indent
                \ formatexpr=CocActionAsync('format')
    au FileType markdown-web setl
                \ sw=4 sts=4 ts=4 tw=300 cc=300 et ff=unix syn=markdown wrapmargin=0 foldmethod=syntax
                \ formatexpr=CocActionAsync('format')
    au FileType copilot-markdown setlocal sw=4 sts=4 ts=4 tw=800 cc=800 et ff=unix
                \ syn=markdown wrapmargin=0 foldmethod=syntax
                \ formatexpr=CocActionAsync('format')
    au FileType vim setl
                \ sw=2 sts=2 ts=2 tw=80 et foldmethod=indent
                \ formatexpr=CocActionAsync('format')
  " SkyLeach NOTE: foldmethod for python
  " au BufNewFile,BufRead *.py setl foldmethod=indent
  " au BufNewFile,BufRead *.json setl foldmethod=syntax
  " au BufNewFile,BufRead *.js setl foldmethod=syntax
  " SkyLeach Note: workon on javascript autocmd/autohandling
  " autocmd FileType javascript setl sw=2 sts=2 ts=2 et formatexpr(
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>cac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>cas  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>cfc  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
" update coc completions with copilot
inoremap <silent><expr><c-l> coc#refresh()
" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>cas  <Plug>(coc-codeaction-selected)
" nmap <leader>cas  <Plug>(coc-codeaction-selected)
" 
" " Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)
" nmap <leader>qf <Plug>(ale_fix)
" 
" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" 
" " disabled for Chat reasons SkyLeach @ 10/13/2025 6:57:49 AM
" " Use CTRL-S for selections ranges.
" " Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)
" 
" " Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
" 
" " Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocActionAsync('fold', <f-args>)
" 
" " Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
"
" end of coc mostly

" NOTE: Skyleach - insert date/time vimscript command
" Format String              Example output
" -------------              --------------
"  %c                         Thu 27 Sep 2007 07:37:42 AM EDT (depends on
"  locale)
"  %a %d %b %Y                Thu 27 Sep 2007
"  %b %d, %Y                  Sep 27, 2007
"  %d/%m/%y %H:%M:%S          27/09/07 07:36:32
"  %H:%M:%S                   07:36:44
"  %T                         07:38:09
"  %m/%d/%y                   09/27/07
"  %y%m%d                     070927
"  %x %X (%Z)                 09/27/2007 08:00:59 AM (EDT)
"  %Y-%m-%d                   2016-11-23
"  %F                         2016-11-23 (works on some systems)
"
"  RFC822 format:
"  %a, %d %b %Y %H:%M:%S %z   Wed, 29 Aug 2007 02:37:15 -0400
"
"  ISO8601/W3C format (http://www.w3.org/TR/NOTE-datetime):
"  %FT%T%z                    2007-08-29T02:37:13-0400
nnoremap <F5> "=strftime("%c")<CR>P
inoremap <F5> <C-R>=strftime("%c")<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach NOTE: non-coc MRU, maybe change?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MRU (Most Recently Used) settings:
" Save list to file...
" that can't be right... something borken here
" let MRU_File = 'd:\myhome\_vim_mru_files'
" NOTE: removed then re-added temp to prevent junkfile dumping
let MRU_File = expand("~/vimfiles/_vim_mru_files")
" windows neovim having problems with FQPN
" let MRU_File = 'c:\Users\mattg\vimfiles\_vim_mru_files'
let MRU_Max_Entries = 1000
" Exclude files matching ...
" let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
" let MRU_Exclude_Files = '^D:\\temp\\.*'           " For MS-Windows
" Only show files matching ...
" let MRU_Include_Files = '\.c$\|\.h$'
let MRU_Window_Height = 15
" No new window (current window)
" let MRU_Use_Current_Window = 1
" Do not autoclose MRU window ...
" let MRU_Auto_Close = 0
" Default max listing is 10 ...
let MRU_Max_Menu_Entries = 20
" Num submenus (pages of size above) ...
" let MRU_Max_Submenu_Entries = 15
" SkyLeach Note: I like tabs, this uses tabs, I like this ...
let MRU_Open_File_Use_Tabs = 0

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
" deoplete removed while trying out coc.nvim due to fighting over omnifunc
" Use deoplete.
" let g:deoplete#enable_at_startup = 1
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" SkyLeach Note: I'm about done with trying to get Ultisnips working
" Ok backed up and TRYING to use coc-snippets
" let g:UltiSnipsSnippetsDir = "vim-snippets\SkyLeach.snippets"
" let g:UltiSnipsSnippetsDir = g:bundles."\vim-snippets\SkyLeach.snippets"
" let g:UltiSnipsSnippetDirectories=[
"   \ "SkyLeach.snippets",
"   \ "UltiSnips"]
" let g:UltiSnipsExpandTrigger="<c-.>"
" let g:UltiSnipsListSnippets="<c-,>"
" " let g:UltiSnipsJumpForwardTrigger="<c-j>"
" " let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" " let g:UltiSnipsExpandTrigger="<c-tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
" NyaoVim plugin settings for electron
" Eager Update
let g:markdown_preview_eager = 1
" Auto-hide bufferchange
let g:markdown_preview_auto = 1
" LSP Server Configs - moved to coc.nvim
" lsp python
" if executable('pyls')
"   au User lsp_setup call lsp#register_server({
"     \ 'name': 'pyls',
"     \ 'cmd': {server_info->['pyls']},
"     \ 'whitelist': ['python'],
"     \ })
" endif
" " lsp javascript
" au User lsp_setup call lsp#register_server({
"   \ 'name': 'javascript support using typescript-language-server',
"   \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
"   \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
"   \ 'whitelist': ['javascript', 'javascript.jsx'],
"   \ })
" lsp haskell
" au User lsp_setup call lsp#register_server({
"     \ 'name': 'ghcide',
"     \ 'cmd': {server_info->['/your/path/to/ghcide', '--lsp']},
"     \ 'whitelist': ['haskell'],
"     \ })
""""""""""""""""""""""""""""""
" Matt's ALE configuration
" let g:ale_gdscript3_godotheadless_executable = 'C:\Users\mattg\Downloads\Godot_v3.2-beta2_mono_win64\Godot_v3.2-beta2_mono_win64.exe'
" deoplete use ALE - disabled during coc.nvim testing.
" call deoplete#custom#option('sources', {
"  \ '_': ['ale'],
"  \})
" set omnifunc=ale#completion#OmniFunc
" backup line
      " \   'python': ['flake8', 'pylint', 'pycodestyle', 'mypy'],
" let g:ale_linters = {
"       \   'python': ['mypy', 'pydocstyle', 'flake8'],
"       \}
" NOTE: move up past bracket to enable - unmentioned langs get all
"       \   'ruby': ['standardrb', 'rubocop'],
"       \   'javascript': ['eslint'],
" SkyLeach Note: trying grab-bag linting, but not sure... 
" let g:ale_linters = {'python': ['mypy', 'pycodestyle', 'pydocstyle', 'pyls'],'ruby': ['standardrb', 'rubocop'],'javascript': ['eslint'], 'ascii': ['alex', 'proselint'], 'ascii': ['alex', 'proselint'],}
" let g:ale_fixers = {
"       \    'python': ['yapf'],
"       \}
" nmap <F10> :ALEFix<CR>
" Set this. Airline will handle the rest.
" let g:airline#extensions#ale#enabled = 1
" " ale error_symbol >
" let airline#extensions#ale#error_symbol = 'E:'
" "
" " ale warning >
" let airline#extensions#ale#warning_symbol = 'W:'
"
" " ale show_line_numbers >
" let airline#extensions#ale#show_line_numbers = 1
" "
" " ale open_lnum_symbol >
" let airline#extensions#ale#open_lnum_symbol = '(L'
" "
" " ale close_lnum_symbol >
" let airline#extensions#ale#close_lnum_symbol = ')'

" -------------------------------------                      *airline-battery*
" vim-battery <https://github.com/lambdalisue/battery.vim>

" enable/disable battery integration >
let g:airline#extensions#battery#enabled = 1
"   default: 0

" -------------------------------------                      *airline-bookmark*
" vim-bookmark <https://github.com/MattesGroeger/vim-bookmarks>

" enable/disable bookmark integration >
let g:airline#extensions#bookmark#enabled = 1
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
""""""""""""""""""""""""""""""
" Put these lines at the very end (ish) of your vimrc file.
" lastish
set cc=80 sw=4 sts=4 ts=4 et tw=80 wrapmargin=80
syn on
set wildignore+=node_modules/**,package-lock.json,dist/**,frontend/node_modules/**,build/**

" Markdown Preview Config Settings
" ********************************************************
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''
" options for coc-emmet
"
" emmet.showExpandedAbbreviation: Shows expanded Emmet abbreviations as
"   suggestions, default true.
" emmet.showAbbreviationSuggestions: Shows possible Emmet abbreviations as
"   suggestions. Not applicable in stylesheets or when
"   emmet.showExpandedAbbreviation is 'never'.
" emmet.includeLanguages: Enable Emmet abbreviations in languages that are not
"   supported by default. Add a mapping here between the language and emmet
"   supported language. E.g.: {"vue-html": "html", "javascript":
"   "javascriptreact"}
" emmet.variables: Variables to be used in Emmet snippets
" emmet.syntaxProfiles: Define profile for specified syntax or use your own
"   profile with specific rules.
" emmet.excludeLanguages: An array of languages where Emmet abbreviations
"   should not be expanded, default: ["markdown"].
" emmet.optimizeStylesheetParsing: When set to false, the whole file is parsed
"   to determine if current position is valid for expanding Emmet abbreviations.
"   When set to true, only the content around the current position in
"   css/scss/less files is parsed.
" emmet.preferences: Preferences used to modify behavior of some actions and
"   resolvers of Emmet.

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = '.vim\bundle-disable\markdown-preview.nvim\app\_static\markdown.css'

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'
" SkyLeach NOTE: personal terminal hotkey to exit with escape
tnoremap <s-Esc> <C-\><C-n>
" hexdup edit needs to have the command fixed.
" SE link:https://vi.stackexchange.com/a/2234/31916 
" xxd or xxd -r to convert back
" nmap <leader><c-h> exec ':vsplit %!xxd'<cr>
" SkyLeach NOTE: personal firefox kickoff - end of file to prevent conflict
" nmap <leader><c-f> :exec ':!"c:\Program Files\Mozilla Firefox\firefox.exe" -new-tab file://"%:p"'<CR>
" nmap <leader><c-f> :exec 'call trim(system(shellescape(g:browsercmd) . " -new-tab " . shellescape("file://" . expand("%") . ":p")))'<CR>
" nmap <leader><c-f> :exec !.:call fnameescape("c:\Program\ Files\Mozilla\ Firefox\firefox.exe") -new-tab fnameescape(file://"%:p")<CR>
" SkyLeach NOTE: entire src folder RST documentation and notes
let src_prj_notes = { 'path': '\Users\mattg\src\devnotes\', }
let g:riv_projects = [src_prj_notes]
" SkyLeach NOTE: foldmethod for python - Moved to group
" au BufNewFile,BufRead *.py set foldmethod=indent
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach NOTE: polyglot replaced this
" let g:javascript_plugin_jsdoc                      = 1
" let g:javascript_plugin_ngdoc                      = 1
" let g:javascript_plugin_flow                       = 1
let g:javascript_conceal_function                  = "ƒ"
let g:javascript_conceal_null                      = "ø"
let g:javascript_conceal_this                      = "@"
let g:javascript_conceal_return                    = "⇚"
let g:javascript_conceal_undefined                 = "¿"
let g:javascript_conceal_NaN                       = "ℕ"
let g:javascript_conceal_prototype                 = "¶"
let g:javascript_conceal_static                    = "•"
let g:javascript_conceal_super                     = "Ω"
let g:javascript_conceal_arrow_function            = "⇒"
let g:javascript_conceal_noarg_arrow_function      = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"
set conceallevel=1  " Default enabled, but I may change this
map <leader>l :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>
if exists("g:ale_virtualenv_dir_names")
    let g:ale_virtualenv_dir_names  += ['Envs']
else
    let g:ale_virtualenv_dir_names = ['Envs']
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: gitgutter signs
" set gitpath=C:\PROGRA~1\Git\cmd\git.exe
let g:fugitive_git_executable                = "C:\\PROGRA~1\\Git\\cmd\\git.exe"
let g:gitgutter_git_executable               = g:fugitive_git_executable
" let g:gitgutter_git_executable               = exepath('git')
let g:gitgutter_sign_added                   = '▶️'  " +
let g:gitgutter_sign_modified                = '🔁'  " ~
let g:gitgutter_sign_removed                 = '◀️'  " _
let g:gitgutter_sign_removed_first_line      = '⏫'  " ‾
let g:gitgutter_sign_removed_above_and_below = '〰️'  " _¯
let g:gitgutter_sign_modified_removed        = '🔂'  "~_
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: ***** Remember how to do this? *****
" :tabnew|pu=execute('scriptname')  " Or any function name
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: ***** neoterm useful mappings *****
let g:neoterm_default_mod='belowright' " open terminal in bottom split
let g:neoterm_size=16 " terminal split size
let g:neoterm_autoscroll=1 " scroll to the bottom when running a command
" let g:neoterm_repl_python = ['C:\Users\mattg\Envs\srs\Scripts\Activate.ps1', 'ipython']
" 3/12/2025 5:14:17 AM
let g:neoterm_repl_python = ['C:/Python313/Scripts/ipython.exe']
" Tell neoterm not to automatically close the window when the process exits.
let g:neoterm_autoclose = 0
let g:neoterm_repl_python = ['C:/Users/mattg/srs/python-scanner/activate', 'ipython']
let g:neoterm_repl_enable_ipython_paste_magic = 1
" *********************** SET UP POWERSHELL ***********************
" set g:neoterm_shell = system get-command path to pwsh.exe like
" =system('get-command pwsh').stdouttrim()

" When set to 1 neoterm will send the commands to the neoterm buffer linked to
" the current tab instead of the last active neoterm.
" Default value: 0
let g:neoterm_term_per_tab=1
" set powershell as the DEFAULT
" let g:neoterm_shell='C:/Program Files/PowerShell/7/pwsh.exe'
" let g:neoterm_shell='C:\Users\mattg\AppData\Local\Microsoft\WindowsApps\Microsoft.PowerShell_8wekyb3d8bbwe\pwsh.exe'
" visually map to send REPL to neoterm (or other REPL)
" Use gx{text-object} in normal mode
nmap <leader>gx <Plug>(neoterm-repl-send)
" Send selected contents in visual mode.
xmap <leader>gx <Plug>(neoterm-repl-send)
" Like |<Plug>(neoterm-repl-send)|, but for lines. For example,
nmap <leader>gxx <Plug>(neoterm-repl-send-line)
" REPL command to run the current (saved) buffer from file on disk
nmap <leader>gxs :execute 'T & ' . shellescape(expand('%:p'))<CR>
" REPL command to run the current (saved) buffer from file on disk but through Pester for Powershell
nmap <leader>gxps :execute 'T Invoke-Pester -Path "' . shellescape(expand('%:p')) . '"'<CR>
" 10/12/2024 2:04:12 PM - try using alternative way to set shell as I'm having issues with the above method
if g:is_win
  " **** CMD.EXE
  " set shell=cmd.exe
  " let &shellcmdflag = '/c '
  " let &shellquote   = ''
  " **************** OLD powershell **************** 
  " set shell=powershell
  " set shellxquote=
  " let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
  " set shellquote   = \"
  " let &shellpipe    = '| Out-File -Encoding UTF8 %s'
  " let &shellredir   = '| Out-File -Encoding UTF8 %s'
  " **************** from documentation: ****************
  " let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
  " let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  " let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  " let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  " set shellquote= shellxquote=
  " **************** NEW powershell ****************
" use correct comment market for powershell
  let g:neoterm_marker = ';#neoterm'
  " set shell=powershell
  set shell=C:\PROGRA~1\PowerShell\7\pwsh.exe
  " set shell=C:/PROGRA~1/PowerShell/7/pwsh.exe
  let g:neoterm_shell=&shell
  " set shellxquote=
  " let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
  " let &shellcmdflag="-NoLogo -NoProfile -NonInteractive -ExecutionPolicy AllSigned -c $($PSStyle.OutputRendering='PlainText');[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -c [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  set shellquote= shellxquote=
  " set shellquote="
  let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  " let &shellpipe    = '| Out-File -Encoding UTF8 %s'
  " let &shellredir   = '| Out-File -Encoding UTF8 %s'
  " let &shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  " let &errorformat  = 'oogyboogy'
  " set errorformat=%f:%l:%c:\ error:\ %m
  " set shellquote= shellpipe=2>&1\ \|\ Out-File\ -Encoding\ UTF8\ %s;\ exit\ $LastExitCode shellredir=-ExecutionPolicy\ RemoteSigned shellxquote=
  " set shellquote=  shellredir=> shellxquote=
  " set shellquote= shellpipe='| Out-File -Encoding UTF8 %s' shellredir='| Out-File -Encoding UTF8 %s' shellxquote=
  " set shellpipe=2>&1\ \|\ Out-File\ -Encoding\ UTF8\ %s;\ exit\ \$LastExitCode
  " set shellpipe=2>&1\ \|\ Out-File\ -Encoding\ UTF8\ %s;\ exit\ \$LastExitCode
else
    let g:userbash='/usr/bin/bash'
    set shell=executable(g:userbash) ? g:userbash : 'bin/bash'
    let g:neoterm_shell = &shell
endif
" *****************************************************************
nnoremap <leader><cr> :TREPLSendLine<cr>j " send current line and move down
vnoremap <leader><cr> :TREPLSendSelection<cr> " send current selection
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: CtrlP
" settings for opening NerdTree to the neovim bundles location
" figure out how to make this work
nnoremap <leader>ntb :execute ":NERDTree" g:bundles<CR>
nnoremap <leader>nt :NERDTree<cr>
nnoremap <leader>ntf :NERDTreeFind %<cr>
nnoremap <leader>ntt :NERDTreeToggle %<cr>
" let g:src = expand('~\src')
nnoremap <leader>nts :execute ":NERDTree" expand('~\src')<CR>
"" NERDTree configuration
let g:NERDTreeChDirMode=0
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
let NERDTreeQuitOnOpen=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: CtrlP
" settings for CtrlP plugin
let g:ctrlp_cmd='CtrlPMixed'
let g:ctrlp_open_new_file='t'
set switchbuf=usetab,useopen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: vimspector config (debuggers)
let g:vimspector_enable_mappings = 'HUMAN'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: lexical (spell, dictionary, & thesarus )
if exists("g:lexical#thesaurus")
  let g:lexical#thesaurus += ['.\lexical_files\moby_thesaurus.org.txt',
                            \ '.\lexical_files\mthesaur.txt',
                            \ '.\lexical_files\roget13a.txt']
else
  let g:lexical#thesaurus = ['./lexical_files/moby_thesaurus.org.txt',
                            \ './lexical_files/mthesaur.txt',
                            \ './lexical_files/roget13a.txt']
endif
let tempstr = trim(system(g:pathtool . 'c:\Hunspell\en_US.dic'))
if exists("g:lexical#dictionary")
  let g:lexical#dictionary += [ tempstr ]
else
  let g:lexical#dictionary = [ tempstr ]
endif
let tempstr = "/Users/mattg/.vim/spell/en.utf-8.add" 
if !g:is_win
  let tempstr = trim(system("&" . g:pathtool . " " . tempstr))
endif
if exists("g:lexical#spellfile")
  let g:lexical#spellfile += [ tempstr ]
else
  let g:lexical#spellfile = [ tempstr ]
endif
let g:lexical#thesaurus_key = '<leader>t'
let g:lexical#dictionary_key = '<leader>k'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: EasyAlign
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
let g:easy_align_ignore_groups = ['Comment', 'String']
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: fzf (fuzzyfind) (faster than ctrl-p)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: OpenBrowser browser-open mappings
" Open URLs under cursor or visual selection in a new firefox tab.
" let g:openbrowser_browser_commands = [{'name': 'c:\Program Files\Mozilla Firefox\firefox.exe', 'args': ['{browser}', '-new-tab', '{uri}']}]
" function OpenBrowserConfig(target) abor
"   let g:openbrowser_browser_commands['args'][2] = a:target
"   :call openbrowser()
" endfunction
function! SetBrowserCmd(browser)
  if ( a:browser == "chrome" )
      return "'C:/Program Files/Google/Chrome/Application/chrome.exe'"
  elseif ( a:browser == "edge" || a:browser == "msedge" || a:browser == "iexplore" )
      return "'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'"
  elseif ( a:browser == "firefox" )
      return "'C:/Program Files/Mozilla Firefox/firefox.exe'" 
" c:/Program\ Files/Mozilla\ Firefox/firefox.exe
  else
      return "elinks"
  :endif
endfunction
" let browser = "firefox"
" let g:browsercmd = "c:/Program\ Files/Mozilla\ Firefox/firefox.exe"
" if !g:is_win
if g:is_win
  let g:browsercmd = SetBrowserCmd("firefox")
else
  " preferred
  let g:browsercmd = trim(system(g:pathtool . "elinks" ))
endif
" Removed extn and rolled my own
" let g:openbrowser_browser_commands = [
"   \   {'name': g:browsercmd,
"   \    'args': ['{browser}', '-new-tab', '{uri}']}
"   \]
" ****************************************************************************
" Browser Mapping Funcs: 
" Use a browser (incl. elinks for nonwindows) to do the following:
" ****************************************************************************
function! ViewHtmlText(url)
  if !empty(a:url)
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
    execute 'r !elinks ' . a:url . ' -dump -dump-width ' . winwidth(0)
    1d
  endif
endfunction
" Save and view text for current html file.
nnoremap <Leader><c-h>w :update<Bar>call ViewHtmlText(expand('%:p'))<CR>
" View text for visually selected url.
vnoremap <Leader><c-h>w y:call ViewHtmlText(@@)<CR>
" View text for URL from clipboard.
" On Linux, use @* for current selection or @+ for text in clipboard.
" nnoremap <Leader><c-h>lw :call ViewHtmlText(@+)<CR>
" On Windows, make the default g:browsercmd for opening current file
nnoremap <leader><c-f> :echo trim(system('&' . g:browsercmd . " -new-tab file://" . expand("%:p")))<CR>
" On Windows, open URL under cursor in GUI browser
" nnoremap <leader><c-i> :let g:browsercmd=SetBrowserCmd("msedge")<bar>exec trim(system(g:browsercmd . " -new-tab " . expand("<cfile>")))<CR>
nnoremap <leader><c-f>ew :exec trim(system('&' . SetBrowserCmd("msedge") . " -new-tab " . expand("<cfile>")))<CR>
nnoremap <leader><c-f>fw :exec trim(system('&' . SetBrowserCmd("firefox") . " -new-tab " . expand("<cfile>")))<CR>
nnoremap <leader><c-f>cw :exec trim(system('&' . SetBrowserCmd("chrome") . " -new-tab " . expand("<cfile>")))<CR>
" On Windows, update and open current file in associated browser.
" nnoremap <leader><c-f>we :update<Bar>exec trim(system(SetBrowserCmd("msedge") . " -new-tab file://" . expand("%")))<CR>
" nnoremap <leader><c-f>wf :update<Bar>exec trim(system(SetBrowserCmd("firefox") . " -new-tab file://" . expand("%")))<CR>
" nnoremap <leader><c-f>wc :update<Bar>exec trim(system(SetBrowserCmd("chrome") . " -new-tab " file://" . expand("%")))<CR>
" original settings for CMD
" nnoremap <leader><c-o><i> :!start C:\PROGRA~2\MICROS~1\Edge\APPLIC~1\msedge.exe -new-tab  <cfile><CR>
" nnoremap <leader><c-o><f> :!start c:\progra~1\mozill~1\firefox.exe -new-tab  <cfile><CR>
" nnoremap <leader><c-o><c> :!start c:\progra~1\google\chrome\applic~1\chrome.exe -new-tab  <cfile><CR>
" On Windows, update and open current file in associated browser.
" nnoremap <leader><c-f><i> :update<Bar>silent !start C:\PROGRA~2\MICROS~1\Edge\APPLIC~1\msedge.exe  -new-tab file://%:p<CR>
" nnoremap <leader><c-f><f> :update<Bar>silent !start C:\progra~1\mozill~1\firefox.exe  -new-tab file://%:p<CR>
" nnoremap <leader><c-f><c> :update<Bar>silent !start C:\progra~1\google\chrome\applic~1\chrome.exe  -new-tab file://%:p<cr>
" in terminal or shell open current dkkkkkkdss
" nnoremap <leader><c-h> :update<Bar>silent !start c:\progra~1\intern~1\iexplore.exe file://%:p<CR>
" On Linux, open URL under cursor in Firefox.
" nnoremap <leader><c-h> :silent !firefox <cfile><CR>
" ****************************************************************************
" nmap <leader><c-f> :call OpenBrowserConfig("file://%:p")<cr>
" send current line and move down
" nmap <leader><c-o> <Plug>(openbrowser-open)
" nmap <leader><c-o> :call OpenBrowserConfig("{url}")<cr>
" send current selection
vmap <leader><c-o> <Plug>(openbrowser-open)
vmap <leader><c-o> :call OpenBrowserConfig("{url}")<cr>
" send current line and move down
nmap <leader><c-s> <Plug>(openbrowser-search)
" send current selection
" vmap <leader><c-s> <Plug>(openbrowser-search)
vmap <leader><c-v> <Plug>(openbrowser-open)
nmap <Leader>te :horiz belowright Tnew<CR>:wincmd l<CR>a<CR>C:\Users\mattg\Envs\srs\Scripts\activate.bat<CR>
nmap <Leader>to :horiz belowright To<CR>:wincmd l<CR>a<CR>C:\Users\mattg\Envs\srs\Scripts\Activate.ps1<CR>
nmap <Leader>tb :Tnew<CR>:wincmd j<CR>a<CR>C:\Users\mattg\Envs\srs\Scripts\Activate.ps1<CR>
nmap <Leader>te :horiz belowright Tnew<CR>:wincmd l<CR>source activate ./env<CR>
nmap <Leader>t1e :horiz belowright Tnew<CR>:wincmd l<CR>source activate ../env<CR>
nmap <Leader>t2e :horiz belowright Tnew<CR>:wincmd l<CR>source activate ../../env<CR>
nmap <Leader>t3e :horiz belowright Tnew<CR>:wincmd l<CR>source activate ../../../env<CR>
nnoremap <leader>tt :horizontal belowright exec 'Ttoggle'<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MRU toggle mapping:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>mt :exec 'MRUToggle'<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIMSPECTOR config:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimspector_enable_mappings = 'HUMAN'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" END VIMSPECTOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: Twitter (vim-twitter) - depr for twitvim
" I *finally* got the haskell tool installed (zomg) but it's bugged, then the
" rust tool works, but need terminal, then got twitvim and it's good.
" let twitvim_enable_python3 = 1
" let twitvim_browser_cmd = g:browsercmd
" | let g:twitter_use_rust=1
" | let g:twitter_use_color=1
" | let g:twitter_screen_name='SkyLeach'
" | let g:twitter_cred='c:/Users/mattg/.cred'
" let twitvim_token_file = 'c:/Users/mattg/.twitvim.cred'
" let g:twitter_cred='c:/Users/mattg/.cred.toml'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: Notes and tricks I don' wanna forget
" NOTE: less pickup sticks: \v(\w)(\S*) <- fuzzy charmatch -> \L <-ref the
"   rest (un-accessed) fuzzy part of a subgroup ... example: s#\v(\w)(\S*)#\u\1\L\2#g
call pathogen#infect()
call pathogen#helptags()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Firenvim and cromenvim in-browser neovim headless editing.
" SkyLeach Note: move this to exernal config file later?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: not sure if mixing is ok, so testing this now.
" TODO: add config logging to messages asap
" function! s:IsFirenvimActive(event) abort
"   if !exists('*nvim_get_chan_info')
"     return 0
"   endif
"   let l:ui = nvim_get_chan_info(a:event.chan)
"   return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
"       \ l:ui.client.name =~? 'Firenvim'
" endfunction
"
" function! OnUIEnter(event) abort
"   if s:IsFirenvimActive(a:event)
"     set laststatus=0
"   endif
" endfunction
" autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
" we don't actually want these conditional for firenvim since thename is specific enough and opening them from another neovim instance or with a --server flag should work as well.

" au BufEnter *\ccopilot*.md setl filetype=markdown-web
au BufEnter *\ccopilot*.md set filetype=copilot-markdown syn=markdown
au BufEnter outlook.live.com*.txt set filetype=html
au BufEnter *youtube.com_*.txt set filetype=markdown-web syn=markdown
au BufEnter *github.com_*.txt set filetype=markdown-web syn=markdown
au BufEnter *reddit.com_*.txt set filetype=markdown-web syn=markdown
au BufEnter *facebook.com_*.txt set filetype=markdown-web syn=markdown
au BufEnter *observablehq.com_*.txt set filetype=javascript
au BufEnter *atlassian.net_*.txt set filetype=confluencewiki
if exists('g:started_by_firenvim') && g:started_by_firenvim
    " TODO: review all of this if/when you get time, I don't trust it yet?
    " also, testing as of 7/26/2021 9:28:56 AM
    " set laststatus=0
    " au BufEnter youtube.com_*.txt set filetype=markdown-web
    " au BufEnter github.com_*.txt set filetype=markdown-web
    " au BufEnter reddit.com_*.txt set filetype=markdown-web
    " au BufEnter facebook.com_*.txt set filetype=markdown-web
    " au BufEnter observablehq.com_*.txt set filetype=javascript
    " au BufEnter atlassian.net_*.txt set filetype=confluencewiki
    " NOTE: takeover settings from doc:
    " ( [README.md](https://github.com/glacambre/firenvim)) 
    "
    " Configuring Firenvim to not always take over elements
    "
    " Firenvim has a setting named takeover that can be set to always, empty,
    " never, nonempty or once. When set to always, Firenvim will always take
    " over elements for you. When set to empty, Firenvim will only take over
    " empty elements. When set to never, Firenvim will never automatically
    " appear, thus forcing you to use a keyboard shortcut in order to make the
    " Firenvim frame appear. When set to nonempty, Firenvim will only take over
    " elements that aren't empty. When set to once, Firenvim will take over
    " elements the first time you select them, which means that after :q'ing
    " Firenvim, you'll have to use the keyboard shortcut to make it appear
    " again. Here's how to use the takeover setting:
    let g:firenvim_config = {
        \ 'globalSettings': {
            \ 'alt': 'all',
        \  },
        \ 'localSettings': {
            \ '.*': {
                \ 'cmdline': 'firenvim',
                \ 'content': 'text',
                \ 'priority': 0,
                \ 'selector': 'textarea',
                \ 'takeover': 'never',
            \ },
        \ }
    \ }
    " let g:firenvim_config = {
    "     \ 'globalSettings': {
    "         \ 'alt': 'all',
    "     \  },
    "     \ 'localSettings': {
    "         \ '.*': {
    "             \ 'cmdline': 'neovim',
    "             \ 'content': 'text',
    "             \ 'priority': 0,
    "             \ 'selector': 'textarea',
    "             \ 'takeover': 'never',
    "         \ },
    "     \ }
    " \ }
    let fc = g:firenvim_config['localSettings']
    " let fc['https?://[^/]+\.co\.uk/'] = { 'takeover': 'never', 'priority': 1 }
    " let fc['.*'] = { 'selector': 'textarea:not([readonly]), div[role="textbox"]' }
    " let fc['.*'] = { 'selector': 'textarea' }
    " " let fc['.*'] = { 'selector': 'textarea:not([class=xxx])' }
    " let fc['.*'] = { 'takeover': 'always' }
    " let fc['.*'] = { 'cmdline' : 'firenvim' }
    " let fc['.*'] = {
    "   \ 'selector': 'textarea:not([readonly,class=xxx]), div[role="textbox"]',
    "   \ 'takeover': 'always', 'priority': 0, 'cmdline' : 'firenvim',
    "   \ 'content' : 'text'
    " \ }
    " TODO: add any site-specific firenvim config settings like below
    " let fc = g:firenvim_config['localSettings']
    let fc['https?://[^/]+twitter\.com/'] = { 'takeover': 'never', 'priority': 2 }
    let fc['https?://[^/]+bluesky\.com/'] = { 'takeover': 'never', 'priority': 2 }
    let fc['https?://[^/]+\.co\.uk/'] = { 'takeover': 'always', 'priority': 1 }
    if g:is_mac
        let g:firenvim_config = {
            \ 'globalSettings': {
                \ 'ignoreKeys': {
                    \ 'all': ['<C-->'],
                    \ 'normal': ['<C-1>', '<C-2>']
                \ }
            \ }
        \ }
    endif
    " SkyLeach NOTE: hacked up for testing eval string...
    " nnoremap <leader>jse :call firenvim#eval_js('alert("Hello World!")', 'MyFunction')
    nnoremap <leader>jse :call firenvim#eval_js(
        \ 'eval("'.s:get_visual_selection().'")', 'EvalMyText')
    nnoremap <Esc><Esc> :call firenvim#focus_page()<CR>
    nnoremap <C-z> :call firenvim#hide_frame()<CR>
" else
"     set laststatus=2
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings for coc.nvim's coc-prettier
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-Test mappings and config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>
let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#basic#start_normal = 1 " If using basic strategy
let g:test#preserve_screen = 1
" make test commands execute using dispatch.vim
" let test#strategy = "neovim_sticky"
" let test#strategy = "asyncrun_background"
let test#strategy = "dispatch"
" let g:asyncrun_open = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc-llamautoma
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Example key mappings
nmap <silent> <Leader>lc :CocCommand llamautoma.chat<CR>
nmap <silent> <Leader>ls :CocCommand llamautoma.sync<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Personal Function taken from stackoverflow 7/26/2021 9:52:07 AM
" (here TBE)[https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript].
" This is a first step in passing a selected line of javascript into the
" browser to interpret.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDCommenter.  Mostly defaut except that I needed to add post-comment
" spaces.
" SkyLeach Note: Default mappings mostly.  See
" [NERDCommenter](https://github.com/preservim/nerdcommenter)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 0

" re-comment nested comments
let NERDDefaultNesting = 0

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 0

" Copilot-Chat / ChatGPT
" autocomplete for copilot_chat
set completeopt=menu,popup,preview,noselect,noinsert
let g:copilot_chat_filetypes = {
      \ '*' : 1,
      \ 'markdown': 1,
      \ 'python': 1,
      \ 'javascript': 1,
      \ 'html': 1,
      \ 'css': 1,
      \ 'lua': 1,
      \ 'vim': 1,
      \ 'sh': 1,
      \ 'json': 1,
      \ 'yaml': 1,
      \ 'rust': 1,
      \ 'go': 1,
      \ 'java': 1,
      \ 'c': 1,
      \ 'cpp': 1,
      \ 'csharp': 1,
      \ 'ruby': 1,
      \ 'php': 1,
      \ 'perl': 1,
      \ 'r': 1,
      \ 'swift': 1,
      \ 'kotlin': 1,
      \ 'typescript': 1,
      \ 'dart': 1,
      \ 'elixir': 1,
      \ 'haskell': 1,
      \ 'clojure': 1,
      \ 'scala': 1,
      \ 'erlang': 1,
      \ 'groovy': 1
 \ }
"  let g:copilot_chat_enable_maps = 101
"  nnoremap <silent> <leader>cc :CopilotChat<CR>
"  nnoremap <silent> <leader>cr :CopilotChatRestart<CR>
"  nnoremap <silent> <leader>ce :CopilotChatEditWithInstructions
"  nnoremap <silent> <leader>ca :CopilotChatActAs<CR>
"  nnoremap <silent> <leader>ch :CopilotChatHistory<CR>
"  nnoremap <silent> <leader>cs :CopilotChatSettings<CR>
"  nnoremap <silent> <leader>cd :CopilotChatDiagnostics<CR>
"  nnoremap <silent> <leader>cf :CopilotChatFeedback<CR>
"  nnoremap <silent> <leader>ct :CopilotChatToggle<CR>
"  nnoremap <silent> <leader>cp :CopilotChatPanel<CR>
"  nnoremap <silent> <leader>cu :CopilotChatUpdate<CR>
"  nnoremap <silent> <leader>cl :CopilotChatClear<CR>
"  nnoremap <silent> <leader>ci :CopilotChatInfo<CR>
"  nnoremap <silent> <leader>cg :CopilotChatGenerate<CR>
"  nnoremap <silent> <leader>cv :CopilotChatVersion<CR>
"  nnoremap <silent> <leader>cw :CopilotChatWelcome<CR>
"  nnoremap <silent> <leader>cx :CopilotChatClose<CR>
"  nnoremap <silent> <leader>cy :CopilotChatYank<CR>
"  nnoremap <silent> <leader>cm :CopilotChatMute<CR>
"  nnoremap <silent> <leader>co :CopilotChatOpenAI<CR>
"  nnoremap <silent> <leader>cb :CopilotChatBingAI<CR>
"  nnoremap <silent> <leader>c$ :CopilotChatCustom<CR>
"  nnoremap <silent> <leader>c. :CopilotChatContinue<CR>
"  nnoremap <silent> <leader>c, :CopilotChatCancel<CR>
"  nnoremap <silent> <leader>c; :CopilotChatSubmit<CR>
"  nnoremap <silent> <leader>c/ :CopilotChatSearch<CR>
"  nnoremap <silent> <leader>c? :CopilotChatHelp<CR>
"  nnoremap <silent> <leader>c! :CopilotChatNewSession<CR>
"  nnoremap <silent> <leader>c@ :CopilotChatMention<CR>
"  nnoremap <silent> <leader>c# :CopilotChatTopic<CR>
"  nnoremap <silent> <leader>c% :CopilotChatContext<CR>
"  nnoremap <silent> <leader>c^ :CopilotChatSummarize<CR>
"
" Added largefile handling to the end.  The idea here is to work around
" accidentally hitting big files that then kill my editor or I have to take a
" 30m break...
" file is large from 10mb
let g:LargeFile = 1024 * 1024 * 100
augroup LargeFile
  au!
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function! LargeFile()
   " no syntax highlighting etc
   set eventignore+=FileType
   " save memory when other file is viewed
   setlocal bufhidden=unload
   " is read-only (write with :w new_filename)
   setlocal buftype=nowrite
   " no undo possible
   setlocal undolevels=-1
   " display message
   autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DO A LUA
" Note: both mason and packer are normally installed by pathogen before it's possible to run the lua portion, so it has to be down here after infection.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lua require("mason").setup()
" I might want to use packer in the future but I don't think yet...
" I still like using pathogen and manually doing packages
" lua require("packer")
" lua require("config.plugins")
" lua require("config.lazy")
" let &runtimepath.=', "~/.config/nvim/lua"'
" lua <<EOF
" require("mason").setup()
" require("config.plugins")
" require("config.lazy")
" EOF
lua <<EOF
require('fzf-lua').register_ui_select()
-- FzfLua.files()

require("mason").setup()
require("duckytype").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "pyrefly" },
}

-- These should be default values already set during config
-- filetypes = { "ps1" }
-- on_new_config = function(new_config, _)
--       local bundle_path = new_config.bundle_path
--       new_config.cmd = make_cmd(bundle_path)
--     end,
-- root_dir = function(fname)
--       return util.find_git_ancestor(fname) or vim.fn.getcwd()
--     end,
vim.lsp.config('powershell_es', {
      bundle_path = "C:/Users/mattg/AppData/Local/nvim/pshelllsp/PowerShellEditorServices",
    })
-- old method is depricated
-- require'lspconfig'.powershell_es.setup{
--   bundle_path = "C:/Users/mattg/AppData/Local/nvim/pshelllsp/PowerShellEditorServices",
-- }
-- experimental treesitter syntax/synquery - 10/23/2025 4:18:06 PM
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  -- testing 'c' 10/23/2025 4:18:44 PM (not installed manually)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`) - nah
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  -- testing with c - dunno - matt @ 10/23/2025 4:20:25 PM
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  -- ignore_install = { "javascript" }, -- disabled by me 10/23/2025 4:20:46 PM

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
    -- 
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" }, -- disabled by matt @ 10/23/2025 4:21:22 PM
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false, -- TODO: test in future @ Matt
  },
}
-- CopilotChat.nvim setup lua
-- local utils = require('CopilotChat.config.utils')
-- local icons = require('config.icons')
-- utils.desc('<leader>a', 'AI')

-- Copilot autosuggestions
-- vim.g.copilot_no_tab_map = true
vim.g.copilot_proxy                  = 'http://localhost:11435'
vim.g.copilot_proxy_strict_ssl       = false
vim.g.copilot_hide_during_completion = false
vim.g.copilot_no_tab_map             = true

-- Copilot chat
-- Mistral AI (gregoryconsulting.info)
require('CopilotChat.config').providers.mistral = {
    prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
    prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,

    get_headers = function()
        local api_key = assert(os.getenv('MISTRAL_API_KEY'), 'MISTRAL_API_KEY env not set')
        return {
            Authorization = 'Bearer ' .. api_key,
            ['Content-Type'] = 'application/json',
        }
    end,

    get_models = function(headers)
        local response, err = require('CopilotChat.utils').curl_get('https://api.mistral.ai/v1/models', {
            headers = headers,
            json_response = true,
        })

        if err then
            error(err)
        end

        return vim.iter(response.body.data)
            :filter(function(model)
                return model.capabilities.completion_chat
            end)
            :map(function(model)
                return {
                    id = model.id,
                    name = model.name,
                }
            end)
            :totable()
    end,

    get_url = function()
        return 'https://api.mistral.ai/v1/chat/completions'
    end,
}
-- Open AI (Chat GPT)
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
require('CopilotChat.config').providers.openai = {
    prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
    prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

    get_url = function() return "https://api.openai.com/v1/chat/completions" end,

    get_headers = function()
        local api_key = assert(os.getenv("OPENAI_API_KEY"), "OPENAI_API_KEY env var not set")
        return {
            Authorization = "Bearer " .. api_key,
            ["Content-Type"] = "application/json",
        }
    end,

    get_models = function(headers)
        local response, err =
            require("CopilotChat.utils").curl_get("https://api.openai.com/v1/models", {
                headers = headers,
                json_response = true,
            })
        if err then error(err) end
        return vim
            .iter(response.body.data)
            :filter(function(model)
                local exclude_patterns = {
                    "audio",
                    "babbage",
                    "dall%-e",
                    "davinci",
                    "embedding",
                    "image",
                    "moderation",
                    "realtime",
                    "transcribe",
                    "tts",
                    "whisper",
                }
                for _, pattern in ipairs(exclude_patterns) do
                    if model.id:match(pattern) then return false end
                end
                return true
            end)
            :map(
                function(model)
                    return {
                        id = model.id,
                        name = model.id,
                    }
                end
            )
            :totable()
    end,
}
-- Ollama (local or private vhost LLM of most types / unlimited $20 services)
require('CopilotChat.config').providers.ollama = {
    prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
    prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,

    get_models = function(headers)
        local response, err = require('CopilotChat.utils').curl_get('http://localhost:11434/v1/models', {
            headers = headers,
            json_response = true,
        })

        if err then
            error(err)
        end

        return vim.tbl_map(function(model)
            return {
                id = model.id,
                name = model.id,
            }
        end, response.body.data)
    end,

    get_url = function()
        return 'http://localhost:11434/v1/chat/completions'
    end,
}
local chat = require('CopilotChat')
chat.setup({
    model = 'deepseek-v3.1:671b-cloud',
    -- model = 'gpt-oss:120b-cloud',
    -- model = 'qwen3-coder:480b-cloud', -- claude-2, claude-instant-100k, gpt-4o, gpt-4o-mini, gpt-4o-2024-08-06, gemma3:1b
    api_endpoint = "http://localhost:11434/v1/chat/completions", -- Replace with the actual endpoint
    api_key = assert(os.getenv("OPENAI_API_KEY"), "OPENAI_API_KEY env var not set"), -- If authentication is required
    temperature = 0.7, -- Adjust as needed
    max_tokens = 1024, -- Adjust as needed
    timeout = 30000, -- Timeout in milliseconds
    -- system_prompt = "You are an expert coding assistant.", -- Customize as needed
    -- model = 'Claude sonnet-1.3', -- claude-2, claude-instant-100k, gpt-4o, gpt-4o-mini, gpt-4o-2024-08-06, gemma3:1b
    -- model = '1', -- claude-2, claude-instant-100k, gpt-4o, gpt-4o-mini, gpt-4o-2024-08-06, gemma3:1b
    debug = true,
    -- temperature = 0,
    temperature = 0.3,           -- Lower = focused, higher = creative
    window = {
        layout = 'float',       -- 'vertical', 'horizontal', 'float'
        -- width = 0.5,              -- 50% of screen width
        width = 80, -- Fixed width in columns
        height = 20, -- Fixed height in rows
        border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        title = '🤖 AI Assistant',
        zindex = 100, -- Ensure window stays on top
        },
    headers = {
        user = '👤 You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
        },
    separator = '━━',
    auto_fold = true, -- Automatically folds non-assistant messages
    auto_insert_mode = false,     -- Enter insert mode when opening
   -- sticky = {
   --     '#buffers',
   -- },
    chat_autocomplete = true,
    auto_fold = true,
--     headers = {
--         user = icons.ui.User,
--         assistant = icons.ui.Bot,
--         tool = icons.ui.Tool,
--     },
    providers = {
      -- ollamastream = {
        -- get_url = function()
        --     return 'http://localhost:11434/v1/chat/completions'
        -- end,
      --  get_url = function(opts) return "http://localhost:11434" end,
      --  -- get_url = function() return 'http://localhost:11434/v1/chat/completions' end,
      --  -- get_headers = function() return { ["Authorization"] =--Bearer-- .. api_key } end,
      --  get_models = function() return {
      --    { id = "deepseek-r1:latest", name = "deepseek-r1:latest" },
      --    { id = "testing:latest", name = "testing:latest" },
      --    { id = "dolphin3:8b", name = "dolphin3:8b" },
      --    { id = "dolphin-mixtral:8x7b", name = "dolphin-mixtral:8x7b" },
      --    { id = "dolphin-mixtral:8x22b", name = "dolphin-mixtral:8x22b" },
      --    { id = "gemma3:1b", name = "gemma3:1b" },
      --    { id ="qwen3-coder:480b-cloud", name ="qwen3-coder:480b-cloud" }
      --  } end,

        -- get_models = function() return { { id = "gemma3:1b", name = "gemma3:1b" }, { id ="qwen3-coder:480b-cloud", name ="qwen3-coder:480b-cloud" } } end,
        -- get_models = function() return { { id ="qwen3-coder:480b-cloud", name ="qwen3-coder:480b-cloud" } } end,
      --   prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
      --   prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,
      -- }
    },

    mappings = {
        reset = false,
        complete = {
            insert = '<S-Tab>',
        },
        show_diff = {
            full_diff = true,
        },
    },
    prompts = {
        Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
        },
        Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
        },
        Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
        },
        Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
        },
        Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
        },
        Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
        },
        Commit = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
        },
    }
    -- providers = {
    --   ollama = {
    --     get_url = function(opts) return "http://127.0.0.1:11434" end,
    --     -- get_headers = function() return { ["Authorization"] = "Bearer " .. api_key } end,
    --     get_models = function() return {
    --         { id = "deepseek-r1:latest", name = "deepseek-r1:latest" },
    --         { id = "testing:latest", name = "testing:latest" },
    --         { id = "dolphin3:8b", name = "dolphin3:8b" },
    --         { id = "dolphin-mixtral:8x7b", name = "dolphin-mixtral:8x7b" },
    --         { id = "dolphin-mixtral:8x22b", name = "dolphin-mixtral:8x22b" },
    --         { id = "gemma3:1b", name = "gemma3:1b" }
    --     } end,
    --     prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
    --     prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,
    --   },
    --   github_models = {
    --     get_models = function() return {
    --         { id = "gpt-4o", name = "gpt-4o" },
    --         { id = "gpt-4o-mini", name = "gpt-4o-mini" },
    --         { id = "gpt-4o-2024-08-06", name = "gpt-4o-2024-08-06" },
    --         { id = "claude-2", name = "claude-2" },
    --         { id = "claude-instant-100k", name = "claude-instant-100k" },
    --     } end,
    --     disabled = false,
    --   },
    -- },
})

-- Setup extensions
-- require('config.copilot_extensions')

-- Setup buffer
-- utils.au('BufEnter', {
--     pattern = 'copilot-*',
--     callback = function()
--         vim.opt_local.relativenumber = false
--         vim.opt_local.number = false
--     end,
-- })
-- Without Extensions:
-- Auto-command to customize chat buffer behavior
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
    end,
})

-- Setup additional keymaps
vim.keymap.set({ 'n' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
vim.keymap.set({ 'v' }, '<leader>aa', chat.open, { desc = 'AI Open' })
vim.keymap.set({ 'n' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
vim.keymap.set({ 'n' }, '<leader>as', chat.stop, { desc = 'AI Stop' })
vim.keymap.set({ 'n' }, '<leader>am', chat.select_model, { desc = 'AI Models' })
vim.keymap.set({ 'n', 'v' }, '<leader>ap', chat.select_prompt, { desc = 'AI Prompts' })
vim.keymap.set({ 'n', 'v' }, '<leader>al', function()
    vim.ui.input({ prompt = 'AI Session Load> ', },
        function(input)
            if input ~= '' then
                chat.load(input)
            end
        end)
    end, { desc = 'AI Session Load' })
vim.keymap.set({ 'n', 'v' }, '<leader>aq', function()
    vim.ui.input({ prompt = 'AI Question> ', },
        function(input)
            if input ~= '' then
                chat.ask(input)
            end
        end)
    end, { desc = 'AI Question' })

-- MCP hub
-- require('mcphub').setup({
--     extensions = {
--         copilotchat = {
--             enabled = true,
--             convert_tools_to_functions = true,
--             convert_resources_to_functions = true,
--             add_mcp_prefix = false,
--         },
--     },
-- })
--END_CHAT_SETUP
EOF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LUA DONE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" END OF FILE, NOW SET GUI no ginit.vim but init_igui.vim
" SkyLeach Note: source init_igui.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" After pathogen final mappings loaded from postinfet - 5/1/2025 12:40:45 AM
let g:postinfect = stdpath('config')."/postinfect_inject.vim"
execute 'source ' . g:postinfect
let g:gui_xtra_cfg = stdpath('config')."/init_igui.vim"
execute 'source ' . g:gui_xtra_cfg
let g:tokyocandy = stdpath('config')."/tokyoenable.vim"
execute 'source ' . g:tokyocandy
" Load the colorscheme
" colorscheme one
" colorscheme one-dark
" colorscheme onedark
" colorscheme onehalfdark
" colorscheme onehalflight
" colorscheme one
" colorscheme tokyonight
" colorscheme tokyonight-day
" colorscheme tokyonight-moon
" colorscheme tokyonight-night
" colorscheme tokyonight-storm
" colorscheme kanagawa-dragon
" colorscheme kanagawa-wave
" colorscheme kanagawa-lotus
colorscheme kanagawa
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"             END OF FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
