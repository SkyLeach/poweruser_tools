param(
    [string]$VidFile
)
${VidFileName} = [System.IO.Path]::GetFileNameWithoutExtension(${VidFile})

Write-Debug ffmpeg -ss 30 -t 3 -i ${VidFile} \
    -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 ${VidFileName}.gif

# just in case...
# ffmpeg -ss 30 -t 3 -i ${VidFile} \
#     -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
#     -loop 0 ${VidFileName}.gif
