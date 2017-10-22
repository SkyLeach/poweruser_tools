#!/usr/bin/env bash
#bash wrapper for windows/cygwin gvim

#####################################################################
## Cygwin/*nix and Windows gvim wrapper script, alias friendly, path friendly
## Author: Matt Gregory (skyleach (AT) geemale (dot) com)
## Version: 1.5
## Date: Thu Jun 12 10:02:54 2014
## Known Bugs:
## Changes:
##      Thu Jun 12 10:04:08 2014 : Initital posting to StackOverflow
#####################################################################

[[ -z ${WINVIM} ]] && WINVIM=true
[[ -z ${VIMRUN} ]] && export VIMRUN='' #scoping
if [[ ${WINVIM} = false ]]; then
    [[ ! ${VIMRUN} ]] && VIMRUN='/bin/gvim'
    ANS=$("${VIMRUN}" --serverlist | grep GVIM)
else
    [[ ! "${VIMRUN}" ]] && VIMRUN='/cygdrive/c/Program Files/vim/vim74/gvim'
    ANS=$(ps -Wsl | grep "${VIMRUN}" | sed -e "s/\s\+\([0-9]\+\).*/\1/g")
fi
[[ ! -z ${VIM} && ${WINVIM} = true ]] && export VIM=$(cygpath -wal "${VIM}")
RT="--remote-tab"
[[ $ANS ]] || unset RT
if [ ! -z ${DEBUG} ]; then
    echo "WINVIM: ${WINVIM}"
    echo "VIMRUN: ${VIMRUN}"
    echo "ANS: ${ANS}"
    echo "VIM: ${VIM}"
fi
#process arguments or stdin
if [ ${#} -ne 0 ]; then
    [[ ! -z ${DEBUG} ]] && echo "Got arguments [${#}]:'${@}'"
    for OFILE in "${@}"; do # if [ -f "${OFILE}" ] || [ -d "${OFILE}" ]; then
        [[ -h ${OFILE} ]] && OFILE="$(readlink -f "${OFILE}")"
        [[ ${WINVIM} == true ]] && OFILE=$(cygpath -wal "${OFILE}")
        echo "\"${VIMRUN}\" --servername GVIM $RT \"${OFILE}\""
        "${VIMRUN}" --servername GVIM $RT "${OFILE}" &
        if [[ -z ${RT} ]] || [[ ! "${RT}" ]]; then
            RT="--remote-tab"
            sleep 5 #give gvim time to start up, running too fast messes things up
        else
            sleep .3 #shorter sleep for tabs
        fi
        #fi
    done
else
    while read OFILE; do
        [[ -h ${OFILE} ]] && OFILE="$(readlink -f "${OFILE}")"
        [[ ${WINVIM} == true ]] && OFILE=$(cygpath -wal "${OFILE}")
        echo "\"${VIMRUN}\" --servername GVIM $RT \"${OFILE}\""
        "${VIMRUN}" --servername GVIM $RT "${OFILE}" &
        if [[ -z ${RT} ]] || [[ ! "${RT}" ]]; then
            RT="--remote-tab"
            sleep 3 #give gvim time to start up, running too fast messes things up
        else
            sleep .3 #shorter sleep for tabs
        fi
    done
fi
# vim: set filetype=sh:
