#!/bin/bash
# Really minimal shell script for replacing notepad.exe with vim from WSL
# STEP 1: back up notepad.exe locations.
npsys32="$(wslpath -au 'C:\Windows\System32\notepad.exe')"
npwin="$(wslpath -au 'C:\Windows\notepad.exe')"
echo mv -v "${npsys32}" "${npsys32%.exe}.bkup.exe"
sudo mv -v "${npsys32}" "${npsys32%.exe}.bkup.exe"
mret=$?
if [ $mret ]; then
    echo "failed!"
    exit $mret
else
    echo "success!" 
fi
echo mv -v  "${npwin}" "${npwin%.exe}.bkup.exe"
sudo mv -v  "${npwin}" "${npwin%.exe}.bkup.exe"
mret=$?
if [ $mret ]; then
    echo "failed!"
    exit $mret
else
    echo "success!" 
fi
# STEP 2: create windows-style symbolic links from the old name to the windows
# executable path for neovide
wincmd="$(which cmd.exe)"
echo ${wincmd} /c mklink "$(wslpath -aw ${npsys32})" "C:\Program Files\Neovide\neovide.exe"
sudo ${wincmd} /c mklink "$(wslpath -aw ${npsys32})" "C:\Program Files\Neovide\neovide.exe"
mret=$?
if [ $mret ]; then
    echo "failed!"
    exit $mret
else
    echo "success!" 
fi
echo ${wincmd} /c mklink "$(wslpath -aw ${npwin})" "C:\Program Files\Neovide\neovide.exe"
${wincmd} /c mklink "$(wslpath -aw ${npwin})" "C:\Program Files\Neovide\neovide.exe"
mret=$?
if [ $mret ]; then
    echo "failed!"
    exit $mret
else
    echo "success!" 
fi
