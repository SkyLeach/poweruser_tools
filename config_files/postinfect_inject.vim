" Repeat or consolodate a few commands that *must* be called (or called again)
" after pathogen 'infects' vim with plugins due to default remapping.
" Sometimes it's just too much dang work to figure out which plugin has a
" default mapping that's stepping on your preferences :-D.

" SkyLeach NOTE: additional coc settings for coc-snip and coc-ultisnip
" SkyLeach Update Note 10/10/2024 1:16:54 AM - duplicated and doesn't match docs... not working too
" inoremap <silent><expr> <c-TAB>
"   \ pumvisible() ? coc#_select_confirm() :
"     \ coc#expandableOrJumpable() ?
"       \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"     \ <SID>check_back_space() ? "\<c-TAB>" :
"     \ coc#refresh()
"
" let g:coc_snippet_next = '<c-tab>'

" SkyLeach Note: CocSnippet take over... maps must be at end of file due to
" infection override of mapping by idk what plugin (gah!)
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: CocSnippet take over... maps must be at end of file due to
" infection override of mapping by idk what plugin (gah!)
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" SkyLeach NOTE: additional coc settings for coc-snip and coc-ultisnip
" SkyLeach Update Note 10/10/2024 1:16:54 AM - duplicated and doesn't match docs... not working too
" inoremap <silent><expr> <c-TAB>
"   \ pumvisible() ? coc#_select_confirm() :
"     \ coc#expandableOrJumpable() ?
"       \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"     \ <SID>check_back_space() ? "\<c-TAB>" :
"     \ coc#refresh()
"
" let g:coc_snippet_next = '<c-tab>'

" SkyLeach Note: CocSnippet take over... maps must be at end of file due to
" infection override of mapping by idk what plugin (gah!)
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc-translator settings
" SkyLeach
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: do NOT use `nore` mappings
" popup
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)
" echo
nmap <Leader>e <Plug>(coc-translator-e)
vmap <Leader>e <Plug>(coc-translator-ev)
" replace
nmap <Leader>r <Plug>(coc-translator-r)
vmap <Leader>r <Plug>(coc-translator-rv)

" # coc-translator - 5/6/2025 11:46:53 PM
" nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>
