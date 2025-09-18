inoremap <silent> <S-Insert>  <C-R>+
cnoremap <S-Insert> <C-R>+
nnoremap <silent> <C-6> <C-^>
" neovim-qt
if exists('g:GuiLoaded')
  " call GuiWindowMaximized(1)
  GuiTabline 0
  GuiPopupmenu 0
  GuiLinespace 2
  Guifont Mononoki\ Nerd\ Font\ Mono:h18:1
  " GuiFont! Hack:h10:l
endif

