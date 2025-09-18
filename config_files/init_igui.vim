""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: Save window size and position, all GUI interfaces
" To enable the saving and restoring of screen positions.
let g:screen_size_restore_pos = 1

" To save and restore screen for each Vim instance.
" This is useful if you routinely run more than one Vim instance.
" For all Vim to use the same settings, change this to 0.
let g:screen_size_by_vim_instance = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SkyLeach Note: gui settings that, for whatever reason, aren't working within
" ginit.vim.
if exists('g:fvim_loaded') && g:fvim_loaded
    " echom "Fvim ginit settings being applied..."
    " good old 'set guifont' compatibility
    " set guifont=Iosevka\ Slab:h14
    " set guifont=Mononoki\ Nerd\ Font\ Mono:h14 " like it
    " set guifont=Anonymice\ Nerd\ Font\ Mono:h14 " like it
    " set guifont=Anonymice\ Nerd\ Font:h14
    " set guifont=CodeNewRoman\ Nerd\ Font:h14 " love it
    set guifont=CodeNewRoman\ Nerd\ Font\ Mono:h14 " Love it
    " set guifont=DaddyTimeMono\ Nerd\ Font:h14 " love it
    " set guifont=DaddyTimeMono\ Nerd\ Font\ Mono:h14 " Love it
    " set guifont=FantasqueSansMono\ Nerd\ Font:h14 " love it
    " set guifont=FantasqueSansMono\ Nerd\ Font\ Mono:h14 " Love it
    " set guifont=OpenDyslexicMono\ NF:h14
    " set guifont=TerminessTTF\ Nerd\ Font:h14
    " Ctrl-ScrollWheel for zooming in/out
    " nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    " nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    " nnoremap <A-CR> :FVimToggleFullScreen<CR>
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
    " Toggle between normal and fullscreen
    " FVimToggleFullScreen

    " Cursor tweaks
    " FVimCursorSmoothMove v:true
    " FVimCursorSmoothBlink v:true

    " Background composition
    " TODO: find out why rpcnotify throws errors here
    " FVimBackgroundComposition 'acrylic'   " 'none', 'blur' or 'acrylic'
    " FVimBackgroundOpacity 0.85            " value between 0 and 1, default bg opacity.
    " FVimBackgroundAltOpacity 0.85         " value between 0 and 1, non-default bg opacity.
    " FVimBackgroundImage 'C:/foobar.png'   " background image
    " FVimBackgroundImageVAlign 'center'    " vertial position, 'top', 'center' or 'bottom'
    " FVimBackgroundImageHAlign 'center'    " horizontal position, 'left', 'center' or 'right'
    " FVimBackgroundImageStretch 'fill'     " 'none', 'fill', 'uniform', 'uniformfill'
    " FVimBackgroundImageOpacity 0.85       " value between 0 and 1, bg image opacity

    " Title bar tweaks
    " FVimCustomTitleBar v:true             " themed with colorscheme

    " Debug UI overlay
    " FVimDrawFPS v:true

    " Font tweaks
    " FVimFontAntialias v:true
    " FVimFontAutohint v:true
    " FVimFontHintLevel 'full'
    " FVimFontLigature v:true
    " FVimFontLineHeight '+1.0' " can be 'default', '14.0', '-1.0' etc.
    " FVimFontSubpixel v:true
    " FVimFontNoBuiltInSymbols v:true " Disable built-in Nerd font symbols

    " Try to snap the fonts to the pixels, reduces blur
    " in some situations (e.g. 100% DPI).
    " FVimFontAutoSnap v:true

    " Font weight tuning, possible valuaes are 100..900
    " FVimFontNormalWeight 400
    " FVimFontBoldWeight 700

    " Font debugging -- draw bounds around each glyph
    " FVimFontDrawBounds v:true

    " UI options (all default to v:false)
    " FVimUIMultiGrid v:false     " per-window grid system -- work in progress
    " FVimUIPopupMenu v:true      " external popup menu
    " FVimUITabLine v:false       " external tabline -- not implemented
    " FVimUICmdLine v:false       " external cmdline -- not implemented
    " FVimUIWildMenu v:false      " external wildmenu -- not implemented
    " FVimUIMessages v:false      " external messages -- not implemented
    " FVimUITermColors v:false    " not implemented
    " FVimUIHlState v:false       " not implemented

    " Detach from a remote session without killing the server
    " If this command is executed on a standalone instance,
    " the embedded process will be terminated anyway.
    " FVimDetach
elseif exists('g:neovide') && g:neovide
    " echom "neovide loaded, setting guifont, transparency & xtra_buffer_frames"
  if exists('g:started_by_firenvim') && g:started_by_firenvim
      set guifont=FiraCode\ NF:h8
      " set guifont=DaddyTimeMono\ Nerd\ Font\ Mono:h8 " Love it
  else
    set guifont=FiraCode\ NF:h14 " love it
    " set guifont=DaddyTimeMono\ NF:h14 " love it
    " set guifont=Hack\ NF:h14
    " set guifont=CodeNewRoman\ NF:h14 " Love it
  endif
  " set guifont=CodeNewRoman\ Nerd\ Font\ Mono:h14 " Love it
  let g:neovide_opacity=0.95
  let g:neovide_extra_buffer_frames=4
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
  " let g:neovide_cursor_vfx_mode="wireframe"
  " let g:neovide_cursor_vfx_mode="ripple"
  " let g:neovide_cursor_vfx_mode="sonicboom"
  let g:neovide_cursor_vfx_mode="torpedo"
  " let g:neovide_cursor_vfx_mode="railgun"
  " let g:neovide_cursor_vfx_mode="pixiedust"
  let g:neovide_cursor_vfx_particle_lifetime = 1.8
  let g:neovide_cursor_vfx_particle_speed = 8.0
  let g:neovide_cursor_vfx_particle_phase = 1.8
  let g:neovide_cursor_vfx_particle_curl = 1.8
  let g:neovide_cursor_vfx_particle_density = 10.0
  let g:neovide_cursor_vfx_opacity = 70.0
  let g:neovide_remember_window_size=v:true
  let g:neovide_cursor_antialiasing=v:true
  let g:neovide_position_animation_length = 0.15
  let g:neovide_scroll_animation_length = 0.15
  let g:neovide_scroll_animation_far_lines = 100
  let g:neovide_cursor_trail_size = 0.5
  let g:neovide_cursor_animate_in_insert_mode = v:true
  let g:neovide_cursor_animate_command_line = v:true
  let g:neovide_cursor_smooth_blink = v:true
  let g:neovide_hide_mouse_when_typing = v:true
  let g:experimental_layer_grouping = v:true
  " Obv. only set this if you're trying to debug/work on neovide
  let g:neovide_profiler = v:false
elseif exists('g:gonvim_loaded')
    " echom "gonvim_loaded calling Guifont"
  " if exists('g:started_by_firenvim') && g:started_by_firenvim
  "     set guifont=Guifont\ Mononoki\ Nerd\ Font\ Mono:h8 " Love it
  " els
  "   " Guifont Mononoki\ Nerd\ Font\ Mono:h12
  "   set guifont=Guifont\ Mononoki\ Nerd\ Font\ Mono:h12 " love it
  " endif
" elseif exists('g:started_by_firenvim') && g:started_by_firenvim
"     set guifont=CodeNewRoman\ Nerd\ Font\ Mono:h12 " Love it
else
  " good old 'set guifont' compatibility
  " set guifont=Iosevka\ Slab:h14
  " set guifont=Mononoki\ Nerd\ Font\ Mono:h22 " like it
  " set guifont=Anonymice\ Nerd\ Font\ Mono:h22 " like it
  " set guifont=Anonymice\ Nerd\ Font:h22
  " set guifont=CodeNewRoman\ Nerd\ Font:h22 " love it
  if exists('g:started_by_firenvim') && g:started_by_firenvim
    set guifont=DaddyTimeMono\ Nerd\ Font\ Mono:h10 " Love it
  else
    set guifont=DaddyTimeMono\ Nerd\ Font\ Mono:h14 " love it
  endif
  " set guifont=CodeNewRoman\ Nerd\ Font\ Mono:h12 " Love it
  " set guifont=DaddyTimeMono\ Nerd\ Font:h22 " love it
  " set guifont=DaddyTimeMono\ Nerd\ Font\ Mono:h22 " Love it
  " set guifont=FantasqueSansMono\ Nerd\ Font:h22 " love it
  " set guifont=FantasqueSansMono\ Nerd\ Font\ Mono:h22 " Love it
  " set guifont=OpenDyslexicMono\ NF:h22
  " set guifont=TerminessTTF\ Nerd\ Font:h14
  " Guifont Mononoki\ Nerd\ Font\ Mono:h22
  " SkyLeach NOTE: sourcing veonim-specific settings (multi-GUI setup)
  " SkyLeach NOTE: disabled until set up
  " source '$HomePath\AppData\Local\nvim\veonim_init.vim'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IGNORE BETWEEN - (doesn't work for neovide, maybe gvim?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" | " this one doesn't seem to work because of && `g:neovide )`
" | " if has("gui_running") || ( exists('g:neovide') && g:neovide )
" | " so... dropped
" | if has("gui_running") || exists('g:neovide')
" |   function! ScreenFilename()
" |     if has('amiga')
" |       return "s:.vimsize"
" |     elseif has('win32')
" |       return $HOME.'\_vimsize'
" |     else
" |       return $HOME.'/.vimsize'
" |     endif
" |   endfunction
" | 
" |   function! ScreenRestore()
" |     " Restore window size (columns and lines) and position
" |     " from values stored in vimsize file.
" |     " Must set font first so columns and lines are based on font size.
" |     let f = ScreenFilename()
" |     if g:screen_size_restore_pos && filereadable(f)
" |       let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
" |       for line in readfile(f)
" |         let sizepos = split(line)
" |         if len(sizepos) == 5 && sizepos[0] == vim_instance
" |           silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
" |           silent! execute "winpos ".sizepos[3]." ".sizepos[4]
" |           return
" |         endif
" |       endfor
" |     endif
" |   endfunction
" | 
" |   function! ScreenSave()
" |     " Save window size and position.
" |     if g:screen_size_restore_pos
" |       let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
" |       let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
" |             \ (getwinposx()<0?0:getwinposx()) . ' ' .
" |             \ (getwinposy()<0?0:getwinposy())
" |       let f = ScreenFilename()
" |       if filereadable(f)
" |         let lines = readfile(f)
" |         call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
" |         call add(lines, data)
" |       else
" |         let lines = [data]
" |       endif
" |       call writefile(lines, f)
" |     endif
" |   endfunction
" | 
" |   if !exists('g:screen_size_restore_pos')
" |     let g:screen_size_restore_pos = 
" |   endif
" |   if !exists('g:screen_size_by_vim_instance')
" |     let g:screen_size_by_vim_instance = 1
" |   endif
" |   autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
" |   autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
" | endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IGNORE BETWEEN - (doesn't work for neovide, maybe gvim?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
