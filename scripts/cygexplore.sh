#!/bin/bash
# Simple script to launch windows explorer in the current working directory
# with properly converted windows path including spaces.
PWD="$(pwd)" RES=$(cygpath -w "${PWD}") && echo "${PWD} -> ${RES}"; explorer ${RES};

# TODO: modify this script to include passed path name instead of using cwd

