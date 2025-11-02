#!/usr/bin/env sh
#  This isn't so much a real script as the beginnings of one intended to quickly
#  upgrade all packages on a wsl instance.
#  starting from apt list --upgradeable | awk '/upgradable from:/ {print $1}' |
#  sudo apt-get upgrade -
apt list --upgradeable | awk '/upgradable from:/ {print $1}' | sudo apt-get upgrade -
