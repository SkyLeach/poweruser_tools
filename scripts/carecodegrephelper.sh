#!/bin/bash
# simple bash script for learning about the source trees

echo 'To find files and run a command against those files from within find
without piping the command...'
echo 'find . -type f -regex ".*\.\(java\|xml\|rb\|py\|js\|json\)" -exec \\'
echo '    grep "endpoints" "{}" \+'

# typescript and jsx files...
echo 'To find all sourcecode files in all projects use this find cmd:'
echo 'find . -type f -regex .*\.\(java\|xml\|rb\|py\|js\|json\|jsx\|ts\|tsx\|sql\|md\|txt\|html\)'
echo ''

echo 'Updating all projects...'
cwd="$(pwd)"
# switch directory to caregility codebase
CARECORE="$(readlink -f ~/src/caregility/)"
echo "Switching to Caregility home"
cd "${CARECORE}"
for proj in $(find . -mindepth 1 -maxdepth 1 -type d); do
    echo -n "Updating ${proj}..."
    cd "${proj}"
    git pull
    cd ..
    [[ $? ]] && echo "SUCCESS!" || echo "FAILED!"
done
echo "Returning to start path..."
cd -v "${cwd}"

# replace unix symlinks with windows symlinks in wsl/wsl2
# POSIX softlink format: ln -s [target] [linkfile]
# WIN softlink format: mklink [target] [linkfile] or mklnk /D [target]
# [linkfile] (the /D is for directory
# so... in order to avoid coding all of this out... simply run cygwin and let
# it handle the problem.
for link in $(find . -mindepth 1 -maxdepth 1 -type l); do
    # so basically we need to get the link name and the link target in order to
    # reformat
    echo "${link}"
done
