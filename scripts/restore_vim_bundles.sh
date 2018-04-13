#!/usr/bin/env bash
# vim: ts=4 sw=4 sts=4 et nofoldenable
# parse options
# tmp=$(mktemp /tmp/palette.png)
# trap "rm -f $tmp" 0
me=${0##*/}
if [ $(pushd $(dirname "${0}" > /dev/null 2>&1 ) > /dev/null 2>&1 ) ]; then
    mepath=$(pwd)
    popd > /dev/null
else
    mepath=$(dirname "${0}")
fi

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

show_help() {
    echo "Usage: [options] $me" >&2
    echo "    uses git clone to restore your bundles in your "+'$VIMHOME'+" and/or "+'$NVIMHOME'
    echo "Options:"
    echo "    -h|--help:    print this help message"
    echo "    -n|--nvim:    only operate on "+'${NVIMHOME}'
    echo "    -v|--vim:     only operate on "+'${VIMHOME}'
    echo "    -O <outfile>: Reads and outputs the list of remotes named 'origin'."
    exit 2
}
# parse allowed arguments
# for i in "$@"
# do
#    case $i in
while :; do
    case $1 in
        -h|--help)
            show_help
            die 'ERROR: "-w|--width" requires a non-empty option argument'
        ;;
        -n)
            onlyon="${NVIMHOME}/bundle"
        ;;
        -v)
            onlyon="${VIMHOME}/bundle"
        ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *) # Default case: No more options, so break out of the loop.
            break
    esac
    shift
done
if [ -z "${VIMHOME}" ] && [ -z "${NVIMHOME}" ]; then 
    die "Cowardly refusing to do anything because you haven't set *any* VIMHOME or NVIMHOME." 
elif [ -L "${VIMHOME}/bundle" ] || [ -L "${NVIMHOME}/bundle" ]; then
    # see if they point to each other
    vimblink="$(readlink -n "${VIMHOME}/bundle")"
    nvimblink="$(readlink -n "${NVIMHOME}/bundle")"
    if [ -z "${vimblink}" ]; then
        # vim bundle dir is no link
        left="${VIMHOME}/bundle"
        right="${nvimblink}"
    elif [ -z "${nvimblink}" ]; then
        # nvim bundle dir is no link
        left="${vimblink}"
        right="${NVIMHOME}/bundle"
    else
        # both are links
        left="${vimblink}"
        right="${nvimblink}"
    fi
    if [ "${left}" == "${right}" ]; then
        # doesn't matter, go with right
        onlyon="${right}"
        workon=("${onlyon}")
    fi
elif [ ! -z "${onlyon}" ]; then
    # if onlyon is set then we're good
    workon=("${onlyon}")
elif [ -z "${VIMHOME}" ]; then
    # make workon point to nvimhome/bundle
    workon=("${NVIMHOME}/bundle")
else
    # make workon point to vimhome/bundle
    workon=("${VIMHOME}/bundle")
fi
cwd_save=$(pwd)
# die "${!workon[*]}"
for target in "${workon[@]}"; do
    cd "${target}"
    while read -r origin; do
        reponame=$(basename -s .git -- "${origin}")
        if [ -d "${reponame}" ]; then
            echo "${reponame} exists, skipping..."
            continue
        else
            echo "${reponame} missing, clonging..."
        fi
    done < "${mepath}/../config_files/pathogen_bundles.txt"
    cd ..
done
cd "${cwd_save}"
exit 0
