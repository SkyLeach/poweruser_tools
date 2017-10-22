#!/usr/bin/env bash
# an ffmpeg wrapper script to extract a color pallet and then a video to an
# animated gif.  Optional user arguments

tmp=$(mktemp /tmp/palette.png)
trap "rm -f $tmp" 0
me=${0##*/}
vid="${@: -1}"
if  [ ! -f "${vid}" ]
then
    echo "Usage: [options] $me <vidfile> [scale-width]" >&2
    echo "Options:"
    echo "    -ss=###        : # of seconds to skip ahead in vidfile"
    echo "    -t=###         : Length, in seconds, of output gif"
    echo "    -w|--width=### : Rescale (lanczos) output retaining aspect ration to a maximum width of ###"
    echo "    -O=<outfile>   : The output gif will have the name supplied."
    exit 2
fi

# parse allowed arguments
for i in "$@"
do
    case $i in
        -ss=*)
        SS="-ss ${i#*=}"
        echo ${SS}
        ;;
        -t=*)
        T="-t ${i#*=}"
        echo ${T}
        ;;
        -O=*)
        OUT="${i#*=}"
        echo ${OUT}
        ;;
        -w=*|--width=*)
        WIDTH=",scale=${i#*=}"
        ;;
        *)
        ;;
    esac
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
