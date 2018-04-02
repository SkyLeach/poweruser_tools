#!/usr/bin/env bash
FIND_CMD=$( echo "gfind . -not -iwholename '*.git*' -not -iwholename '*mypy*' -not -iwholename '*.egg' -not -iwholename '*.bam' -not -regex '.*\(\.png$\|\.jpg$\|\.gif$\|\.ttf$\|\.t*bz$\|\.t*gz$\|\.zip$\|\.pyc$\)' -type f -printf \"%p\"\n" )
echo $FIND_CMD
$( $FIND_CMD | xargs echo grep -i "$1" )

