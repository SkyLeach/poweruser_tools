# vim: ts=4 sts=4 sw=4 et ft=sh

# base OS detection, do NOT touch this
unameOut="$(uname -s)"
# check for wsl
kernel_name="$(uname -r)"
case "${unameOut}" in
    Linux*)     
        [[ $(uname -r | grep -oi microsoft) ]] && platform=wsl || platform=linux;;
    Darwin*)    platform=darwin;;
    CYGWIN*)    platform=cygwin;;
    MINGW*)     platform=mingw;;
    BSD*)       platform=bsd;;
    *)          platform="UNKNOWN:${unameOut}"
esac

# OSX path_helper is really annoying
# this MUST be at the very top of the .bash_profile, immediately after os detection
# see https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
if [[ -f /etc/profile ]] && [[ "${platform}" == 'darwin' ]]; then
    # shellcheck disable=SC2123
    PATH=''
    source /etc/profile
    # just in case it's still fucking with sanity...
    [[ -z "${PATH}" ]] && export PATH='/bin:/usr/bin:/sbin:/usr/sbin'
fi

# WSL portable environment variables (essential for developers really)
# see https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/
# /p - translated path
# /l - list of translated paths (like PATH)
# /u - only WSL -> Win32
# /w - only Win32 -> WSL
export POSH_THEMES_PATH='/mnt/c/Users/mattg/.cache/oh-my-posh/themes'
if [[ -f /etc/profile ]] && [[ "${platform}" == 'wsl' ]]; then
    [ -z "${WSLENV}" ] && export WSLENV="1"
    # [ -z "${WSLENV}" ] && export WSLENV="JAVA_HOME/p:CLASSPATH/l:HomePath/pu"
    eval "$(dircolors -b ~/.dircolors.wsl)"
    # store the IP of the host for the VM
    export WSL_HOST_IP=$(awk '/nameserver/ { print $2 }' /etc/resolv.conf)
    # also set the display for wsl2<->windows xorg (and clipboard)
    export DISPLAY="${WSL_HOST_IP}:0.0"
    unset $( env | grep -E '^(ALLUSERSPROFILE|APPDATA|CommonProgramFiles|CommonProgramFiles(x86)?|COMPUTERNAME|ComSpec|HOMEDRIVE|HOMEPATH|LOCALAPPDATA|LOGONSERVER|NUMBER_OF_PROCESSORS|OS|Path|PATHEXT|PROCESSOR_ARCHITECTURE|PROCESSOR_IDENTIFIER|PROCESSOR_LEVEL|PROCESSOR_REVISION|ProgramData|ProgramFiles(x86)?|PROMPT|PSModulePath|PUBLIC|SystemDrive|SystemRoot|TEMP|TMP|USERDOMAIN|USERDOMAIN_ROAMINGPROFILE|USERNAME|USERPROFILE|WINDIR)=' | awk -F= '{print $1}' )
    # pipe env through awk to strip the values from the envvars
    # env | awk -F= '{print $1}'
else
    eval "$(dircolors -b)"
fi

#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------
# export PS1=$'_\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620_\n| \[\033[01;32m\]\\u@\\h\[\033[00m\]:\[\033[01;34m\]\\w\[\033[00m\] \n|\u2623> '
# export PS2=$'|\u2623>'
# export PS1="_☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠_\\n| \\w @ work-mbp (abuser) \\n|\\T💀> "
# export PS2="|💀> "
export TMUX_PLUGIN_MANAGER_PATH=${HOME}/.tmux/plugins
export DISPLAY=':0.0'
if [[ "${platform}" == "cygwin" ]]; then
    export PS1=$'_\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620__\u2620_\n| \[\033[01;32m\]\\u@\\h\[\033[00m\]:\[\033[01;34m\]\\w\[\033[00m\] \n|\u2623> '
    export PS2=$'|\u2623>'
    # For some reason I keep getting "CONFIG ERROR" when trying to use oh-my-posh from within cygwin?
    # eval $(/cygdrive/c/Program\ Files\ \(x86\)/oh-my-posh/bin/oh-my-posh init bash --config $POSH_THEMES_PATH/sonicboom_dark.omp.json)
    export CYGWIN=winsymlinks:nativestrict
fi
#   Set Paths
#   ------------------------------------------------------------
# needed below.  Leave
if [ -z $SHELL ]; then  #  - do not change $SHELL if already set
    if [ -x /usr/local/bin/bash ]; then
        export SHELL='/usr/local/bin/bash'
    elif [ -x /usr/bin/bash ]; then
        export SHELL='/usr/bin/bash'
    else
        export SHELL='/bin/bash'
    fi
fi
# start building out path requirements
# priority goes up as the list goes down the line
[[ ":$PATH:" != *":/bin:"* ]] && export PATH="/bin:${PATH}"
[[ ":$PATH:" != *":/sbin:"* ]] && export PATH="/sbin:${PATH}"
[[ ":$PATH:" != *":/usr/bin:"* ]] && export PATH="/usr/bin:${PATH}"
[[ ":$PATH:" != *":/usr/sbin:"* ]] && export PATH="/usr/sbin:${PATH}"
[[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:${PATH}"
[[ ":$PATH:" != *":${HOME}/bin:"* ]] && export PATH="${HOME}/bin:${PATH}"
# these only make sense for darwin where conflicts can happen
if [[ "${platform}" == "darwin" ]]; then
    [[ ":$PATH:" != *":/sw/bin:"* ]] && export PATH="/sw/bin:${PATH}"
    [[ ":$PATH:" != *":/usr/local/opt/openssl/bin:"* ]] && export PATH="/usr/local/opt/openssl/bin:${PATH}"
    [[ ":$PATH:" != *":/usr/local/Cellar/git/2.17.0/bin:"* ]] && export PATH="/usr/local/Cellar/git/2.17.0/bin:${PATH}"
    [[ ":$PATH:" != *":/usr/local/opt/mysql/bin:"* ]] && export PATH="/usr/local/opt/mysql/bin:${PATH}"
    [[ ":$PATH:" != *":/usr/local/opt/libxml2/bin:"* ]] && export PATH="/usr/local/opt/libxml2/bin:${PATH}"
    [[ ":$PATH:" != *":/usr/local/opt/ruby/bin:"* ]] && export PATH="/usr/local/opt/ruby/bin:${PATH}"
    # I think this may have broken a lot of stuff
    # [[ ":$PATH:" != *":/usr/local/opt/qt@5.5/bin:"* ]] && export PATH="/usr/local/opt/qt@5.5/bin:${PATH}"
    # so I'm replacing it with the newer one...
    [[ ":$PATH:" != *":/usr/local/opt/qt/bin:"* ]] && export PATH="/usr/local/opt/qt/bin:${PATH}"
elif [[ "${platform}" == "wsl" ]]; then
    # in WSL environments make sure the standard windows programs are available
    [[ ":$PATH:" != *":/mnt/c/Windows:"* ]] && export PATH="${PATH}:/mnt/c/Windows/System32:/mnt/c/Windows:/mnt/c/Windows/System"
    # NOTE: check if symbolic link to script is in home and ready for path
    if [[ ! -e "${HOME}/sbin" ]]; then
        ln -sf "$/mnt/f/src/poweruser_tools/scripts" ${HOME}/sbin
    fi
    eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/sonicboom_dark.omp.json)"
fi
[[ ":$PATH:" != *":/usr/local/sbin:"* ]] && export PATH="/usr/local/sbin:${PATH}"
[[ ":$PATH:" != *":${HOME}/sbin:"* ]] && export PATH="${HOME}/sbin:${PATH}"
[[ ":$PATH:" != *":${HOME}/.local/bin:"* ]] && export PATH="${HOME}/.local/bin:${PATH}"
export TEMP="${HOME}/AppData/Local/Temp"
# Add QT to the path, but after system
# and make sure it's 5.5 due to linker issues
# legacy/secondary darwinports
if [[ "${platform}" == "cygwin" ]]; then
    export CONV_TOOL='cygpath'
elif [[ "${platform}" == "cygwin" ]]; then 
    export CONV_TOOL='wslpath'
fi
[ -z "$JAVA_HOME" ] || JAVA_HOME=$("${CONV_TOOL}" -u "\"${JAVA_HOME}\"")
[ -z "$CLASSPATH" ] || CLASSPATH=$("${CONV_TOOL}" -u "\"${CLASSPATH}\"")
#    LDFLAGS:  -L/usr/local/opt/libxml2/lib
#    CPPFLAGS: -I/usr/local/opt/libxml2/include
#    LDFLAGS:  -L/usr/local/opt/qt/lib
#    CPPFLAGS: -I/usr/local/opt/qt/include
#For pkg-config to find this software you may need to set:
#    PKG_CONFIG_PATH: /usr/local/opt/libxml2/lib/pkgconfig

if [[ "${platform}" == "darwin" ]]; then
    [[ -z "${brew_prefix}" ]] && brew_prefix=$(brew --prefix)
else
    # yeah, it's a hack.  TODO: make this more portable?
    brew_prefix="/usr/local"
fi

# dunno why repack suggested, but add it if necessary
if [[ "${platform}" == "darwin" ]]; then
    localpkgconfig="/usr/local/lib/pkgconfig"
    pkgimportprefix=":/usr/local/opt"
    # localpkgconfig+=":${pkgimportprefix}/atk/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/bash/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/cairo/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/ffmpeg/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/ffmpeg@3/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/fftw/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/fontconfig/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/freeglut/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/freetype/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/fribidi/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gdk-pixbuf/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/glew/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/glib/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gnu-scientific-library/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gobject-introspection/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/graphite2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gsl/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gtk/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gtk+/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/gtk+3/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/harfbuzz/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/icu4c/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/ilmbase/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/isl/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/jemalloc/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/jpeg/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libarchive/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libass/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libcdio/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libevent/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libffi/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libidn2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libjpeg/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libjpg/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libogg/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libpng/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libtermkey/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libtiff/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libusb/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libuv/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libvorbis/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libvpx/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libvterm/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libxml2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/libxml2@2.9/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/luajit/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/lz4/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/lzo/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/mpfr/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/msgpack/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/mysql/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/mysql@5.7/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/oniguruma/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/opencv/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/opencv@3/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/openexr/lib/pkgconfig"
    localpkgconfig+=":${pkgimportprefix}/openssl/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/openssl@1.0/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/openssl@1.1/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/opus/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/opusfile/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/pango/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/pcre/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/pcre1/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/pixman/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/postgres/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/postgresql/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/postgresql@10.2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/python/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/python2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/python3/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/python@2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/python@3/lib/pkgconfig"
    localpkgconfig+=":${pkgimportprefix}/qt/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/qt@5.5/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/qt@5.10/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/qt@5.9/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/sqlite/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/sqlite3/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/theora/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/unibilium/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/x264/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/xz/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/sdl2/lib/pkgconfig"
    # localpkgconfig+=":${pkgimportprefix}/mlt/lib/pkgconfig"
elif [[ "${platform}" == "wsl" ]]; then
    localpkgconfig="/usr/share/pkgconfig"
    pkgimportprefix="${localpkgconfig}"
    # localpkgconfig+=":${pkgimportprefix}/adwaita-icon-theme.pc"
    # localpkgconfig+=":${pkgimportprefix}/bash-completion.pc"
    # localpkgconfig+=":${pkgimportprefix}/iso-codes.pc"
    # localpkgconfig+=":${pkgimportprefix}/nautilus-python.pc"
    # localpkgconfig+=":${pkgimportprefix}/shared-mime-info.pc"
    # localpkgconfig+=":${pkgimportprefix}/systemd.pc"
    # localpkgconfig+=":${pkgimportprefix}/udev.pc"
    # localpkgconfig+=":${pkgimportprefix}/xbitmaps.pc"
    # localpkgconfig+=":${pkgimportprefix}/xkeyboard-config.pc"
fi
if [ -z "${pkgimportprefix}" ]; then
    # tempt dissable extras and try to write script to minimize imports
    #
    # if ever a need, put in an else and drop the following outside the condition
    if [ -z "${PKG_CONFIG_PATH}" ]; then
        export PKG_CONFIG_PATH="${localpkgconfig}"
    else
        export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${localpkgconfig}"
    fi
fi
# By default use python3 since EOL for 2.7 is 2020
if [[ "${platform}" == "darwin" ]]; then
    if [ -z "${PYTHONPATH}" ]; then
        PYTHONPATH="${brew_prefix}/python"
    else
        PYTHONPATH="${PYTHONPATH}:${brew_prefix}/python"
    fi
else
    if [ -z "${PYTHONPATH}" ]; then
        export PYTHONPATH="/usr/lib/python3"
    else
        export PYTHONPATH="${PYTHONPATH}:/usr/lib/python3"
    fi
fi
export PYTHONPATH
instaclient_version='12_1'
ORACLE_HOME="${HOME}/Library/oracle_client/instantclient_${instaclient_version}"
if [[ -d "${ORACLE_HOME}" ]]; then
    export ORACLE_HOME
fi
ECLIPSE_HOME="/Applications/sts-eclipse"
if [[ -d "${ECLIPSE_HOME}" ]]; then
    export ECLIPSE_HOME
fi

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    #export EDITOR=/usr/bin/vim
# prefer neovim, alt vim
if [[ -x "/usr/local/bin/nvim" ]]; then
    export EDITOR="/usr/local/bin/nvim"
elif [[ -x "/usr/local/bin/vim" ]]; then
    export EDTOR="/usr/local/bin/vim"
elif [[ -x "/usr/bin/nvim" ]]; then
    export EDITOR="/usr/bin/nvim"
elif [[ -x "/usr/bin/vim" ]]; then
    export EDITOR="/usr/bin/vim"
else
    export EDITOR="/usr/bin/nano"
fi
# TODO: make these less skyleach-centric
# make some other guesses
export VEDITOR=/usr/local/bin/nyaovim
export VIMHOME=${HOME}/.vim
export NVIMHOME=${HOME}/.config/nvim
#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
#   export CLICOLOR=1
#   export LSCOLORS=ExFxBxDxCxegedabagacad

export WORKON_HOME="${HOME}/.virtualenvs/:${HOME}/Envs"
export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python3'
[[ -z "${PYENV_ROOT}" ]] || export PYENV_ROOT=${VIRTUALENVWRAPPER_PYTHON}
# shellcheck disable=SC1094
[[ -f "/usr/local/bin/virtualenvwrapper.sh" && -f /usr/bin/python3 ]] && . "/usr/local/bin/virtualenvwrapper.sh"
# source "$(brew --prefix pyenv-virtualenvwrapper)/bin/pyenv-sh-virtualenvwrapper"

# go envvar
export GOPATH="/Users/magregor/.gopath"

# python module options specific to me...
export ARCHFLAGS="-arch x86_64"

# homebrew bash completion
if [[ "${platform}" == "darwin" ]]; then
    # location on darwin with homebrew
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
else
    # location on most Linux machines
    [ -f /etc/bash_completion ] && . /etc/bash_completion
fi

# shellcheck disable=SC2155
GHOAPATH="${HOME}/.gh_oa"
[[ -f "${GHOAPATH}" ]] && export HOMEBREW_GITHUB_API_TOKEN=$(cat "${GHOAPATH}")

#HOMEBREW libarchive python fix
# export LD_LIBRARY_PATH="${brew_prefix}/opt/libarchive/lib"
# for cx_Oracle
if [ -z "${LD_LIBRARY_PATH}" ]; then export LD_LIBRARY_PATH="$ORACLE_HOME:${LD_LIBRARY_PATH}" else export LD_LIBRARY_PATH="$ORACLE_HOME"; fi
# export DYLD_LIBRARY_PATH="$LD_LIBRARY_PATH:${DYLD_LIBRARY_PATH}"
if [[ "${platform}" == "darwin" ]]; then
    [ -f "${brew_prefix}/opt/libarchive/lib/libarchive.13.dylib" ] && export LA_LIBRARY_FILEPATH="${brew_prefix}/opt/libarchive/lib/libarchive.13.dylib"
    # add an else IFF you need it for linux.  Should be found without this most of the time.
fi
# export LIBARCHIVE_PREFIX="${brew_prefix}/opt/libarchive"
# export C_INCLUDE_PATH=$(brew --cellar lzo)/2.09/include/lzo:$(brew --cellar lzo)/2.09/include/
# prefer usr/local for newer versions unless explicitly overridden in builds and linkers
export LIBRARY_PATH="/usr/local/lib:/usr/lib"

# shellcheck disable=SC1090
# this is darwin-only, but the -e should solve it
if [[ -e "${HOME}/.iterm2_shell_integration.bash" ]] && [[ "${platform}" == 'darwin' ]]; then
    . "${HOME}/.iterm2_shell_integration.bash"
fi

#finally let's try to keep any duplicates out of the path...
export PATH=$(echo -n "$PATH" | awk -v RS=':' -v ORS=':' '!a[$0]++' | sed 's/:$//')
# clean up extra environment variables
if [[ $platform == 'wsl' ]]; then
    # get a list of environment variables that are windows specific and not
    # needed in wsl

    unset $( env | grep -E '^(ALLUSERSPROFILE|APPDATA|CommonProgramFiles|CommonProgramFiles(x86)?|COMPUTERNAME|ComSpec|HOMEDRIVE|HOMEPATH|LOCALAPPDATA|LOGONSERVER|NUMBER_OF_PROCESSORS|OS|Path|PATHEXT|PROCESSOR_ARCHITECTURE|PROCESSOR_IDENTIFIER|PROCESSOR_LEVEL|PROCESSOR_REVISION|ProgramData|ProgramFiles(x86)?|PROMPT|PSModulePath|PUBLIC|SystemDrive|SystemRoot|TEMP|TMP|USERDOMAIN|USERDOMAIN_ROAMINGPROFILE|USERNAME|USERPROFILE|WINDIR)=' | awk -F= '{print $1}' )
    # pipe env through awk to strip the values from the envvars
    env | awk -F= '{print $1}'
fi
# set shell option histverify to on so we can edit history commands before executing
# not on mac?  find out later, not imp now.
# setopt -s histverify
# you can tell neovim to export by default, but this can cause issues if you use multiple sessions
# TRANS_SOCKET_LOC='/tmp/nvimsocket.tmp'
# if [ -f ${TRANS_SOCKET_LOC} ]; then
#     # shellcheck disable=SC2155
#     export NVIM_LISTEN_ADDRESS=$(cat ${TRANS_SOCKET_LOC})
# fi
# tsserver log
# TSS_LOG='-level verbose -file c:\tmp\tsserver.log'
# file defaults to __dirname\.log<PID>
# setting the log file *will* break VimR.app
# export TSS_LOG="-level verbose ${HOME}/tmp/tsserver.log"

case $- in #interactive
  *i*)
      # homebrew fortune :-) should already be in PATH
      if [ -f "/usr/local/bin/fortune" ] || [ -f "/usr/games/fortune" ]; then
          fortune -aoc
          # also just for kicks put a least one ascii
          fortune -aoc ascii-art
      fi;;
  *) # we aren't interactive, so nothing below here matters
      return
esac

# END EXPORTS, EVERYTHING ELSE INTERACTIVE OR WASTEFUL FOR NON-INTERACTIVE

#   -----------------------------
#   2.  MAKE INTERACTIVE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                         # Preferred 'cp' implementation
alias mv='mv -iv'                         # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                   # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp --color'             # Preferred 'ls' implementation
alias lw='ls -FGAhp --color'              # 'ls' but wide
alias less='less -FSRXc'                  # Preferred 'less' implementation
# function cd() { builtin cd "$@"; ll; }    # Always list directory contents upon 'cd'
function lcd() { builtin cd "$@"; ll; }       # Never list directory contents upon 'cd'
alias cd..='cd ../'                       # Go back 1 directory level (for fast typers)
alias ..='cd ../'                         # Go back 1 directory level
alias ...='cd ../../'                     # Go back 2 directory levels
alias .3='cd ../../../'                   # Go back 3 directory levels
alias .4='cd ../../../../'                # Go back 4 directory levels
alias .5='cd ../../../../../'             # Go back 5 directory levels
alias .6='cd ../../../../../../'          # Go back 6 directory levels
alias edit='"${EDITOR}"'                  # edit:         Opens any file in ${EDITOR}
alias vedit='"${VEDITOR}"'                # vedit:        Opens any file in ${VEDITOR}
alias f='open -a Finder ./'               # f:            Opens current directory in MacOS Finder
# alias ~="cd ${HOME}"                      # ${HOME}:            Go Home
alias c='clear'                           # c:            Clear terminal display
# alias which='type -all'                   # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'       # path:         Echo all executable Paths
alias show_options='shopt'                # Show_options: display bash options settings
alias fix_stty='stty sane'                # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On' # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }      # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ${HOME}/.Trash ; }   # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }  # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ${HOME}/Desktop/terminalOut.txt'  # DT:           Pipe content to file on MacOS Desktop
alias grep='grep --color'
alias vim='/usr/bin/env vim' #something on OSX is forcing /usr/bin/vim instead of my environment vim
# SkyLeach NOTE: work on hashing this out for better find on windows
# alias fh='find ./ -mindepth 1 -maxdepth 5 -regextype posix-extended'
# create fuckin aliases
[[ -e $(which thefuck 2>/dev/null) ]] && eval "$(thefuck --alias)"

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man "$1" | grep -iC2 --color=always "$2" | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 "$@" ${HOME}/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f "$1" ] ; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }


#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

function title {
    echo -ne "\033]0;"$*"\007"
}

#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }


#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#   ---------------------------------------
#   8.  WEB DEVELOPMENT
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }


#   ---------------------------------------
#   9.  REMINDERS & NOTES
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ${HOME}/Dev/Perl/randBytes 1048576 > 10MB.dat

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
##################################################################################
# TODO: convert to function: find + alias + sed + powershell command
# find . -mindepth 1 -maxdepth 1 -type d -name ".*" -print0 | xargs -0Ixxx wslpath -ma xxx | xargs -Ixxx $(alias powershell | sed -e "s/'//g" -e 's/alias powershell=//') -command "Add-MpPreference -ExclusionPath 'xxx'"
##################################################################################
# Python virtual environment settings
alias powershell=/mnt/c/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
