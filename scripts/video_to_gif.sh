#!/usr/bin/env bash
# an ffmpeg wrapper script to extract a color pallet and then a video to an
# animated gif.  Optional user arguments
die() {
    printf '%s\n' "$1" >&2
    exit 1
}
show_help() {
    echo "${1}"
    echo "Usage: [options] $me <vidfile> [scale-width]" >&2
    echo "Options:"
    echo "    -ss ###        : # of seconds to skip ahead in vidfile"
    echo "    -t ###         : Length, in seconds, of output gif"
    echo "    -w|--width ### : Rescale (lanczos) output retaining aspect ration to a maximum width of ###"
    echo "    -O <outfile>   : The output gif will have the name supplied."
    exit 2
}
# initial config, first argument
me="${0##*/}"
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
    case $key in
        -ss)
            if [ "$2" ]; then
                SS="-ss $2"
                shift
            else
                show_help 'ERROR: "-ss" requires a non-empty option argument'
            fi
        ;;
        -ss=)
            show_help 'ERROR: "-ss" requires a non-empty option argument'
        ;;
        -ss=*)
            SS="-ss ${1#*=}"
            echo "${SS}"
        ;;
        -t)
            if [ "$2" ]; then
                T="-t $2"
                shift
            else
                show_help 'ERROR: "-t" requires a non-empty option argument'
            fi
        ;;
        -t=)
            show_help 'ERROR: "-t" requires a non-empty option argument'
        ;;
        -t=*)
            T="-t ${1#*=}"
            echo "${T}"
        ;;
        -O)
            if [ "$2" ]; then
                OUT="$2"
                shift
            else
                show_help 'ERROR: "-O" requires a non-empty option argument'
            fi
        ;;
        -O=)
            show_help 'ERROR: "-O" requires a non-empty option argument'
        ;;
        -O=*)
            OUT="${1#*=}"
            echo "${OUT}"
        ;;
        -w|--width)
            if [ "$2" ]; then
                WIDTH=",scale=$2"
                shift
            else
                show_help 'ERROR: "-w|--width" requires a non-empty option argument'
            fi
        ;;
        -w=|--width=)
            show_help 'ERROR: "-w|--width" requires a non-empty option argument'
        ;;
        -w=*|--width=*)
            WIDTH=",scale=${1#*=}"
        ;;
        -h|--help)
            show_help
            exit 0
        ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)  # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
    shift
done
set -- "${POSITIONAL[@]}" # restore positional parameters
# vid="${@: -1}"
vid="${1}"
if [ -z "${vid}" ] || [ ! -f "${vid}" ]; then
    show_help "You must provide a video file to operate on." # display options
fi
tmp=$(mktemp /tmp/palette.png)
trap 'rm -f $tmp' 0
echo "vid = ${vid}"
echo "out = ${OUT}"
# show_help "You should have stopped already."
# if output not set, set it
if [ -z "$OUT" ]
then
   OUT=$(basename "${vid}")
   OUT="${OUT%.*}.gif"
fi

ffmpeg -y "${SS}" "${T}" -i "${vid}" \
    -vf "fps=10${WIDTH}:-1:flags=lanczos,palettegen" "${tmp}"

ffmpeg "${SS}" "${T}" -i "${vid}" -i "${tmp}" -filter_complex \
    "fps=10${WIDTH}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${OUT}"
