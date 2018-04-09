#!/usr/bin/env bash
# vim: ts=4 sw=4 sts=4 et nofoldenable
if [ -z "${VIMHOME}" ] && [ -z "${NVIMHOME}" ]; then 
    echo "Cowardly refusing to do anything because you haven't set VIMHOME." 
    exit -1
fi
cwd_save=$(pwd)
vidr=''
[[ -z "${NVIMHOME}" ]] && vdir="${VIMHOME}" || vdir="${NVIMHOME}"
cd "${vdir}"
cd ./bundle || ( mkdir ./bundle && cd ./bundle )
[[ "$?" -ne "0" ]] && ( echo "Unable to make or find bundle path." && exit -1 )
echo got here at least
echo "$(pwd)"
git clone https://github.com/cohama/agit.vim
git clone https://github.com/w0rp/ale.git
git clone https://github.com/vim-scripts/Align
git clone https://github.com/prabirshrestha/async.vim
git clone https://github.com/prabirshrestha/asyncomplete-lsp.vim
git clone https://github.com/prabirshrestha/asyncomplete.vim
git clone https://github.com/jlanzarotta/bufexplorer
git clone https://github.com/vim-scripts/dbext.vim
git clone https://github.com/zchee/deoplete-jedi
git clone https://github.com/Shougo/deoplete.nvim
git clone https://github.com/Yggdroot/LeaderF
git clone https://github.com/mattn/livestyle-vim
git clone https://github.com/JalaiAmitahl/maven-compiler.vim
git clone http://github.com/yegappan/mru
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/rhysd/nyaovim-markdown-preview
git clone https://github.com/rhysd/nyaovim-mini-browser
git clone https://github.com/rhysd/nyaovim-popup-tooltip
git clone https://github.com/aklt/plantuml-syntax
git clone https://github.com/Rykka/riv.vim
git clone https://github.com/vim-scripts/SQLUtilities
git clone https://github.com/ervandew/supertab
git clone https://github.com/vim-airline/vim-airline
git clone https://github.com/flazz/vim-colorschemes
git clone https://github.com/jtratner/vim-flavored-markdown
git clone git://github.com/tpope/vim-fugitive.git
git clone https://github.com/raghur/vim-ghost
git clone https://github.com/tfnico/vim-gradle
git clone https://github.com/pangloss/vim-javascript
git clone https://github.com/lepture/vim-jinja
git clone https://github.com/elzr/vim-json
git clone https://github.com/dbakker/vim-lint.git
git clone https://github.com/tetsuo13/Vim-log4j
git clone https://github.com/prabirshrestha/vim-lsp
git clone https://github.com/tpope/vim-markdown
git clone https://github.com/xolox/vim-misc
git clone https://github.com/sloria/vim-ped
git clone https://github.com/heavenshell/vim-pydocstring
git clone https://github.com/xolox/vim-session
git clone git://github.com/tpope/vim-surround.git
git clone https://github.com/tmux-plugins/vim-tmux-focus-events
git clone http://github.com/rkitover/vimpager
cd "${cwd_save}"
exit 0
