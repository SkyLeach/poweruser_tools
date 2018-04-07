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
    # export PS1="_☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠_\n| \w @ \h (\u) \n|💀> "
    export PS1="_☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠__☠_\n| \w @ work-mbp (abuser) \n|\T💀> "
    export PS2="|💀> "

#   Set Paths
#   ------------------------------------------------------------
# needed below.  Leave
export SHELL='/usr/local/bin/bash'
# start building out path requirements
[[ ":$PATH:" != *":~/sbin:${PATH}:"* ]] && PATH="~/sbin:${PATH}"
[[ ":$PATH:" != *":/usr/local/opt/openssl/bin:${PATH}:"* ]] && PATH="/usr/local/opt/openssl/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/Cellar/git/2.17.0/bin:${PATH}:"* ]] && PATH="/usr/local/Cellar/git/2.17.0/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/opt/mysql/bin:${PATH}:"* ]] && PATH="/usr/local/opt/mysql/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/opt/libxml2/bin:${PATH}:"* ]] && PATH="/usr/local/opt/libxml2/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/opt/ruby/bin:${PATH}:"* ]] && PATH="/usr/local/opt/ruby/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/bin:${PATH}:"* ]] && PATH="/usr/local/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/opt/qt@5.5/bin:${PATH}:"* ]] && PATH="/usr/local/opt/qt@5.5/bin:${PATH}"
[[ ":$PATH:" != *":/usr/local/sbin:${PATH}:"* ]] && PATH="/usr/local/sbin:${PATH}"
[[ ":$PATH:" != *":/sw/bin:"* ]] && PATH="/sw/bin:${PATH}"
export PATH
# Add QT to the path, but after system
# and make sure it's 5.5 due to linker issues
# legacy/secondary darwinports
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_71.jdk/Contents/Home
#    LDFLAGS:  -L/usr/local/opt/libxml2/lib
#    CPPFLAGS: -I/usr/local/opt/libxml2/include
#    LDFLAGS:  -L/usr/local/opt/qt/lib
#    CPPFLAGS: -I/usr/local/opt/qt/include
#For pkg-config to find this software you may need to set:
#    PKG_CONFIG_PATH: /usr/local/opt/libxml2/lib/pkgconfig

localpkgconfig="/usr/local/lib/pkgconfig"
# tempt dissable extras and try to write script to minimize imports
# localpkgconfig=":/usr/local/opt/atk/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/bash/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/cairo/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/ffmpeg/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/ffmpeg@3/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/fftw/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/fontconfig/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/freeglut/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/freetype/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/fribidi/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gdk-pixbuf/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/glew/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/glib/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gnu-scientific-library/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gobject-introspection/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/graphite2/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gsl/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gtk/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gtk+/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/gtk+3/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/harfbuzz/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/icu4c/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/ilmbase/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/isl/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/jemalloc/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/jpeg/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libarchive/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libass/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libcdio/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libevent/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libffi/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libidn2/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libjpeg/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libjpg/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libogg/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libpng/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libtermkey/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libtiff/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libusb/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libuv/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libvorbis/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libvpx/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libvterm/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libxml2/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/libxml2@2.9/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/luajit/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/lz4/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/lzo/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/mpfr/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/msgpack/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/mysql/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/mysql@5.7/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/oniguruma/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/opencv/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/opencv@3/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/openexr/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/openssl/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/openssl@1.0/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/openssl@1.1/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/opus/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/opusfile/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/pango/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/pcre/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/pcre1/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/pixman/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/postgres/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/postgresql/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/postgresql@10.2/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/python/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/python2/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/python3/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/python@2/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/python@3/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/qt/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/qt@5.5/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/qt@5.10/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/qt@5.9/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/sqlite/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/sqlite3/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/theora/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/unibilium/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/x264/lib/pkgconfig"
# localpkgconfig+=":/usr/local/opt/xz/lib/pkgconfig"
# localpkgconfig+="/usr/local/opt/sdl2/lib/pkgconfig"
# localpkgconfig+="/usr/local/opt/mlt/lib/pkgconfig"
if [ -z %{PKG_CONFIG_PATH} ]
then
    export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${localpkgconfig}"
else
    export PKG_CONFIG_PATH="${localpkgconfig}"
fi
# if [ -z %{PYTHONPATH} ]
# then
#     export PYTHONPATH="${PYTHONPATH}:$(brew --prefix)/lib/python3.6/site-packages"
# else
#     export PYTHONPATH="$(brew --prefix)/lib/python3.6/site-packages"
# fi
export ORACLE_HOME="/Users/magregor/Library/oracle_client/instantclient_12_1"
export ECLIPSE_HOME="/Applications/sts-eclipse"

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    #export EDITOR=/usr/bin/vim
    export EDITOR=/usr/local/bin/nvim

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

export WORKON_HOME="~/.virtualenvs/"
export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python3'
[[ -z %{PYENV_ROOT} ]] || export PYENV_ROOT=${VIRTUALENVWRAPPER_PYTHON}
[[ -f "/usr/local/bin/virtualenvwrapper.sh" ]] && . "/usr/local/bin/virtualenvwrapper.sh"
# source "$(brew --prefix pyenv-virtualenvwrapper)/bin/pyenv-sh-virtualenvwrapper"

# go envvar
export GOPATH="/Users/magregor/.gopath"

# python module options specific to me...
export ARCHFLAGS="-arch x86_64"

#homebrew bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export HOMEBREW_GITHUB_API_TOKEN=$(cat ~/.gh_oa)

#HOMEBREW libarchive python fix
# export LD_LIBRARY_PATH="$(brew --prefix)/opt/libarchive/lib"
# for cx_Oracle
[[ -z LD_LIBRARY_PATH ]] && export LD_LIBRARY_PATH="$ORACLE_HOME:${LD_LIBRARY_PATH}" || export LD_LIBRARY_PATH="$ORACLE_HOME"
# export DYLD_LIBRARY_PATH="$LD_LIBRARY_PATH:${DYLD_LIBRARY_PATH}"
export LA_LIBRARY_FILEPATH="$(brew --prefix)/opt/libarchive/lib/libarchive.13.dylib"
# export LIBARCHIVE_PREFIX="$(brew --prefix)/opt/libarchive"
# export C_INCLUDE_PATH=$(brew --cellar lzo)/2.09/include/lzo:$(brew --cellar lzo)/2.09/include/
export LIBRARY_PATH=/usr/local/lib

[[ -e "~/.iterm2_shell_integration.bash" ]] && . "~/.iterm2_shell_integration.bash"
# set shell option histverify to on so we can edit history commands before executing
# not on mac?  find out later, not imp now.
# setopt -s histverify
TRANS_SOCKET_LOC='/tmp/nvimsocket.tmp'
if [ -f ${TRANS_SOCKET_LOC} ]; then
    export NVIM_LISTEN_ADDRESS=$(cat ${TRANS_SOCKET_LOC})
fi
# tsserver log
# TSS_LOG='-level verbose -file c:\tmp\tsserver.log'
# file defaults to __dirname\.log<PID>
# setting the log file *will* break VimR.app
# export TSS_LOG="-level verbose ~/tmp/tsserver.log"

case $- in
  *i*)
      # homebrew fortune :-) should already be in PATH
      if [ -f "/usr/local/bin/fortune" ]; then
          fortune -ao
      fi;;
  *) # we aren't interactive, so nothing below here matters
      exit 0;;
esac

# END EXPORTS, EVERYTHING ELSE INTERACTIVE OR WASTEFUL FOR NON-INTERACTIVE

#   -----------------------------
#   2.  MAKE INTERACTIVE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias grep='grep --color'

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


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
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
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
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Python virtual environment settings
