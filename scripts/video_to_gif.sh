#!/usr/bin/env bash
# an ffmpeg wrapper script to extract a color pallet and then a video to an
# animated gif.  Optional user arguments

tmp=$(mktemp /tmp/palette.png)
trap "rm -f $tmp" 0
me=${0##*/}
vid="${@: -1}"
if  [ ! -f "${vid}" ]
then
    show_help # display options
fi

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

show_help() {
    echo "Usage: [options] $me <vidfile> [scale-width]" >&2
    echo "Options:"
    echo "    -ss ###        : # of seconds to skip ahead in vidfile"
    echo "    -t ###         : Length, in seconds, of output gif"
    echo "    -w|--width ### : Rescale (lanczos) output retaining aspect ration to a maximum width of ###"
    echo "    -O <outfile>   : The output gif will have the name supplied."
    exit 2
}
# parse allowed arguments
# for i in "$@"
# do
#    case $i in
while :; do
    case $1 in
        -ss)
            if [ "$2" ]; then
                SS="-ss $2"
                shift
            else
                die 'ERROR: "-ss" requires a non-empty option argument'
            fi
        ;;
        -ss=*)
            SS="-ss ${1#*=}"
            echo ${SS}
        ;;
        -ss=)
            die 'ERROR: "-ss" requires a non-empty option argument'
        ;;
        -t)
            if [ "$2" ]; then
                T="-t $2"
                shift
            else
                die 'ERROR: "-t" requires a non-empty option argument'
            fi
        ;;
        -t=*)
            T="-t ${1#*=}"
            echo ${T}
        ;;
        -t=)
            die 'ERROR: "-t" requires a non-empty option argument'
        ;;
        -O)
            if [ "$2" ]; then
                OUT="$2"
                shift
            else
                die 'ERROR: "-O" requires a non-empty option argument'
            fi
        ;;
        -O=*)
            OUT="${1#*=}"
            echo ${OUT}
        ;;
        -O=)
            die 'ERROR: "-O" requires a non-empty option argument'
        ;;
        -w|--width)
            if [ "$2" ]; then
                WIDTH=",scale=$2"
                shift
            else
                die 'ERROR: "-w|--width" requires a non-empty option argument'
            fi
        ;;
        -w=*|--width=*)
            WIDTH=",scale=${1#*=}"
        ;;
        -w=|--width=)
            die 'ERROR: "-w|--width" requires a non-empty option argument'
        ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *) # Default case: No more options, so break out of the loop.
            break
    esac
    shift
done

# if output not set, set it
if [ -z $OUT ]
then
   OUT=$(basename ${vid})
   OUT="${OUT%.*}.gif"
fi

ffmpeg -y ${SS} ${T} -i "${vid}" \
    -vf fps=10${WIDTH}:-1:flags=lanczos,palettegen "${tmp}"

ffmpeg ${SS} ${T} -i "${vid}" -i "${tmp}" -filter_complex \
    "fps=10${WIDTH}:-1:flags=lanczos[x];[x][1:v]paletteuse" ${OUT}
